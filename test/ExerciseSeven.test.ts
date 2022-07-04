import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Factory } from "./utils/contracts";
import { ExerciseSeven } from '../src/types/';
import { hasEmittedEvent, assertErrorMessage } from "./utils/utils";
import { utils } from "ethers";

describe("Tests of ExerciseSeven logic and storage", async() => {

    let admin : SignerWithAddress;
    let gary : SignerWithAddress;
    let drock : SignerWithAddress;
    let contract : ExerciseSeven;

    beforeEach(async() => {
        contract = <any> await Factory["ExerciseSeven"]();
        [ admin, gary, drock ] = await ethers.getSigners();
    });

    it("Should...", async() => {

        const tx = contract.connect(admin).grantRole(gary.address, 0x01);
         
     
    });
    

});