// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IOutsourcingFactory {
    function getOutsourcing(address from) external view returns (address outsourcing);
    function allOutsourcings(uint256 id) external view returns (address outsourcing);
    function allOutsourcingsLength() external view returns (uint256);

    function createOursourcing() external returns (address outsourcing);

    function repuFactory() external returns (address);
}
