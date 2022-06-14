import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Factory } from "./utils/contracts";
import { ExerciseFour } from '../src/types/';
import { hasEmittedEvent, assertErrorMessage } from "./utils/utils";

describe("Tests of ExerciseThree logic and storage", async() => {

    let admin : SignerWithAddress;
    let gary : SignerWithAddress;
    let drock : SignerWithAddress;
    let contract : ExerciseFour;

    beforeEach(async() => {
        contract = <any> await Factory["ExerciseFour"]();
        [ admin, gary, drock ] = await ethers.getSigners();
    });

    it("Should deploy contract", async() => {

        expect(await contract.isPaused()).to.be.equal(false);

    });

    it("Should pause the contract", async() => {

        const tx = contract.connect(admin)
            .pause();
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "Paused", [admin.address]);

        expect(await contract.isPaused()).to.be.equal(true);

    });

    it("Should unpause the contract", async() => {

        {
        const tx = contract.connect(admin)
            .pause();
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);
        }

        {

        const tx = contract.connect(admin)
            .unpause();
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "Unpaused", [admin.address]);

        expect(await contract.isPaused()).to.be.equal(false);

        }

    });

    it("Should not pause when it's already paused", async() => {

        {
        const tx = contract.connect(admin)
            .pause();
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);
        }

        {
        const tx = contract.connect(admin)
            .pause();
    
        assertErrorMessage(tx, "ExerciseFour: paused");
        }

    });

    it("Should not unpause when it's already unpaused", async() => {

        const tx = contract.connect(admin)
            .unpause();
    
        assertErrorMessage(tx, "ExerciseFour: not paused");

    });

    it("Should not pause/unapuse if not owner", async() => {

        {
        const tx = contract.connect(gary)
            .pause();

        assertErrorMessage(tx, "ExerciseThree: caller is not the owner");
        }

        {
        const tx = contract.connect(gary)
            .unpause();

        assertErrorMessage(tx, "ExerciseThree: caller is not the owner");
        }
    });

    it("Should not transfer/transferFrom if paused", async() => {

        {
        const tx = contract.connect(admin)
            .pause();
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);
        }

        {
        const tx = contract.connect(admin)
            .transfer(gary.address, 30000);

        assertErrorMessage(tx, "ExerciseFour: paused");
        }

        {
        const tx = contract.connect(admin)
            .transferFrom(gary.address, drock.address, 30000);

        assertErrorMessage(tx, "ExerciseFour: paused");
        }
    });

});
