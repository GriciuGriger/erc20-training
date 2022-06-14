import { Contract } from "@ethersproject/contracts";
import { ethers } from "hardhat";

export const Factory : { [contractName : string]: () => Promise<Contract> } = {
    ExerciseOne: async() => {
        const [ admin ] = await ethers.getSigners();

        const contractFactory = await ethers.getContractFactory('ExerciseOne', admin);
        const contract : Contract = <any> await contractFactory.deploy("TEST1", "4soft Training ERC20 Contract", 18, 1000000);
        await contract.deployed();

        return contract;
    },
    ExerciseTwo: async() => {
        const [ admin ] = await ethers.getSigners();

        const contractFactory = await ethers.getContractFactory('ExerciseTwo', admin);
        const contract : Contract = <any> await contractFactory.deploy("TEST2", "4soft Training ERC20 Contract", 18, 0);
        await contract.deployed();

        return contract;
    },
    ExerciseThree: async() => {
        const [ admin ] = await ethers.getSigners();

        const contractFactory = await ethers.getContractFactory('ExerciseThree', admin);
        const contract : Contract = <any> await contractFactory.deploy("TEST3", "4soft Training ERC20 Contract", 18, 0);
        await contract.deployed();

        return contract;
    },
    ExerciseFour: async() => {
        const [ admin ] = await ethers.getSigners();

        const contractFactory = await ethers.getContractFactory('ExerciseFour', admin);
        const contract : Contract = <any> await contractFactory.deploy("TEST4", "4soft Training ERC20 Contract", 18, 0);
        await contract.deployed();

        return contract;
    },
    ExerciseFive: async() => {
        const [ admin ] = await ethers.getSigners();

        const contractFactory = await ethers.getContractFactory('ExerciseFive', admin);
        const contract : Contract = <any> await contractFactory.deploy("TEST5", "4soft Training ERC20 Contract", 18, 1000000);
        await contract.deployed();

        return contract;
    },

}