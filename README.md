# Foundry FundMe Smart CXontract
My First smart contract project that allow users donate to the  contract securely :)

![Build Status](https://img.shields.io/github/actions/workflow/status/user/repo/ci.yml)
![License](https://img.shields.io/github/license/user/repo)

## Features
- 🔥 It allow users fund the contract
- 🛍️ It allows only the owner withdraw the funds
- 🔥 100% test
- 📱 Gas well Optimised
- 🔗 Deployed to Sepolia Testnet

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/Teejay012/foundry-fundme.git
   cd foundry-fundme

2. Install dependencies:
   ```sh
   npm install

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.



## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
