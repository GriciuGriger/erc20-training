import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Factory } from "./utils/contracts";
import { ExerciseThree } from '../src/types/';
import { hasEmittedEvent, assertErrorMessage } from "./utils/utils";

describe("Tests of ExerciseThree logic and storage", async() => {

    let admin : SignerWithAddress;
    let gary : SignerWithAddress;
    let contract : ExerciseThree;

    beforeEach(async() => {
        contract = <any> await Factory["ExerciseThree"]();
        [ admin, gary ] = await ethers.getSigners();
    });

    it("Should deploy contract and initialize owner", async() => {

        expect(await contract.owner()).to.be.equal(admin.address);

    });
    
    it("Should let other accounts accept ownership", async() => {

        const tx = contract.connect(gary)
            .acceptOwnership(true);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

    });

    it("Should successfully change the owner", async() => {

        {
        const tx = contract.connect(gary)
            .acceptOwnership(true);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);
        }
   
        {
        const tx = contract.connect(admin)
            .transferOwnership(gary.address);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "OwnershipTransferred", [admin.address, gary.address]);

        const newOwner = await contract.owner();
        expect(newOwner).to.be.equal(gary.address);
        }
    });

    it("Should renounce the ownership", async() => {

        const tx = contract.connect(admin)
            .renounceOwnership();
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "OwnershipTransferred", [admin.address, ethers.constants.AddressZero]);

        const newOwner = await contract.owner();
        expect(newOwner).to.be.equal(ethers.constants.AddressZero);

    });

    
    it("Should not let non-owner to transfer ownership", async() => {

        const tx = contract.connect(gary)
            .transferOwnership(gary.address);

        assertErrorMessage(tx, "ExerciseThree: caller is not the owner");

    });

    it("Should not let admin to transfer ownership when user doesn't accept it", async() => {

        const tx = contract.connect(admin)
            .transferOwnership(gary.address);

        assertErrorMessage(tx, "ExerciseThree: new owner is not accepting granted ownership");

    });

    it("Should not let use mint/burn if not owner", async() => {

        const tx = contract.connect(gary)
            .mint(gary.address, 30000);

        assertErrorMessage(tx, "ExerciseThree: caller is not the owner");

    });

});
