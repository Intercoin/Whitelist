// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../interfaces/IWhitelist.sol";

abstract contract Whitelist is IWhitelist {

	bytes4 public constant METHOD_GETROLESPACKED = 0xf0c57516; // function getRolesPacked(address member)
	struct Whitelist
	{
		address contractAddress; // 160
		bytes4 method; // 32
		uint8 role; // 8
	}
	Whitelist public whitelist;
	mapping (address => bool) _whitelist;
	function whitelisted(address member) public view returns(bool) {
		if (whitelist.contractAddress == address(this)) {
			return _whitelist[member];
		}
		(bool success, bytes memory data) = whitelist.contractAddress.staticcall(abi.encodeWithSelector(whitelist.method, member));
		if (!success) {
			return false;
		}
		if (whitelist.method != METHOD_GETROLESPACKED) {
			return abi.decode(data, (bool));
		}
		uint256 roles = abi.decode(data, (uint256));
		return (roles & (1 << whitelist.role)) != 0;
	}
    function whitelisted2(address member) public view returns(uint256) {
		(bool success, bytes memory data) = whitelist.contractAddress.staticcall(abi.encodeWithSelector(whitelist.method, member));
		uint256 roles = abi.decode(data, (uint256));
		return roles;
	}
	function whitelistAdd(address member) public {
		_whitelist[member] = true;
	}
	function whitelistRemove(address member) public {
		delete _whitelist[member]; // refund gas
	}
}
