// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LoginDApp {
    struct User {
        bytes32 username;
        bytes32 passwordHash;
    }

    mapping(address => User) private users;
    mapping(address => bool) public registered;

    event Registered(address userAddress, bytes32 username);
    event LoginAttempt(address userAddress, bool success);

    // Register function that stores hashed password
    function register(string memory username, string memory password) public {
        require(!registered[msg.sender], "Already registered.");
        bytes32 usernameHash = keccak256(abi.encodePacked(username));
        bytes32 passwordHash = keccak256(abi.encodePacked(password));
        
        users[msg.sender] = User(usernameHash, passwordHash);
        registered[msg.sender] = true;

        emit Registered(msg.sender, usernameHash);
    }

    // Login function that validates username and password hash
    function login(string memory username, string memory password) public view returns (bool) {
    require(registered[msg.sender], "Not registered.");

    bytes32 usernameHash = keccak256(abi.encodePacked(username));
    bytes32 passwordHash = keccak256(abi.encodePacked(password));

    User memory user = users[msg.sender];
    return (user.username == usernameHash && user.passwordHash == passwordHash);
}
}
