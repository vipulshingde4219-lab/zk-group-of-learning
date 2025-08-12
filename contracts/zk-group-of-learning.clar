;; ZK Proof of Learning – Minimal Example
;; Stores and verifies zero-knowledge proofs of course completion
;; without revealing any exam content or private learner data.

;; Error constants
(define-constant err-invalid-proof (err u100))
(define-constant err-not-owner (err u101))

;; Contract owner
(define-constant contract-owner tx-sender)

;; Mapping: learner principal → proof hash
(define-map proof-records principal (buff 32))

;; Function 1: Submit proof hash (learner commits their ZK proof hash)
(define-public (submit-proof (learner principal) (proof-hash (buff 32)))
  (begin
    (asserts! (is-eq learner tx-sender) err-not-owner)
    (map-set proof-records learner proof-hash)
    (ok true)
  )
)

;; Function 2: Verify proof hash (check if stored proof matches given one)
(define-read-only (verify-proof (learner principal) (provided-hash (buff 32)))
  (let ((stored-hash (map-get? proof-records learner)))
    (ok (match stored-hash
         hash (is-eq hash provided-hash)
         false))
  )
)
