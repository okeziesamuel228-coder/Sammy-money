# Sammy-money
A simple Clarity-based fungible token on the Stacks blockchain.

> Inspired by the [SIP-010 Fungible Token Standard](https://github.com/stacksgov/sips/blob/main/sips/sip-010/sip-010-ft-standard.md)

## 🪙 Token Overview

| Property     | Value                |
| ------------ | -------------------- |
| **Name**     | Sammy Money          |
| **Symbol**   | `SAMMY`              |
| **Decimals** | `6`                  |
| **Standard** | SIP-010 (Simplified) |

## 📦 Contract Features

### ✅ Read-Only Functions

* `get-name` → Returns token name.
* `get-symbol` → Returns token symbol.
* `get-decimals` → Returns number of decimals.
* `get-total-supply` → Returns the total supply of $SAMMY.
* `get-balance-of (principal)` → Returns the balance of a given user.

### 🔧 Public Functions

* `mint (amount, recipient)`

  > Mints new tokens to a specified recipient. Only callable by contract deployer.

* `burn (amount)`

  > Burns tokens from the caller’s balance.

* `transfer (amount, sender, recipient)`

  > Transfers tokens from sender to recipient. Only sender can initiate.



## ⚠️ Error Codes

| Code | Meaning              |
| ---- | -------------------- |
| 100  | Not authorized       |
| 101  | Insufficient balance |
| 104  | Zero-value transfer  |


## 🚀 Quick Example (Clarity REPL)

```clojure
;; Mint 1,000,000 SAMMY tokens (1.000000 SAMMY, since 6 decimals)
(mint u1000000 'SP123...')

;; Check balance
(get-balance-of 'SP123...')

;; Transfer tokens
(transfer u500000 'SP123...' 'SP456...')

;; Burn some tokens
(burn u100000)
```

## 🔐 Authorization Model

* Only the **contract deployer** can call `mint`.
* `transfer` requires the `sender` to match `tx-sender`.

## 📄 License

MIT License — use freely, modify, build on it.


## 🤝 Contributing

Pull requests welcome! Let’s make Sammy Money smarter together.
