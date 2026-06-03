// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimeLockVault {

    struct Deposit {
        uint256 amount;
        uint256 unlockTime;
    }

    mapping(address => Deposit) public deposits;

    event Deposited(
        address indexed user,
        uint256 amount,
        uint256 unlockTime
    );

    event Withdrawn(
        address indexed user,
        uint256 amount
    );

    function deposit(
        uint256 lockSeconds
    )
        external
        payable
    {
        require(
            msg.value > 0,
            "Deposit required"
        );

        deposits[msg.sender] = Deposit(
            msg.value,
            block.timestamp + lockSeconds
        );

        emit Deposited(
            msg.sender,
            msg.value,
            block.timestamp + lockSeconds
        );
    }

    function withdraw()
        external
    {
        Deposit memory d =
            deposits[msg.sender];

        require(
            d.amount > 0,
            "No funds"
        );

        require(
            block.timestamp >=
            d.unlockTime,
            "Still locked"
        );

        deposits[msg.sender] =
            Deposit(0,0);

        payable(
            msg.sender
        ).transfer(
            d.amount
        );

        emit Withdrawn(
            msg.sender,
            d.amount
        );
    }

    function getVault()
        external
        view
        returns(
            uint256,
            uint256
        )
    {
        Deposit memory d =
            deposits[msg.sender];

        return (
            d.amount,
            d.unlockTime
        );
    }
}
