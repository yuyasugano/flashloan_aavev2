// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import { FlashLoanReceiverBase } from "./aave2/FlashLoanReceiverBase.sol";
import { ILendingPool } from "./aave2/interfaces/ILendingPool.sol";
import { ILendingPoolAddressesProvider } from "./aave2/interfaces/ILendingPoolAddressesProvider.sol";
import { IERC20 } from "./aave2/utils/IERC20.sol";
import "./Ownable.sol";

contract Flashloan is FlashLoanReceiverBase, Ownable {

    constructor(address _addressProvider) FlashLoanReceiverBase(_addressProvider) public {}

    /**
        This function is called after your contract has received the flash loaned amount
     */
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    )
        external
        override
        returns (bool)
    {
        //
        // This contract now has the funds requested.
        // Your logic goes here.
        //
        
        // At the end of your logic above, this contract owes
        // the flashloaned amounts + premiums.
        // Therefore ensure your contract has enough to repay
        // these amounts.
        
        // Approve the LendingPool contract allowance to *pull* the owed amount
        for (uint i = 0; i < assets.length; i++) {
            uint amountOwing = amounts[i].add(premiums[i]);
            IERC20(assets[i]).approve(address(LENDING_POOL), amountOwing);
        }

        return true;
    }
}
