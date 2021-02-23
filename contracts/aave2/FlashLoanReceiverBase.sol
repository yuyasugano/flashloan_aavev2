// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.12;

import { SafeMath } from './math/SafeMath.sol';
import { IERC20 } from './utils/IERC20.sol';
import { SafeERC20 } from './utils/SafeERC20.sol';
import { IFlashLoanReceiver } from './IFlashLoanReceiver.sol';
import { ILendingPoolAddressesProvider } from './interfaces/ILendingPoolAddressesProvider.sol';
import { ILendingPool } from './interfaces/ILendingPool.sol';

abstract contract FlashLoanReceiverBase is IFlashLoanReceiver {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    ILendingPoolAddressesProvider public immutable override ADDRESSES_PROVIDER;
    ILendingPool public immutable override LENDING_POOL;

    constructor(address provider) public {
        ADDRESSES_PROVIDER = ILendingPoolAddressesProvider(provider);
        LENDING_POOL = ILendingPool(ILendingPoolAddressesProvider(provider).getLendingPool());
    }
}
