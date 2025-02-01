;; NodeVault Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant min-stake u100000)
(define-constant err-owner-only (err u100))
(define-constant err-insufficient-stake (err u101))
(define-constant err-node-exists (err u102))
(define-constant err-node-not-found (err u103))

;; Data structures
(define-map nodes
  { node-address: principal }
  {
    stake: uint,
    uptime: uint,
    status: (string-ascii 20),
    last-heartbeat: uint,
    rewards: uint
  }
)

;; Node registration
(define-public (register-node (stake uint))
  (let ((node-data {
    stake: stake,
    uptime: u0,
    status: "active",
    last-heartbeat: block-height,
    rewards: u0
  }))
    (asserts! (>= stake min-stake) err-insufficient-stake)
    (asserts! (is-none (map-get? nodes {node-address: tx-sender})) err-node-exists)
    (ok (map-set nodes {node-address: tx-sender} node-data))
  )
)

;; Node heartbeat
(define-public (heartbeat)
  (let ((node (unwrap! (map-get? nodes {node-address: tx-sender}) err-node-not-found)))
    (ok (map-set nodes 
      {node-address: tx-sender}
      (merge node {
        last-heartbeat: block-height,
        uptime: (+ (get uptime node) u1)
      })
    ))
  )
)

;; Get node info
(define-read-only (get-node-info (node-address principal))
  (ok (map-get? nodes {node-address: node-address}))
)
