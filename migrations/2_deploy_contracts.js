var Ena = artifacts.require("./EnaCoin/Enadrop.sol");

module.exports = function(deployer) {
  deployer.deploy(Ena);
};