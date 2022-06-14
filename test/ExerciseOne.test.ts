import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Factory } from "./utils/contracts";
import { ExerciseOne } from '../src/types/';
import { hasEmittedEvent, assertErrorMessage } from "./utils/utils";

describe("Tests of ExerciseOne logic and storage", async() => {

    let admin : SignerWithAddress;
    let gary : SignerWithAddress;
    let drock : SignerWithAddress;
    let contract : ExerciseOne;

    beforeEach(async() => {
        contract = <any> await Factory["ExerciseOne"]();
        [ admin, gary, drock ] = await ethers.getSigners();
    });

    it("Should deploy contract and initialize storage", async function () {

        expect(await contract.symbol()).to.be.equal("TEST1");
        expect(await contract.name()).to.be.equal("4soft Training ERC20 Contract");
        expect(await contract.decimals()).to.be.equal(18);
        expect(await contract.totalSupply()).to.be.equal(1000000);

        expect(await contract.balanceOf(admin.address)).to.be.equal(1000000);

    })

    it("Allow simple transfers", async() => {
        const tx = contract.connect(admin).transfer(gary.address, 1000);
        const result = await (await tx).wait();
                    
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "Transfer", [admin.address, gary.address, 1000]);

        const senderBalance = await contract.balanceOf(admin.address);
        expect(senderBalance).to.be.equal(999000);
        
        const recipientBalance = await contract.balanceOf(gary.address);
        expect(recipientBalance).to.be.equal(1000);

    });

    it('Don`t allow transfering more than you have', async() => {
              
        const tx = contract.connect(admin).transfer(gary.address, 21000001);
        await assertErrorMessage(tx, 'Transfer amount exceeds balance');

    });

    it('Don`t allow transfering 0', async() => {
        
        const tx = contract.connect(admin).transfer(gary.address, 0);
        await assertErrorMessage(tx, '0 money transfer not allowed');

    });

    it('Approve funds to be allowed', async() => {

        const tx = contract.connect(admin).approve(gary.address, 1000);
        const result = await (await tx).wait();

        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "Approval", [admin.address, gary.address, 1000]);

        const allowance = await contract.allowance(admin.address, gary.address);
        expect(allowance).to.be.equal(1000);

    });

    it('Transfer allowed amount', async() => {

        {
            const tx = contract.connect(admin).approve(gary.address, 100000);
            const result = await (await tx).wait();
    
            expect(result.status).to.be.equal(1);
    
            await hasEmittedEvent(tx, "Approval", [admin.address, gary.address, 100000]);
        }
        
        {
            const tx = contract.connect(gary).transferFrom(admin.address, drock.address, 75000);
            const result2 = await (await tx).wait();
    
            await hasEmittedEvent(tx, "Transfer", [admin.address, drock.address, 75000]); 
        }

        {
            const aBalance = await contract.balanceOf(admin.address);
            expect(aBalance).to.be.equal(925000);
            
            const bBalance = await contract.balanceOf(drock.address);
            expect(bBalance).to.be.equal(75000);
    
            const allowance = await contract.allowance(admin.address, gary.address);
            expect(allowance).to.be.equal(25000);
        } 

    });

    it('Should not allow transfer unallowed amount', async() => {

        {
            const tx = contract.connect(admin).approve(gary.address, 500000);
            const result = await (await tx).wait();

            expect(result.status).to.be.equal(1);
        }

        {
            const tx = contract.connect(gary).transferFrom(admin.address, drock.address, 500001);
            await assertErrorMessage(tx, 'Transfer amount exceeds allowance');
        }

    });

    it('Should not allow transfer amount exceeding balance', async() => {

        {
            const tx = contract
            .connect(gary)
            .approve(drock.address, 10000);
            const result = await (await tx).wait();
            expect(result.status).to.be.equal(1);
        }

        {
            const tx = contract
            .connect(admin)
            .transfer(gary.address, 1000);
            const result = await (await tx).wait();
            expect(result.status).to.be.equal(1);
        }
 
        {
            const tx = contract
            .connect(drock)
            .transferFrom(gary.address, drock.address, 1001);
            await assertErrorMessage(tx, 'Transfer amount exceeds balance');
        }
    });
});