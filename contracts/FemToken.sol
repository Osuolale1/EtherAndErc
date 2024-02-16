// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FemToken is IERC20 {
    using SafeERC20 for IERC20;

    address public etherWallet;
    address public tokenWallet;
    IERC20 public token;

    mapping(address => uint256) public balances;

    event Deposit(address indexed user, uint256 amount, string asset);
    event Withdrawal(address indexed user, uint256 amount, string asset);

    constructor(address _etherWallet, address _tokenWallet, address _tokenAddress) {
        etherWallet = _etherWallet;
        tokenWallet = _tokenWallet;
        token = IERC20(_tokenAddress);
    }

    function depositEther() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value, "ETH");
    }

    function depositToken(uint256 amount) external {
        require(amount > 0, "Deposit amount must be greater than 0");
        token.safeTransferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
        emit Deposit(msg.sender, amount, "ERC20");
    }

    function withdraw(uint256 amount, string memory asset) external {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        if (keccak256(abi.encodePacked(asset)) == keccak256(abi.encodePacked("ETH"))) {
            require(payable(msg.sender).send(amount), "Failed to send Ether");
        } else if (keccak256(abi.encodePacked(asset)) == keccak256(abi.encodePacked("ERC20"))) {
            token.safeTransfer(msg.sender, amount);
        } else {
            revert("Invalid asset type");
        }

        balances[msg.sender] -= amount;
        emit Withdrawal(msg.sender, amount, asset);
    }
}
