// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

interface ISafeHook {
    function whitelisted(address member) public view returns(bool);
}
