module.exports = {
    solidity: {
        compilers: [{
            version: "0.8.13",
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 10000000
                }
            }
        }]
    }
}