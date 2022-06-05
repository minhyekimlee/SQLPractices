-- lab 5

-- Ch. 6 ex 1
/*Exercise 1: 

Write a SELECT statement that uses aggregate window functions
to calculate the total due for all vendors and the total due for each vendor.
Return these columns:
•	The vendor id from the Invoices table
•	The balance due (invoice_total - payment_total - credit_total) for each invoice in the Invoices table 
	with a balance due greater than 0 
•	The total balance due for each vendor in the Invoices table

Modify the column that contains the balance due for each vendor so it contains a cumulative total by balance due
*/

USE ap;
SELECT vendor_id,
(invoice_total - payment_total - credit_total) AS balance_due,
SUM(invoice_total - payment_total - credit_total) OVER() AS allvendors_due,
SUM(invoice_total - payment_total - credit_total) OVER(PARTITION BY vendor_id
ORDER BY invoice_total - payment_total - credit_total) AS eachvendor_due
FROM invoices
WHERE invoice_total - payment_total - credit_total > 0;

-- Ch. 6 ex 2
/*Modify the solution to exercise 1 
so it includes a column that calculates the average balance due for each vendor in the Invoices table. 
This column should contain a cumulative average by balance due. 
Modify the SELECT statement so it uses a named window for the last two aggregate window functions.*/

USE ap;
SELECT vendor_id,
(invoice_total - payment_total - credit_total) AS balance_due,
SUM(invoice_total - payment_total - credit_total) OVER() AS allvendors_due,
SUM(invoice_total - payment_total - credit_total) OVER(PARTITION BY vendor_id
ORDER BY invoice_total - payment_total - credit_total) AS eachvendor_due,
ROUND(AVG(invoice_total - payment_total - credit_total) OVER vendor_window, 2) AS vendor_avg
FROM invoices
WHERE invoice_total - payment_total - credit_total > 0
WINDOW vendor_window AS (PARTITION BY vendor_id ORDER BY invoice_total - payment_total - credit_total);

-- Ch. 6 ex 3
/*Write a SELECT statement that uses an aggregate window function 
to calculate a moving average of the sum of invoice totals. Return these columns: 
•	The month of the invoice date from the Invoices table 
•	The sum of the invoice totals from the Invoices table 
•	The moving average of the invoice totals sorted by invoice month

The result set should be grouped by invoice month and 
the frame for the moving average should include the current row plus three rows before the current row.
*/

SELECT MONTH(invoice_date) AS month, SUM(invoice_total) AS total_invoices,
ROUND(AVG(SUM(invoice_total)) OVER (ORDER BY MONTH(invoice_date)
RANGE BETWEEN 3 PRECEDING AND CURRENT ROW), 2) AS 4_month_avg
FROM invoices
GROUP BY MONTH(invoice_date);

-- Ch. 6 ex 4
/*Write a SELECT statement that uses an aggregate window function 
to get the total amount of each order. Return these columns:
•	The order_id column from the Order_Items table
•	The total amount for each order item in the Order_Items table 
(Hint: You can calculate the total amount by subtracting the discount amount from the item price 
and then multiplying it by the quantity)
•	The total amount for each order
Sort the result set in ascending sequence by the order_id column.
*/
USE my_guitar_shop;
SELECT order_id, ((item_price - discount_amount) * quantity) AS total_amount,
SUM((item_price - discount_amount) * quantity) OVER(PARTITION BY order_id) AS total_each_order
FROM order_items
ORDER BY order_id;


-- cumulative ====> over // order by

-- Ch. 6 ex 5
/*Modify the solution to exercise 3 so the column that contains the total amount for each order contains a cumulative total 
by item amount.
Add another column to the SELECT statement that uses an aggregate window function to get the average item amount for each order.
Modify the SELECT statement so it uses a named window for the two aggregate functions. 
*/
USE my_guitar_shop;
SELECT order_id, ((item_price - discount_amount) * quantity) AS total_amount,
SUM((item_price - discount_amount) * quantity) OVER(item_window ORDER BY (item_price - discount_amount) * quantity) AS total_each_order,
ROUND(AVG((item_price - discount_amount) * quantity) OVER item_window, 2) AS avg_item_amount
FROM order_items
WINDOW item_window AS (PARTITION BY order_id)
ORDER BY order_id;

-- Ch. 7 ex 1
/*Write a SELECT statement that returns two columns: 
vendor_id and the largest unpaid invoice for each vendor. 
To do this, you can group the result set by the vendor_id column.

Write a second SELECT statement that uses the first SELECT statement in its FROM clause. 
The main query should return a single value that represents the sum of the largest unpaid invoices for each vendor.*/
USE ap;
SELECT SUM(invoice_max) AS sum_of_maximums
FROM (SELECT vendor_id, MAX(invoice_total) AS invoice_max
      FROM invoices
      WHERE invoice_total - credit_total - payment_total > 0
      GROUP BY vendor_id) t;


/*Rewrite the above query so it uses a common table expression (CTE) instead of an inline view.*/
WITH max_invoice AS
(
	SELECT vendor_id, MAX(invoice_total) AS invoice_max
    FROM invoices
    WHERE invoice_total - credit_total - payment_total > 0
    GROUP BY vendor_id
)
SELECT SUM(invoice_max) AS sum_of_maximums
FROM max_invoice;


-- Ch. 9 ex 1
/*Write a SELECT statement that returns these columns from the Invoice table of the AP database: 
•	The invoice_number column 
•	The balance due for each invoice with a balance due greater than zero 
•	A column that uses the RANK() function to rank the balance due in descending sequence
*/
SELECT invoice_number, invoice_total - payment_total - credit_total AS balance_due,
DENSE_RANK() OVER(ORDER BY invoice_total - payment_total - credit_total DESC) AS balance_rank
FROM invoices
WHERE invoice_total - payment_total - credit_total > 0;

