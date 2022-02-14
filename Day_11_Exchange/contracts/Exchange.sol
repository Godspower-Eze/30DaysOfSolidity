// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./IERC20.sol";

contract Exchange {

    modifier onlyApproved
    (
        address token1,
        address token2,
        address ownerOfToken1,
        address ownerOfToken2,
        uint amountOfToken1,
        uint amountOfToken2
    )
    {
        require
        (
            IBasicERC20Token(token1).allowance(ownerOfToken1, address(this)) >= amountOfToken1,
            "This contract is not approved to spend this amount from token 1"
        );
        require
        (
            IBasicERC20Token(token2).allowance(ownerOfToken2, address(this)) >= amountOfToken2,
            "This contract is not approved to spend this amount from token 2"
        );
        _;
    }

    function _safeTransferFrom
    (
        address tokenAddress,
        address sender,
        address recipient,
        uint amount
    ) private {
        bool sent = IBasicERC20Token(tokenAddress).transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }

    function swap
    (
        address token1,
        address token2,
        address ownerOfToken1,
        address ownerOfToken2,
        uint amountOfToken1,
        uint amountOfToken2
    )
    external
    onlyApproved
    (
        token1,
        token2,
        ownerOfToken1,
        ownerOfToken2,
        amountOfToken1,
        amountOfToken2
    )
    {
        _safeTransferFrom(token1, ownerOfToken1, ownerOfToken2, amountOfToken1);
        _safeTransferFrom(token2, ownerOfToken2, ownerOfToken1, amountOfToken2);
    }
}