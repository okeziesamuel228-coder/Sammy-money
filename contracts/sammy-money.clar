;; Sammy Money fungible token (simple SIP-010-like implementation)

(define-constant TOKEN-NAME "Sammy Money")
(define-constant TOKEN-SYMBOL "SAMMY")
(define-constant TOKEN-DECIMALS u6)

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-INSUFFICIENT-BALANCE u101)
(define-constant ERR-ZERO-TRANSFER u104)

(define-data-var total-supply uint u0)
(define-map balances { owner: principal } { balance: uint })

;; Read-only helpers
(define-read-only (get-name) (ok TOKEN-NAME))
(define-read-only (get-symbol) (ok TOKEN-SYMBOL))
(define-read-only (get-decimals) (ok TOKEN-DECIMALS))
(define-read-only (get-total-supply) (ok (var-get total-supply)))
(define-read-only (get-balance-of (who principal))
  (ok (default-to u0 (get balance (map-get? balances { owner: who })))))

;; Mint new tokens to a recipient (only contract owner)
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (> amount u0) (err ERR-ZERO-TRANSFER))
    (let ((current (default-to u0 (get balance (map-get? balances { owner: recipient }))))
          (new-supply (+ (var-get total-supply) amount)))
      (map-set balances { owner: recipient } { balance: (+ current amount) })
      (var-set total-supply new-supply)
      (ok true))))

;; Burn caller's tokens
(define-public (burn (amount uint))
  (begin
    (asserts! (> amount u0) (err ERR-ZERO-TRANSFER))
    (let ((bal (default-to u0 (get balance (map-get? balances { owner: tx-sender })))) )
      (asserts! (>= bal amount) (err ERR-INSUFFICIENT-BALANCE))
      (map-set balances { owner: tx-sender } { balance: (- bal amount) })
      (var-set total-supply (- (var-get total-supply) amount))
      (ok true))))

;; Transfer tokens from sender to recipient; sender must authorize by being tx-sender
(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (> amount u0) (err ERR-ZERO-TRANSFER))
    (asserts! (is-eq tx-sender sender) (err ERR-NOT-AUTHORIZED))
    (let ((from-bal (default-to u0 (get balance (map-get? balances { owner: sender }))))
          (to-bal   (default-to u0 (get balance (map-get? balances { owner: recipient })))) )
      (asserts! (>= from-bal amount) (err ERR-INSUFFICIENT-BALANCE))
      (map-set balances { owner: sender } { balance: (- from-bal amount) })
      (map-set balances { owner: recipient } { balance: (+ to-bal amount) })
      (ok true))))
