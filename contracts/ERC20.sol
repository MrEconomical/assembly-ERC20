// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;

/*
 * Extended ERC20 implementation with optional functions and mint function
 * This implementation is inheritable and usable with other Solidity contracts
 */

contract ERC20 {

    /*
     * Storage layout:
     * 0x1000: total supply
     * 0x1001...: token balances [address + 0x1001]
     * [keccak256(owner + spender)]: token approvals
     */
    
    string private _name;
    string private _symbol;

    constructor(string memory tokenName, string memory tokenSymbol) {
        _name = tokenName;
        _symbol = tokenSymbol;
    }

    /*
     * ------------------
     * METADATA FUNCTIONS
     * ------------------
     */
    
    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint256) {
        return 18;
    }

    /*
     * --------------
     * VIEW FUNCTIONS
     * --------------
     */
    
    function totalSupply() public view virtual returns (uint256 tokenTotalSupply) {
        assembly {
            tokenTotalSupply := sload(0x1000) // load total supply storage slot
        }
    }

    function balanceOf(address account) public view virtual returns (uint256 tokenBalance) {
        assembly {
            tokenBalance := sload(add(account, 0x1001)) // load storage slot at [account + 0x1001]
        }
    }

    function allowance(address owner, address spender) public view virtual returns (uint256 approved) {
        assembly {
            mstore(0, owner)
            mstore(0x20, spender)
            approved := sload(keccak256(0, 0x40)) // load storage slot at hash of owner and spender
        }
    }

    /*
     * ----------------
     * PUBLIC FUNCTIONS
     * ----------------
     */
    
    function transfer(address to, uint256 amount) public virtual returns (bool success) {
        assembly {
            let bal := sload(add(caller(), 0x1001)) // load balance of sender
            if eq(lt(bal, amount), 1) { revert(0, 0) } // check sender has enough tokens
            sstore(add(caller(), 0x1001), sub(bal, amount)) // subtract amount from sender balance
            sstore(add(to, 0x1001), add(sload(add(to, 0x1001)), amount)) // add amount to recipient balance

            mstore(0, amount) // store non-indexed approval event parameter
            log3(
                0, 0x20, // non-indexed parameter memory slot
                0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef, // transfer event signature
                caller(), to // indexed event parameters
            )

            success := true // return true
        }
    }

    function approve(address spender, uint256 amount) public virtual returns (bool success) {
        assembly {
            mstore(0, caller())
            mstore(0x20, spender)
            sstore(keccak256(0, 0x40), amount) // write amount at storage slot of approval

            mstore(0, amount) // store non-indexed approval event parameter
            log3(
                0, 0x20, // non-indexed parameter memory slot
                0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925, // approval event signature
                caller(), spender // indexed event parameters
            )

            success := true // return true
        }
    }

    function transferFrom(address from, address to, uint256 amount) public virtual returns (bool success) {
        assembly {
            mstore(0, from)
            mstore(0x20, to)
            let approval := keccak256(0, 0x40) // get storage slot of approval
            let approved := sload(approval) // load approved amount

            if eq(lt(approved, amount), 1) { revert(0, 0) } // check spender has enough allowance
            sstore(approval, sub(approved, amount)) // subtract spent from approval
            sstore(add(from, 0x1001), sub(sload(add(from, 0x1001)), amount)) // subtract amount from sender balance
            sstore(add(to, 0x1001), add(sload(add(to, 0x1001)), amount)) // add amount to recipient balance

            mstore(0, amount) // store non-indexed approval event parameter
            log3(
                0, 0x20, // non-indexed parameter memory slot
                0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef, // transfer event signature
                from, to // indexed event parameters
            )

            success := true // return true
        }
    }

}