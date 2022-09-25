## `Outsourcing`






### `initialize(address rToken_)` (external)





### `requestsLength() → uint256` (public)





### `allRequests() → struct Outsourcing.Request[] requests_` (public)





### `_filter(enum Outsourcing.TaskState state_) → struct Outsourcing.Request[] requests_` (internal)





### `askedRequests() → struct Outsourcing.Request[] requests_` (public)





### `cancledRequests() → struct Outsourcing.Request[] requests_` (public)





### `acceptedRequests() → struct Outsourcing.Request[] requests_` (public)





### `rejectedRequests() → struct Outsourcing.Request[] requests_` (public)





### `ask(uint256 amount_)` (public)

User spends RepuERC20 for some request.



### `cancle(uint256 id_)` (public)

User cancles request.



### `accept(uint256 id_)` (public)

Accept the `id_` request.



### `reject(uint256 id_)` (public)

Reject the `id_` request.



### `withdraw(uint256 amount_)` (public)






### `AskRequest(address who, uint256 amount, uint256 tid)`





### `CancleRequest(address who, uint256 amount, uint256 tid)`





### `AcceptRequest(address who, uint256 amount, uint256 tid)`





### `RejectRequest(address who, uint256 amount, uint256 tid)`





