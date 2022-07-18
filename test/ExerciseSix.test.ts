import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Factory } from "./utils/contracts";
import { ExerciseSix } from '../src/types/';
import { hasEmittedEvent, assertErrorMessage } from "./utils/utils";
import { utils } from "ethers";

describe("Tests of ExerciseSix logic and storage", async() => {

    let admin : SignerWithAddress;
    let gary : SignerWithAddress;
    let drock : SignerWithAddress;
    let contract : ExerciseSix;

    beforeEach(async() => {
        contract = <any> await Factory["ExerciseSix"]();
        [ admin, gary, drock ] = await ethers.getSigners();
    });

    it("Should buy tokens for ether", async() => {

        const tx = contract.connect(gary)
            .buyTokens(12, {value: ethers.utils.parseUnits("12", "gwei")});
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "TokenPurchase", [gary.address, 12, 1 * 10**9]);

        expect(await contract.balanceOf(gary.address)).to.be.equal(12);
    });

    it("Should change buy price of token", async() => {

        const tx = contract.connect(admin)
            .changeBuyPrice(ethers.utils.parseUnits("6", "gwei"));
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "TokenBuyPriceChanged", [admin.address, 6 * 10**9]);
    
        const [buyPrice, sellPrice] = await contract.prices();

        expect(buyPrice).to.be.equal(ethers.utils.parseUnits("6", "gwei"));
        expect(sellPrice).to.be.equal(ethers.utils.parseUnits("0.5", "gwei"));

    });

    it("Should block when buy price is lower than sell price", async() => {

        const tx = contract.connect(admin)
            .changeBuyPrice(ethers.utils.parseUnits("0.25", "gwei"));
            
        await assertErrorMessage(tx, "Buy price cannot be smaller than Sell price");

    });

    it("Should sell tokens for ether", async() => {

        {
            const tx = contract.connect(gary)
                .buyTokens(12, {value: ethers.utils.parseUnits("12", "gwei")});
        }

        {
            const tx = contract.connect(gary)
                .sellTokens(12, {value: ethers.utils.parseUnits("12", "gwei")});
            const result = await (await tx).wait();
            expect(result.status).to.be.equal(1);

            await hasEmittedEvent(tx, "TokenSale", [gary.address, 12, 0.5 * 10**9]);
        }
    
    });

  
    it("Should change sell price of token", async() => {

        const tx = contract.connect(admin)
            .changeSellPrice(ethers.utils.parseUnits("0.75", "gwei"));
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "TokenSellPriceChanged", [admin.address, 0.75 * 10**9]);

        const [buyPrice, sellPrice] = await contract.prices();

        expect(buyPrice).to.be.equal(ethers.utils.parseUnits("1", "gwei"));
        expect(sellPrice).to.be.equal(ethers.utils.parseUnits("0.75", "gwei"));

    });

    it("Should block when sell price is higher than buy price", async() => {

        const tx = contract.connect(admin)
            .changeSellPrice(ethers.utils.parseUnits("2", "gwei"));

        await assertErrorMessage(tx, "Sell price cannot be larger than Buy price");

    });

    it("Should withdraw ether from contract", async() => {

        {   
        const tx = contract.connect(gary)
            .buyTokens(12, {value: ethers.utils.parseUnits("12", "gwei")});
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);
        }

        {
        const tx = contract.connect(admin)
            .withdraw(ethers.utils.parseUnits("4", "gwei"));
        
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "ETHWithdrawn", [admin.address, 4 * 10**9]);
        }
    });

    
    it("Should block withdrawal ether from contract when it's not enough to buy tokens back", async() => {

        {   
        const tx = contract.connect(gary)
            .buyTokens(12, {value: ethers.utils.parseUnits("12", "gwei")});
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);
        }

        {
        const tx = contract.connect(admin)
            .withdraw(ethers.utils.parseUnits("12", "gwei"));

        await assertErrorMessage(tx, "The amount of ether to withdraw exceeds cost of tokens left");
        }
    });

});