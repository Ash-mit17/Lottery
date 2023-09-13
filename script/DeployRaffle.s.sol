// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {CreateSubscription} from "./Interactions.s.sol";

contract DeployRaffle is Script {
    function run() external returns (Raffle,HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        (
            uint64 subscriptionId,
            bytes32 gasLane,
            uint256 automationUpdateInterval,
            uint256 raffleEntranceFee,
            uint32 callbackGasLimit,
            address vrfCoordinatorV2,
            address Link
        ) = helperConfig.activeNetworkConfig();
    
    if(subscriptionId == 0){
        //we are going to create one sId
        CreateSubscription createSubscription = new CreateSubscription();
        subscriptionId = createSubscription.createSubscription(vrfCoordinator);
    }

    vm.startBroadcast();
    Raffle raffle = new Raffle(
        subscriptionId,
        gasLane,
        automationUpdateInterval,
        raffleEntranceFee,
        callbackGasLimit,
        vrfCoordinatorV2,
        link
    );
    vm.stopBroadcast();

    return (raffle,helperConfig);
    }
}