import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Factory } from "./utils/contracts";
import { ExerciseFive } from '../src/types/';
import { hasEmittedEvent, assertErrorMessage } from "./utils/utils";
import { time } from "console";

describe("Tests of ExerciseFive logic and storage", async() => {

    let admin : SignerWithAddress;
    let gary : SignerWithAddress;
    let drock : SignerWithAddress;
    let contract : ExerciseFive;

    beforeEach(async() => {
        contract = <any> await Factory["ExerciseFive"]();
        [ admin, gary, drock ] = await ethers.getSigners();
    });

    it("Should block transfer when user is time-locked", async() => {
        
        {
            const adminSigner = contract.connect(admin);

            const tx = adminSigner.timelock(gary.address, 8);

            const tx2 = adminSigner.transfer(gary.address, 8);
    
            await hasEmittedEvent(tx, "TimeLocked", [gary.address, 8]);

            await assertErrorMessage(tx2, "ExerciseFive: this address is timelocked")


            

        //     const tx2 = contract.connect(admin)
        //         .transfer(gary.address, 3000);
           

        }

    });


});