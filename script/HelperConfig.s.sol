// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { MockV3Aggregator } from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 constant public INITIAL_PRICE = 2000e8;

    struct NetworkConfig{
        address priceFeed;
    }

    constructor(){
        if(block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthPriceFeed();
        }else if(block.chainid == 1) {
            activeNetworkConfig = getMainnetEthPriceFeed();
        } else {
            activeNetworkConfig = getAnviilEthPriceFeed();
        }
    }

    function getSepoliaEthPriceFeed() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        
        return sepoliaConfig;
    }

    function getMainnetEthPriceFeed() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        
        return mainnetConfig;
    }

    function getAnviilEthPriceFeed() public returns (NetworkConfig memory) {

        if(activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockV8AggregatorPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig(address(mockV8AggregatorPriceFeed));
        return anvilConfig;
    } 
}