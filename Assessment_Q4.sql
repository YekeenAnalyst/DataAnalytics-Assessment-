-- TASK 4: Customer Lifetime Value (CLV) Estimation

-- Aggregate transaction data per customer
WITH user_transactions AS (
    SELECT 
        s.id,
        s.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.amount) AS total_transaction_value,
        AVG(s.amount * 0.001) AS avg_profit_per_transaction
    FROM savings_savingsaccount s
    GROUP BY s.id, s.owner_id
),

-- Determine customer tenure in month since joining
user_tenure AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months
    FROM users_customuser u
),

-- Determine customer life value 
clv_summary AS (
    SELECT 
        t.id AS customer_id,
        u.name,
        u.tenure_months,
        t.total_transactions,
        ROUND(
            (t.total_transactions / NULLIF(u.tenure_months, 0)) * 12 * t.avg_profit_per_transaction,
			2
        ) AS estimated_clv
    FROM user_transactions t
    JOIN user_tenure u ON u.customer_id = t.owner_id
)
-- Final Output
SELECT *
FROM clv_summary
ORDER BY estimated_clv DESC;