// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./interfaces/IWhitelist.sol";

abstract contract Whitelist is IWhitelist {

	bytes4 public constant METHOD_HASROLE = 0x95a8c58d; // function hasRole(address member, uint8 role)
	struct WhitelistStruct
	{
		address contractAddress; // 160
		bytes4 method; // 32
		uint8 role; // 8
	}
	WhitelistStruct public whitelist;
	mapping (address => bool) _whitelist;
	function whitelisted(address member) public view returns(bool) {
		if (whitelist.contractAddress == address(0)) {
			return true;
		}
		bool success;
		bytes memory data;
		if (whitelist.role == 0) {
			(success, data) = whitelist.contractAddress.staticcall(abi.encodeWithSelector(whitelist.method, member));
		} else {
			(success, data) = whitelist.contractAddress.staticcall(abi.encodeWithSelector(METHOD_HASROLE, member, whitelist.role));
		}
		if (!success) {
			return false;
		}
		return abi.decode(data, (bool));
	}
}
