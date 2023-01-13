// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IWhitelist {
    function whitelisted(address member) external view returns(bool);
}
