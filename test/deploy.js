(async () => {

const { ethers } = require("hardhat")
const contracts = {
    "TestERC20": [],
    "BaseERC20": [],
    "contracts/ERC20.sol:ERC20": ["Token", "TOKEN"]
}

for (const contract in contracts) {
    const Contract = await ethers.getContractFactory(contract)
    const deploy = await Contract.deploy(...contracts[contract])
    console.log(contract + ":", deploy.deployTransaction.gasLimit.toString())
}

})()