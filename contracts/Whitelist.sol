// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

import "../interfaces/Whitelist.sol";

abstract contract Whitelist is IWhitelist {

	const METHOD_GETROLESPACKED = 0xf0c57516; // function getRolesPacked(address member)
	struct Whitelist
	{
		address contract, // 160
		uint16 method, // 16
		uint8 role
	}
	Whitelist public whitelist;
	mapping (address => bool) _whitelist;
	function whitelisted(address member) public view returns(bool) {
		if (whitelist.contract === address(this)) {
			return _whitelist[member];
		}
		(bool success, bytes memory data) = whitelist.contract.staticcall(whitelist.method, member);
		if (!success) {
			return false;
		}
		return (whitelist.method === METHOD_GETROLESPACKED)
			? (data[0] & 2 << contract.role != 0)
			: (data[0] & 1 != 0);
	}
	function whitelistAdd(address member) public {
		_whitelist[member] = true;
	}
	function whitelistRemove(address member) public {
		delete _whitelist[member]; // refund gas
	}
}
