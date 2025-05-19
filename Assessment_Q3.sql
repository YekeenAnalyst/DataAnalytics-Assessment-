-- TASK 3: Account Inactivity Alert

-- Get last transaction per plan
WITH last_transactions AS (
    SELECT 
        id,
        MAX(next_returns_date) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY id
)

-- Select active savings or investment plans with no recent transactions
SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    lt.last_transaction_date,
    DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
FROM 
	plans_plan p
JOIN 
	users_customuser u ON p.owner_id = u.id
LEFT JOIN 
	last_transactions lt ON p.id = lt.id
WHERE 
	u.is_active = 1 
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
	AND DATEDIFF(CURDATE(), lt.last_transaction_date) >= 365;
