// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IOutsourcing {
    /// @notice Possible states that a task may be in
    enum TaskState {
        Asked,
        Cancled,
        Accepted,
        Rejected
    }

    struct Request {
        TaskState state;
        uint256 amount;
        address who;
        // uint96 extra;
    }

    function askedRequests() external view returns (Request[] memory requests_);
    function cancledRequests() external view returns (Request[] memory requests_);
    function acceptedRequests() external view returns (Request[] memory requests_);
    function rejectedRequests() external view returns (Request[] memory requests_);

    function ask(uint256 amount_) external;
    function cancle(uint256 id_) external;
    function accept(uint256 id_) external;
    function reject(uint256 id_) external;
    function withdraw(uint256 amount_) external;

    function initialize(address rToken_) external;
}
