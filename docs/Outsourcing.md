## `Outsourcing`






### `constructor(address rToken_)` (public)





### `requestsLength() → uint256` (public)





### `allRequests() → struct Outsourcing.Request[] requests` (public)





### `_filter(uint8 state_) → struct Outsourcing.Request[] requests` (internal)





### `askedRequests() → struct Outsourcing.Request[] requests` (public)





### `cancledRequests() → struct Outsourcing.Request[] requests` (public)





### `acceptedRequests() → struct Outsourcing.Request[] requests` (public)





### `rejectedRequests() → struct Outsourcing.Request[] requests` (public)





### `ask(uint256 amount_)` (public)

User spends RepuERC20 for some request.



### `cancle(uint256 id_)` (public)

User cancles request.



### `accept(uint256 id_)` (public)

Accept the `id_` request.



### `reject(uint256 id_)` (public)

Reject the `id_` request.



### `withdraw(uint256 amount_)` (public)






### `AskRequest(address who, uint256 amount, uint256 id)`





### `CancleRequest(address who, uint256 amount, uint256 id)`





### `AcceptRequest(address who, uint256 amount, uint256 id)`





### `RejectRequest(address who, uint256 amount, uint256 id)`





