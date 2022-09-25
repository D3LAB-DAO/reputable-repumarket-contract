// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Outsourcing is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    event AskRequest(address indexed who, uint256 amount, uint256 indexed tid);
    event CancleRequest(
        address indexed who,
        uint256 amount,
        uint256 indexed tid
    );
    event AcceptRequest(
        address indexed who,
        uint256 amount,
        uint256 indexed tid
    );
    event RejectRequest(
        address indexed who,
        uint256 amount,
        uint256 indexed tid
    );

    IERC20 public rToken;

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

    Request[] public requests;

    address public factory;

    //==================== Initialization ====================//

    constructor() {
        factory = msg.sender;
    }

    // called once by the factory at time of deployment
    function initialize(address rToken_) external {
        require(msg.sender == factory, "Outsourcing::initialize: FORBIDDEN"); // sufficient check
        rToken = IERC20(rToken_);
    }

    //==================== View ====================//

    function requestsLength() public view returns (uint256) {
        return requests.length;
    }

    function allRequests() public view returns (Request[] memory requests_) {
        return requests;
    }

    function _filter(TaskState state_)
        internal
        view
        returns (Request[] memory requests_)
    {
        uint256 len;
        for (uint256 i = 0; i < requests.length; i++) {
            if (requests[i].state == state_) {
                unchecked {
                    len += 1;
                }
            }
        }
        requests_ = new Request[](len);
        uint256 j;
        for (uint256 i = 0; i < requests.length; i++) {
            if (requests[i].state == state_) {
                requests_[j++] = requests[i];
            }
        }
    }

    function askedRequests() public view returns (Request[] memory requests_) {
        return _filter(TaskState.Asked); // ask
    }

    function cancledRequests()
        public
        view
        returns (Request[] memory requests_)
    {
        return _filter(TaskState.Cancled); // cancle
    }

    function acceptedRequests()
        public
        view
        returns (Request[] memory requests_)
    {
        return _filter(TaskState.Accepted); // accept
    }

    function rejectedRequests()
        public
        view
        returns (Request[] memory requests_)
    {
        return _filter(TaskState.Rejected); // reject
    }

    //==================== Methods ====================//

    /**
     * @notice User spends RepuERC20 for some request.
     */
    function ask(uint256 amount_) public {
        address msgSender = _msgSender();

        requests.push(
            Request({
                amount: amount_,
                who: msgSender,
                state: TaskState.Asked // ask
            })
        );

        rToken.transferFrom(msgSender, address(this), amount_);
        emit AskRequest(msgSender, amount_, requests.length);
    }

    /**
     * @notice User cancles request.
     */
    function cancle(uint256 id_) public nonReentrant {
        address msgSender = _msgSender();
        require(
            msgSender == owner() || msgSender == requests[id_].who,
            "Outsourcing::cancle: must be called from owner of task giver"
        );

        require(
            requests[id_].state == TaskState.Asked,
            "Outsourcing::cancle: state of task must be Asked"
        );
        requests[id_].state = TaskState.Cancled; // cancle
        address who_ = requests[id_].who;
        uint256 amount_ = requests[id_].amount;

        rToken.transfer(who_, amount_);
        emit CancleRequest(msgSender, amount_, id_);
    }

    /**
     * @notice Accept the `id_` request.
     */
    function accept(uint256 id_) public onlyOwner nonReentrant {
        address msgSender = _msgSender(); // owner

        require(
            requests[id_].state == TaskState.Asked,
            "Outsourcing::cancle: state of task must be Asked"
        );
        requests[id_].state = TaskState.Accepted; // accept
        uint256 amount_ = requests[id_].amount;

        rToken.transfer(msgSender, amount_);
        emit AcceptRequest(msgSender, amount_, id_);
    }

    /**
     * @notice Reject the `id_` request.
     */
    function reject(uint256 id_) public onlyOwner nonReentrant {
        address msgSender = _msgSender(); // owner

        require(
            requests[id_].state == TaskState.Asked,
            "Outsourcing::cancle: state of task must be Asked"
        );
        requests[id_].state = TaskState.Rejected; // reject
        address who_ = requests[id_].who;
        uint256 amount_ = requests[id_].amount;

        rToken.transfer(who_, amount_);
        emit RejectRequest(msgSender, amount_, id_);
    }

    //==================== Owner ====================//

    function withdraw(uint256 amount_) public onlyOwner {
        rToken.transfer(_msgSender(), amount_);
    }
}
