-- TASK 1: Determine High-Value Customers with Multiple Products

SELECT 
    s.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits
FROM 
    users_customuser u
JOIN 
    plans_plan p ON u.id = p.owner_id
JOIN 
    savings_savingsaccount s ON p.id = s.plan_id
-- Include only active plans
WHERE 
	p.status_id = 1
GROUP BY 
    u.id, u.first_name, u.last_name
-- Include only customers with savings and investment plan
HAVING 
	savings_count >= 1 AND investment_count >= 1
ORDER BY 
    total_deposits DESC;