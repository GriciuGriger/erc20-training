import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Factory } from "./utils/contracts";
import { ExerciseTwo } from '../src/types/';
import { hasEmittedEvent, assertErrorMessage } from "./utils/utils";

describe("Tests of ExerciseTwo logic and storage", async() => {

    let admin : SignerWithAddress;
    let gary : SignerWithAddress;
    let contract : ExerciseTwo;

    beforeEach(async() => {
        contract = <any> await Factory["ExerciseTwo"]();
        [ admin, gary ] = await ethers.getSigners();
    });

    it("Should deploy contract", async function () {

        expect(await contract.symbol()).to.be.equal("TEST2");
        expect(await contract.name()).to.be.equal("4soft Training ERC20 Contract");
        expect(await contract.decimals()).to.be.equal(18);
        expect(await contract.totalSupply()).to.be.equal(0);

    });

    it("Should mint tokens", async() => {

        const tx = contract.connect(admin)
            .mint(gary.address, 1000);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "TokenMinted", [admin.address, gary.address, 1000]);

        const balance = await contract.balanceOf(gary.address);
        expect(balance).to.be.equal(1000);

        const totalSupply = await contract.totalSupply();
        expect(totalSupply).to.be.equal(1000); 

    });

    it("Should not mint tokens", async() => {
        
        const tx = contract.connect(admin)
        .mint(gary.address, 0);
        await assertErrorMessage(tx, 'Cannot mint 0 tokens');

    });

    it("Should burn tokens", async() => {

        {
            const tx = contract.connect(admin)
                .mint(gary.address, 1000);
            const result = await (await tx).wait();
            expect(result.status).to.be.equal(1);
        }

        {
            const tx = contract.connect(admin)
                .burn(gary.address, 750);
            const result = await (await tx).wait();
            expect(result.status).to.be.equal(1);

            await hasEmittedEvent(tx, "TokenBurnt", [gary.address, admin.address, 750]);

            const balance = await contract.balanceOf(gary.address);
            expect(balance).to.be.equal(250);
    
            const totalSupply = await contract.totalSupply();
            expect(totalSupply).to.be.equal(250); 
        }
 
    });

    it("Should not burn tokens", async() => {
        
        const tx = contract.connect(admin)
        .burn(gary.address, 1);
        await assertErrorMessage(tx, 'Burn amount exceeds balance');

    });

});