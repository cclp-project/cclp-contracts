module.exports = {
    copyPackages: ['@openzeppelin/upgrades','@openzeppelin/contracts-ethereum-package'],
    compileCommand: '../node_modules/.bin/truffle compile',
    testCommand: '../node_modules/.bin/truffle test --network coverage',
};