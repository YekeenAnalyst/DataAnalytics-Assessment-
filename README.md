# Data Analytics-
## Task 1: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
I tried to understand my dataset, knowing each column title and data
I identify primary key and foreign key in each table
Then i selected the relevant field from savings_savingsaccount table, concatenate first_name and last_ name from users_customuser, count of distinct plan from plans.plan table.
Sum up the confirmed_amount as total deposit, then divided by 100 to convert the figure to Naira from kobo and rounded the output to two decimal place.
Then join user_customuser table plans_plan table on u.id equal to p.owner_id and joined savings_savingsaccount on p.id equal to s.plan.id.
Filtered my result with status_id = 1, where 1 is active plans
And only include plan with is_regular_savings is 1 and is_fund is 1, where one stand for savings and investment plan respectively.
Then order my result with total deposits in descending order.

## Task 2: Calculate the average number of transactions per customer per month and categorize them: "High Frequency" (≥10 transactions/month), "Medium Frequency" (3-9 transactions/month), "Low Frequency" (≤2 transactions/month)
I extracted number of succesful transactions per customer for each month then group by owner_id and month_start to get transaction frequency.
I calculated the avaerage number of transactions per month for each customer using monthly counts.
Then i categorized each customer into frequency bands.

## Task 3: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days)
I first determined last_transactions date with MAX(next_returns_date) for each plan with CTE named last_transactions.
I used CASE statement to categorize each plan into savings, investment and other.
Then i determine the inactivity days by finding the difference between current date and last transaction date.
Joined plans_plan table with users_customuser table with plans_plan.owner_id = users_customuser.id to ensure ony active customers are considered.
Left join last_transactions CTE to link each plan with last recoreded transaction date.
Then filter only those accounts with no transactions in the last one year.

## Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate: Account tenure (months since signup), Total transactions, Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction), Order by estimated CLV from highest to lowest
In user_transactions CTE, I determine total_transactions with count all then calculate total_transaction_value by summing the amount field in savings_savingsaccount and calculated the average profit per transaction.
In user_tenure CTE, i determined customers tenure by finding the difference between month in date.joined and current date and also concatenate first name and last name as name from users_customuser table.
In clv_summary CTE, I determined customer transaction value while joining total_transactions CTE with user_tenure CTE.
Then i selected all field from clv_summary CTE as final result and ordered it with estimated_clv in descending oreder
