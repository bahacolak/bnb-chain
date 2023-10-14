const SafeSmartContract = artifacts.require("SafeSmartContract");

module.exports = function(deployer) {
  deployer.deploy(SafeSmartContract);
};
