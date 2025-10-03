# My Learning Progress Token (MLPT)

> ⚠️ **WIP - Development in Progress**
>
> This project is currently under development. Testing, security audits, and mainnet deployment are pending.
>
> 📝 **Note:** This README was generated with assistance from Claude AI. The smart contract code was written by the project author.

## 📋 Overview

My Learning Progress Token (MLPT) is an educational ERC20 token implementation built with Foundry. Each address can mint exactly 10 tokens once as a learning milestone tracker.

**Token Details:**
- Name: My Learning Progress Token
- Symbol: MLPT
- Decimals: 18
- Initial Supply: 0 (mint-based)
- Mint Amount: 10 tokens per address (one-time only)

## 🚧 Project Status

- [x] Basic ERC20 implementation
- [x] Deploy script created
- [x] Local testing on Anvil
- [ ] Unit tests (in progress)
- [ ] Integration tests
- [ ] Security audit
- [ ] Testnet deployment
- [ ] Mainnet deployment

## 🛠️ Built With

- [Foundry](https://book.getfoundry.sh/) - Ethereum development toolkit
- Solidity ^0.8.30

## 🚀 Quick Start

### Prerequisites

```shell
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Installation

```shell
# Clone the repository
git clone <repo-url>
cd <repo-name>

# Install dependencies
forge install
```

### Build

```shell
forge build
```

### Test

```shell
# Run tests (coming soon)
forge test
```

### Local Deployment

1. Start local Anvil node:
```shell
anvil
```

2. Deploy to local network:
```shell
forge script script/MyFirstERC20Token.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

### Interact with Contract

```shell
# Check token name
cast call <CONTRACT_ADDRESS> "name()(string)" --rpc-url http://127.0.0.1:8545

# Check balance
cast call <CONTRACT_ADDRESS> "balanceOf(address)(uint256)" <ADDRESS> --rpc-url http://127.0.0.1:8545

# Mint tokens (one-time per address)
cast send <CONTRACT_ADDRESS> "mint()" --private-key <PRIVATE_KEY> --rpc-url http://127.0.0.1:8545

# Transfer tokens
cast send <CONTRACT_ADDRESS> "transfer(address,uint256)" <TO_ADDRESS> <AMOUNT> --private-key <PRIVATE_KEY> --rpc-url http://127.0.0.1:8545
```

## 📝 Contract Features

- **mint()**: Mint 10 tokens (one-time per address)
- **transfer()**: Transfer tokens to another address
- **approve()**: Approve spender allowance
- **transferFrom()**: Transfer tokens on behalf of owner
- **balanceOf()**: Check token balance
- **allowance()**: Check approved allowance

## ⚠️ Security Notes

- Private keys should NEVER be committed to the repository
- Use `.env` file for sensitive data (already in `.gitignore`)
- The private key shown in examples is Anvil's default test key (safe for local use only)
- Contract has NOT been audited - use at your own risk

## 📚 Learn More

- [Foundry Book](https://book.getfoundry.sh/)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [ERC20 Standard](https://eips.ethereum.org/EIPS/eip-20)

## 📄 License

MIT
