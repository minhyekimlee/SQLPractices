 -- lab 3
 -- Ch 6. ex 1
 SELECT vendor_id, sum(invoice_total) AS invoice_total_sum
 FROM invoices
 GROUP BY vendor_id;
 
 -- Ch 6. ex 2
 
 SELECT vendor_name, sum(payment_total) AS payment_total_sum
 FROM vendors v JOIN invoices i
 ON v.vendor_id = i.vendor_id
 GROUP BY vendor_name
 ORDER BY payment_total_sum DESC;
 
 -- Ch 6. ex 3
 
 SELECT vendor_name, count(*) AS invoice_count, SUM(invoice_total) AS invoice_total_sum
 FROM vendors v JOIN invoices i
 ON v.vendor_id = i.vendor_id
 GROUP BY vendor_name
 ORDER BY invoice_count DESC;
 
 -- Ch 6. ex 4
 
 SELECT account_description, count(*) AS line_items_count, sum(line_item_amount) AS line_item_sum
 FROM general_ledger_accounts gl JOIN invoice_line_items li
 ON gl.account_number = li.account_number
 GROUP BY account_description
 HAVING line_items_count > 1
 ORDER BY line_item_sum DESC;
 
 -- Ch 6. ex 5
 
 SELECT account_description, count(*) AS line_items_count, sum(line_item_amount) AS line_item_sum
 FROM general_ledger_accounts gl JOIN invoice_line_items li
 ON gl.account_number = li.account_number
 JOIN invoices i
 ON li.invoice_id = i.invoice_id
 WHERE invoice_date BETWEEN '2018-04-01' AND '2018-06-30'
 GROUP BY account_description
 HAVING line_items_count > 1
 ORDER BY line_item_sum DESC;
 
 -- Ch 6. ex 6
 
SELECT account_number, sum(line_item_amount) AS line_item_sum
FROM invoice_line_items
GROUP BY account_number WITH ROLLUP;
 
 
 -- Ch 6. ex 7
 
 SELECT vendor_name, COUNT(DISTINCT li.account_number) AS number_of_gl_accounts
 FROM vendors v JOIN invoices i ON v.vendor_id = i.vendor_id
 JOIN invoice_line_items li ON i.invoice_id = li.invoice_id
 GROUP BY vendor_name
 ORDER BY vendor_name;
 
 -- Ch 7. ex 1
 SELECT vendor_name
 FROM vendors
 WHERE vendor_id IN (SELECT DISTINCT vendor_id FROM invoices)
 ORDER BY vendor_name;
 
 -- Ch 7. ex 2
SELECT invoice_number, invoice_total
FROM invoices
WHERE payment_total >
(SELECT AVG(payment_total)
FROM invoices WHERE payment_total >0)
ORDER BY invoice_total DESC;


 -- Ch 7. ex 3
 SELECT account_number, account_description
 FROM general_ledger_accounts gl
WHERE NOT EXISTS
(SELECT *
FROM invoice_line_items li WHERE li.account_number = gl.account_number)
ORDER BY account_number; 
 
 -- Ch 7. ex 4
 
 SELECT vendor_name, invoice_id, invoice_sequence, line_item_amount
 FROM vendors v JOIN invoices i
 ON v.vendor_id = i.vendor_id
 JOIN invoice_line_items li ON i.invoice_id = li.invoice_id
WHERE i.invoice_id IN (SELECT DISTINCT invoice_id
 FROM invoice_line_items WHERE invoice_sequence > 1)
 ORDER BY vendor_name, i.invoice_id, invoice_sequence;
 
 -- Ch 7. ex 5
 SELECT vendor_name, vendor_state, vendor_city
 FROM vendors
 WHERE CONCAT(vendor_state, vendor_city) NOT IN
 (SELECT CONCAT(vendor_state, vendor_city)
 FROM vendors
 GROUP BY vendor_state, vendor_city
 HAVING COUNT(*) >1)
 ORDER BY vendor_state, vendor_city;