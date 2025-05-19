-- TASK 2: Transaction Frequency Analysis

-- Step 1: Count transactions per customer per month
WITH monthly_transactions AS (
    SELECT 
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m-01') AS month_start,
        COUNT(*) AS transactions_in_month
    FROM savings_savingsaccount s
    WHERE s.transaction_status = 'success'
    GROUP BY owner_id, month_start
),

-- Step 2: Determine average transactions per customer
avg_transactions_per_customer AS (
    SELECT 
        owner_id,
        AVG(transactions_in_month) AS avg_transactions_per_month
    FROM monthly_transactions
    GROUP BY owner_id
),

-- Step 3: Categorize customers based on average monthly transactions
categorized_Customers AS (
    SELECT
        c.owner_id,
        avg_transactions_per_month,
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_transactions_per_customer c
)

-- Step 4: Aggregate final results
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;
