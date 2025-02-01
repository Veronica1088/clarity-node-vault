;; Node Rewards Contract

(define-constant reward-cycle u144) ;; ~1 day in blocks
(define-constant base-reward u1000)

(define-public (distribute-rewards (node principal))
  (let (
    (node-data (unwrap! (contract-call? .node-vault get-node-info node) (err u1)))
    (uptime (get uptime node-data))
  )
    (ok (calculate-reward uptime))
  )
)

(define-private (calculate-reward (uptime uint))
  (* base-reward (/ uptime reward-cycle))
)
