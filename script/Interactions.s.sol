// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.18;

import {Script,console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "../test/mocks/VRFCoordinatorV2Mock.sol";
import {LinkToken} from "../test/mocks/LinkToken.sol";

contract CreateSubscription is Script {

    function createSubscriptionUsingConfig() public returns (uint64){
        HelperConfig helperConfig = new HelperConfig();
        (,,address vrfCoordinatorV2,,,,) = helperConfig.activeNetworkConfig();
        return createSubscription(vrfCoordinator);
    }

    function createSubscription(address vrfCoordinator) public returns(uint64){
        console.log("Creating subscription on ChainId: ",block.chainid);

        vm.startBroadcast();
        uint64 subscriptionId = VRFCoordinatorV2Mock(vrfCoordinatorV2).createSubscription();
        vm.stopBroadcast();
        console.log("Your subscription Id ",subscriptionId);
        console.log("Please update subscription id in HelperConfig.s.sol");
        return subscriptionId;
    }

    function run() external returns (uint64){
        return createSubscriptionUsingConfig();
    }
}

contract FundSubscription is Script{
    uint96 public constant FUND_AMOUNT = 3 ether;

    function fundSubscriptionUsingConfig() public{
        HelperConfig helperConfig = new HelperConfig();
        (,,address vrfCoordinatorV2,,uint64 subscriptionId,,address link) = helperConfig.activeNetworkConfig();
    }

    function fundSubscriptionUsingConfig() public{
            HelperConfig helperConfig = new HelperConfig();
            (,,address vrfCoordinatorV2,,uint64 subscriptionId,,address link) = helperConfig.activeNetworkConfig();
            fundSubscription(vrfCoordinatorV2,subscriptionId,link);
    }

    function fundSubscription(address vrfCoordinator,uint64 subId,address link) public{
        console.log("Funding subscription :",subscriptionId);
        console.log("Using vrfCoordinator :",vrfCoordinatorV2);
        console.log("On chainId: ",block.chainid);

        if(block.chainid == 31337){
            vm.startBroadcast();
            VRFCoordinatorV2Mock(vrfCoordinatorV2).fundSubscription(subscriptionId,FUND_AMOUNT);
            vm.stopBroadcast();
        }
        else{
            vm.startBroadcast();
            LinkToken(link).transferAndCall(vrfCoordinatorV2,FUND_Amount,abi.encode(subscriptionId));
            vm.stopBroadcast();
        }
    }

    function run() external{
        fundSubscriptionUsingConfig();
    }
}