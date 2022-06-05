/*Hint:  USE my_guitar_shop database

Write a SELECT statement that returns one row for each category that has products with these columns:

The category_name column from the Categories table

The count of the products in the Products table

The list price of the least expensive product in the Products table

Sort the result set so the category with the most products appears first.*/

USE my_guitar_shop;

SELECT category_name, count(DISTINCT product_name) AS product_count, min(list_price) AS min_price
FROM categories c JOIN products p
ON c.category_id = p.category_id
GROUP BY category_name
ORDER BY count(DISTINCT product_name) DESC;

/*Write a SELECT statement that returns one row for each customer that has orders with these columns:

The email_address column from the Customers table

The sum of the item price in the Order_Items table multiplied by the quantity in the Order_Items table

The sum of the discount amount column in the Order_Items table multiplied by the quantity in the Order_Items table

Sort the result set in descending sequence by the item price total for each customer.*/

SELECT c.email_address, sum(item_price * quantity) AS sum_item_price, sum(discount_amount * quantity) AS sum_discount
FROM customers c JOIN orders ord
ON c.customer_id = ord.customer_id
JOIN order_items o ON ord.order_id = o.order_id
GROUP BY c.email_address
ORDER BY sum(item_price) DESC;

/*Write a SELECT statement that returns one row for each customer that has orders with these columns:

The email_address column from the Customers table

A count of the number of orders

The total amount for each order

(Hint: First, subtract the discount amount from the price. Then, multiply by the quantity.)

Return only those rows where the customer has more than 1 order.

Sort the result set in descending sequence by the sum of the line item amounts.*/
SELECT c.email_address, count(ord.order_id) AS order_count, sum((item_price - discount_amount) * quantity) AS sum_items
FROM customers c JOIN orders ord
ON c.customer_id = ord.customer_id
JOIN order_items o ON ord.order_id = o.order_id
GROUP BY c.email_address
HAVING count(ord.order_id) > 1
ORDER BY sum((item_price - discount_amount) * quantity) DESC;

/*Modify the solution to Question 3 above
so it only counts and totals line items that have an item_price value that’s greater than 100
and return only those rows where the customer has more than 2 orders.*/

SELECT c.email_address, count(ord.order_id) AS order_count, sum((item_price - discount_amount) * quantity) AS sum_items
FROM customers c JOIN orders ord
ON c.customer_id = ord.customer_id
JOIN order_items o ON ord.order_id = o.order_id
WHERE item_price > 100
GROUP BY c.email_address
HAVING count(ord.order_id) > 2
ORDER BY sum((item_price - discount_amount) * quantity) DESC;

/*Write a SELECT statement that answers this question: 
What is the total amount ordered for each product? Return these columns:

The product_name column from the Products table

The total amount for each product in the Order_Items table
(Hint: You can calculate the total amount by subtracting the discount amount from the item price and then multiplying it by the quantity)

Use the WITH ROLLUP operator to include a row that gives the grand total.*/
SELECT product_name, sum((item_price - discount_amount) * quantity) AS total_amount
FROM products p JOIN order_items o
ON p.product_id = o.product_id
GROUP BY product_name WITH ROLLUP;

/*Write a SELECT statement that returns  the same result set as this SELECT statement, but don’t use a join. 
Instead, use a subquery in a WHERE clause that uses the IN keyword.

SELECT DISTINCT category_name
FROM categories c JOIN products p
  ON c.category_id = p.category_id
ORDER BY category_name*/
SELECT DISTINCT category_name
FROM categories
WHERE category_id IN (SELECT DISTINCT category_id FROM products)
ORDER BY category_name;