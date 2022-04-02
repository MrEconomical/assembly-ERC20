(async () => {

const { ethers } = require("hardhat")
const contracts = {
    "TestStandard": [],
    "BaseERC20": [],
    "TestERC20": []
}

for (const contract in contracts) {
    const Contract = await ethers.getContractFactory(contract)
    const deploy = await Contract.deploy(...contracts[contract])
    console.log(contract + ":", deploy.deployTransaction.gasLimit.toString())
}

})()