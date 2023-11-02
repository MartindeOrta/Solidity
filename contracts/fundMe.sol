//SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe{
    address public owner;
    constructor() public {
        owner = msg.sender;
    }
    using SafeMathChainlink for uint256;
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    function fund() public payable{
        uint256 minimumUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value)>= minimumUSD,"You need to spend more eth!");
        
        // solamente que se puedan hacer transacciones mayores a 50 dolares
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        
    }
    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version(); 
    }

    function getPrice() public view returns(uint256){//toma el precio del eth en usdt de de 1 
          AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
           (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return uint256(answer *10000000000);
    }

    function getConversionRate(uint ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }


    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);
        for(uint256 funderIndex; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder]=0;
        }
        funders = new address[](0);
    }

//50.424307010000000000
}