/*QUESTION 1

 Write a SELECT statement that returns these columns from the Products table:

       product_name               The product_name column

       list_price                        The list_price column

      date_added                   The date_added column

Return only the rows with a list price that’s greater than 400 and less than 1000.

Return rows that have DATE_ADDED column populated (it cannot be null)

Sort the result set by the DATE_ADDED column in descending sequence*/

SELECT product_name, list_price, date_added
FROM products
WHERE list_price > 400 and list_price < 1000 and date_added IS NOT NULL
ORDER BY date_added DESC;

/*QUESTION 2

Write a SELECT statement that returns these column names and data from the Order_Items table:

       item_id                         The item_id column

      item_price                    The item_price column

      discount_amount          The discount_amount column

      quantity                        The quantity column

      price_total                     A column that’s calculated by multiplying the item price by the quantity

     discount_total                A column that’s calculated by multiplying the discount amount by the quantity

     item_total                      A column that’s calculated by subtracting the discount amount from the item price and then  

                                            multiplying by the quantity

Only return rows where the item_total is greater than 350.

Sort the result set by the item_total column in descending sequence.*/

SELECT item_id, item_price, discount_amount, quantity,
(item_price * quantity) AS price_total,
(discount_amount * quantity) AS discount_total,
((item_price - discount_amount) * quantity) AS item_total
FROM order_items
WHERE ((item_price - discount_amount) * quantity) > 350
ORDER BY item_total DESC;

/*QUESTION 3

Write a SELECT statement without a FROM clause that uses the CURRENT_DATE function to create a row with these columns:

      today_unformatted        The CURRENT_DATE function unformatted

     today_formatted            The CURRENT_DATE function in this format:  DD-Mon-YYYY

This displays a number for the day, an abbreviation for the month, and a four-digit year.*/

SELECT current_date() AS today_unformatted,
date_format(current_date(), '%e-%b-%Y') AS today_formatted;

/*QUESTION 4

Write a SELECT statement without a FROM clause that creates a row with these columns:

   price                             100 (dollars)

   tax_rate                        .07 (7 percent)

   tax_amount                   The price multiplied by the tax

   total                              The price plus the tax

To calculate the fourth column, add the expressions you used for the first and third columns.*/

SELECT 100 AS price, .07 AS tax_rate, (100 * .07) AS tax_amount, (100 + (100 * .07)) AS total;

/*QUESTION 5

Write a SELECT statement that joins the Customers table to the Addresses table and returns these columns: 

   first_name, last_name, line1, city, state, zip_code.*/
   
SELECT first_name, last_name, line1, city, state, zip_code
FROM customers c JOIN addresses a
	ON c.customer_id = a.customer_id;
    
    /*QUESTION 6

Write a SELECT statement that returns these two columns:

   category_name        The category_name column from the Categories table

   product_id               The product_id column from the Products table

Return one row for each category that has never been used.

Hint: Use an outer join and only return rows where the product_id column contains a null value.*/

SELECT category_name, product_id
FROM categories c LEFT JOIN products p
	ON c.category_id = p.category_id
WHERE product_id IS NULL;

/*QUESTION 7

 Use the UNION operator to generate a result set consisting of three columns from the Orders table: 

   ship_status              A calculated column that contains a value of  SHIPPED or NOT SHIPPED

   order_id                  The order_id column

   order_date              The order_date column

If the order has a value in the ship_date column, the ship_status column should contain a value of SHIPPED.

Otherwise, it should contain a value of NOT SHIPPED.

Sort the final result set by the order_date column.*/

SELECT 'SHIPPED' AS ship_status, order_id, order_date
FROM orders
WHERE ship_date IS NOT NULL
UNION
	SELECT 'NOT SHIPPED' AS ship_status, order_id, order_date
    FROM orders
    WHERE ship_date IS NULL
ORDER BY order_date;

/*QUESTION 8

Write an INSERT statement that adds this row to the Products table:

   product_id:                   The next automatically generated ID 

   category_id:                  4

   product_code:               dgx_640

   product_name:              Yamaha DGX 640 88-Key Digital Piano

   description:                   Long description to come.

   list_price:                     799.99

   discount_percent:          0

   date_added:                  Today’s date/time.

Use a column list for this statement.*/

INSERT INTO products
	(product_id, category_id, product_code, product_name, description, list_price, discount_percent, date_added)
VALUES
	(DEFAULT, 4, 'dgx_640', 'Yamaha DGX 640 88-Key Digital Piano', 'Long description to come.', 799.99, 0, current_date());
    
/*QUESTION 9

Write an UPDATE statement that modifies the product you added in Question 8.
This statement should change the discount_percent column from 0% to 35%.*/

UPDATE products
SET discount_percent = 35
WHERE product_id = 11;

/*QUESTION 10

Write a DELETE statement that deletes the Keyboards category.
When you execute this statement, it will produce an error since the category has related rows in the Products table.
To fix that, precede the DELETE statement with another DELETE statement that deletes all products in this category.
(Remember that to code two or more statements in a script, you must end each statement with a semicolon.)*/

DELETE FROM products
WHERE category_id = 4;
DELETE FROM categories
WHERE category_id = 4;