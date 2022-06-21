import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Factory } from "./utils/contracts";
import { ExerciseSix } from '../src/types/';
import { hasEmittedEvent, assertErrorMessage } from "./utils/utils";

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
            .buyTokens(10);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "TokenPurchase", [gary.address, 10, 1 * 10**9]);

    });

});