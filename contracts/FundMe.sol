// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; //Interface from chainlink to use a price feed API

contract FundMe {
    mapping(address => uint256) public addressToAmmountFunded;

    address[] public funders; //Redundante but... now is usefull;

    address public owner;

    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) {
        priceFeed = AggregatorV3Interface(_priceFeed);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _; //Todo lo demás que se ejecute, hazlo aquí, después de la sentencia de arriba.
    }

    function fund() public payable {
        //uint256 minimunUSD = 50 * 10 **18;
        //require (getConversionRate(msg.value)>=minimunUSD, "You need to spend more ETH"); //Instead using IF, "require" is more likely.
        addressToAmmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData(); //Tuples with several data, if we only need 1 info, can let "," instead give they a real variable.
        return uint256(answer);
    }

    function getEntranceFee() public view returns (uint256) {
        //minium USD
        uint256 minimunUSD = 100 * 10 ** 18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10 ** 18;
        return ((minimunUSD * precision) / price) + 1;
    }

    //50 USD = 20545860000000000 Wei = 0,02054586 ETH
    function getConversionRate(
        uint256 _ethAmmount
    ) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 _ethAmmountInUSD = (ethPrice * _ethAmmount) /
            1000000000000000000;
        return _ethAmmountInUSD;
    }

    function withdraw() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance); //0.8.0 breaking changes | msg.sender.transfer(x) Not works like it did.
        for (uint256 i; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}
