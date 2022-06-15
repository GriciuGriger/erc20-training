import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Factory } from "./utils/contracts";
import { ExerciseFive } from '../src/types/';
import { hasEmittedEvent, assertErrorMessage, increaseTime } from "./utils/utils";
import { time } from "console";
import { connect } from "http2";

describe("Tests of ExerciseFive logic and storage", async() => {

    let admin : SignerWithAddress;
    let gary : SignerWithAddress;
    let drock : SignerWithAddress;
    let contract : ExerciseFive;

    beforeEach(async() => {
        contract = <any> await Factory["ExerciseFive"]();
        [ admin, gary, drock ] = await ethers.getSigners();
    });

    it("Should pause the address", async() => {

        const tx = contract.connect(admin)
        .pauseAddress(gary.address);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "AddressPaused", [gary.address]);

        expect(await contract.checkIfPaused(gary.address)).to.be.equal(true);

    });

    it("Should not pause when already pasued", async() => {

        {
        const tx = contract.connect(admin)
            .pauseAddress(gary.address);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);
        }

        {
        const tx = contract.connect(admin)
            .pauseAddress(gary.address);
        await assertErrorMessage(tx, "ExerciseFive: this address is paused");
        }

    });

    it("Should block out transfer when paused", async() => {

        {
        const tx = contract.connect(admin)
            .pauseAddress(gary.address);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);
        }

        {
        const tx = contract.connect(gary)
            .transfer(drock.address, 3000);

        await assertErrorMessage(tx, "ExerciseFive: this address is paused");
        }

        {
        const tx = contract.connect(admin)
            .transferFrom(gary.address, drock.address, 3000);
    
        await assertErrorMessage(tx, "ExerciseFive: this address is paused");
        }
    
    });

    it("Should unpause the address", async() => {

        {
        const tx = contract.connect(admin)
            .pauseAddress(gary.address);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);
        }
    
        {
        const tx = contract.connect(admin)
            .unpauseAddress(gary.address);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "AddressUnpaused", [gary.address]);

        expect(await contract.checkIfPaused(gary.address)).to.be.equal(false);
        }

    });

    it("Should not unpause when already unpasued", async() => {

        const tx = contract.connect(admin)
            .unpauseAddress(gary.address);
        await assertErrorMessage(tx, "ExerciseFive: this address is unpaused");
        
    });

    it("Should inpause (pause in both directions) the address", async() => {

        const tx = contract.connect(admin)
            .pauseBoth(gary.address);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "AddressBothDirectionsPaused", [gary.address]);

        expect(await contract.checkIfInpaused(gary.address)).to.be.equal(true);

    });

    it("Should not inpause when already inpaused", async() => {

        {
        const tx = contract.connect(admin)
            .pauseBoth(gary.address);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);
        }

        {
        const tx = contract.connect(admin)
            .pauseBoth(gary.address);

        await assertErrorMessage(tx, "ExerciseFive: this address is inpaused");
        }

    });

    it("Should block in and out transfers when inpaused", async() => {

        {
        const adminSigner = contract.connect(admin);
        const tx = adminSigner.pauseBoth(gary.address);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);
        }

        {
        const tx = contract.connect(gary)
            .transfer(drock.address, 3000);

        await assertErrorMessage(tx, "ExerciseFive: this address is paused");
        }

        {
        const tx = contract.connect(admin)
            .transfer(gary.address, 30000);

        await assertErrorMessage(tx, "ExerciseFive: this address is inpaused");
        }

        {
        const tx = contract.connect(admin)
            .transferFrom(gary.address, drock.address, 30000);

        await assertErrorMessage(tx, "ExerciseFive: this address is paused");
        }

        {
        const tx = contract.connect(admin)
            .transferFrom(drock.address, gary.address, 30000);

        await assertErrorMessage(tx, "ExerciseFive: this address is inpaused");
        }

    });

    it("Should uninpause the inpaused address", async() => {

        {
        const tx = contract.connect(admin)
            .pauseBoth(gary.address);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);
        }
        
        {
        const tx = contract.connect(admin)
            .unpauseBoth(gary.address);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "AddressBothDirectionsUnpaused", [gary.address]);

        expect(await contract.checkIfInpaused(gary.address)).to.be.equal(false);
        }
    });
    
    it("Should not uninpause when already uninpaused", async() => {

        const tx = contract.connect(admin)
            .unpauseBoth(gary.address);

        await assertErrorMessage(tx, "ExerciseFive: this address is not inpaused");
    });

    it("Should block transfer when user is time-locked", async() => {
        
        {
        const tx = contract.connect(admin)
            .timelock(gary.address, 8)
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "TimeLocked", [gary.address, 8]);
        }

        {
        const tx = contract.connect(admin)
        .transfer(gary.address, 30000);

        await assertErrorMessage(tx, "ExerciseFive: this address is timelocked");
        }
    });

    it("Should not block transfer after locktime expiry", async() => {

        {
        const tx = contract.connect(admin)
            .timelock(gary.address, 8)
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);

        await hasEmittedEvent(tx, "TimeLocked", [gary.address, 8]);
        }
    
        {
        
        increaseTime(10);
 
        const tx = contract.connect(admin)
            .transfer(gary.address, 30000);
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);
        
        await hasEmittedEvent(tx, "LockTimeExpiry", [gary.address]);
        }
        
    });

    it("Should block transfer when address is still locked", async() => {

        {
        const tx = contract.connect(admin)
            .timelock(gary.address, 8)
        const result = await (await tx).wait();
        expect(result.status).to.be.equal(1);
    
        await hasEmittedEvent(tx, "TimeLocked", [gary.address, 8]);
        }
    
        increaseTime(6);
    
        {
        const tx = contract.connect(admin)
            .transfer(gary.address, 30000);
    
        await assertErrorMessage(tx, "ExerciseFive: this address is timelocked");
        }
        
    });

});