// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./interfaces/IOutsourcing.sol";

import "./Outsourcing.sol";

interface IRepuFactory {
    function getRToken(address from) external view returns (address rToken);
}

contract OutsourcingFactory is Ownable {
    event OutsourcingCreate(
        address indexed from,
        address indexed rToken,
        address outsourcing,
        uint256 id
    );

    mapping(address => address) public getOutsourcing;
    address[] public allOutsourcings;

    IRepuFactory public repuFactory;

    constructor(address repuFactory_) {
        repuFactory = IRepuFactory(repuFactory_);
    }

    function allOutsourcingsLength() public view returns (uint256) {
        return allOutsourcings.length;
    }

    function createOursourcing() public returns (address outsourcing) {
        address rToken = repuFactory.getRToken(msg.sender);
        require(rToken != address(0), "OutsourcingFactory: RTOKEN_NOT_EXISTS");
        require(
            getOutsourcing[msg.sender] == address(0),
            "OutsourcingFactory: OUTSOURCING_EXISTS"
        );

        bytes memory bytecode = type(Outsourcing).creationCode;
        bytecode = abi.encodePacked(bytecode);
        bytes32 salt = keccak256(abi.encodePacked(rToken));
        assembly {
            outsourcing := create2(
                0,
                add(bytecode, 0x20),
                mload(bytecode),
                salt
            )
        }

        IOutsourcing(outsourcing).initialize(rToken);

        getOutsourcing[msg.sender] = outsourcing;
        allOutsourcings.push(outsourcing);

        emit OutsourcingCreate(
            msg.sender,
            rToken,
            outsourcing,
            allOutsourcings.length
        );
    }
}
