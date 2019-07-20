module.exports = {
    copyPackages: ['openzeppelin-eth'],
    compileCommand: '../node_modules/.bin/truffle compile',
    testCommand: '../node_modules/.bin/truffle test --network coverage',
};