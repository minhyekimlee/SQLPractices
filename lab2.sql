-- lab 2

-- Ch 4. ex 1

SELECT *
FROM vendors v JOIN invoices i
	ON v.vendor_id = i.vendor_id;

-- Ch 4. ex 2

SELECT vendor_name, invoice_number, invoice_date, invoice_total - payment_total - credit_total AS balance_due
FROM vendors v JOIN invoices i
	ON v.vendor_id = i.vendor_id
WHERE invoice_total - payment_total - credit_total <> 0
ORDER BY vendor_name;
    
-- Ch 4. ex 3

SELECT vendor_name, default_account_number AS default_account, account_description AS description
FROM vendors v JOIN general_ledger_accounts gl
	ON v.default_account_number = gl.account_number
ORDER BY account_description, vendor_name;

-- Ch 4. ex 4

SELECT vendor_name, invoice_date, invoice_number, invoice_sequence AS li_sequence, line_item_amount AS li_amount
FROM vendors v JOIN invoices i
	ON v.vendor_id = i.vendor_id
	JOIN invoice_line_items li
		ON i.invoice_id = li.invoice_id
ORDER BY vendor_name, invoice_date, invoice_number, invoice_sequence;

-- Ch 4. ex 5

SELECT v1.vendor_id, v1.vendor_name, CONCAT(v1.vendor_contact_first_name, ' ', v1.vendor_contact_last_name) AS contact_name
FROM vendors v1 JOIN vendors v2
	ON v1.vendor_id <> v2.vendor_id AND
	v1.vendor_contact_last_name = v2.vendor_contact_last_name
    ORDER BY v1.vendor_contact_last_name;
    
-- Ch 4. ex 6

SELECT gl.account_number, gl.account_description, li.invoice_id
FROM general_ledger_accounts gl
LEFT JOIN invoice_line_items li
	ON gl.account_number = li.account_number
WHERE li.invoice_id IS NULL
ORDER BY gl.account_number;

-- Ch 4. ex 7

SELECT vendor_name, vendor_state
FROM vendors
WHERE vendor_state = 'CA'
UNION
	SELECT vendor_name, 'Outside CA'
    FROM vendors
    WHERE vendor_state <> 'CA'
    ORDER BY vendor_name;

-- Ch 5. ex 1
 
INSERT INTO terms
	(terms_id, terms_description, terms_due_days)
VALUES
  (6, 'Net due 120 days', 120);
  
-- Ch 5. ex 2

UPDATE terms
SET terms_description = 'Net due 125 days',
	terms_due_days = 125
WHERE terms_id = 6;

SELECT * FROM terms
WHERE terms_id = 6;


-- Ch 5. ex 3

DELETE FROM terms
WHERE terms_id = 6;

-- Ch 5. ex 4

INSERT INTO invoices
VALUES (DEFAULT, 32, 'AX-014-027', '2018-08-01', 434.58, 0, 0,
        2, '2018-08-31', NULL);

SELECT * FROM invoices
ORDER BY invoice_id DESC;

-- Ch 5. ex 5

INSERT INTO invoice_line_items
VALUES
(115, 1, 160, 180.23, 'Hard drive'),
(115, 2, 527, 254.35, 'Exchange Server update');

-- Ch 5. ex 6

UPDATE invoices
SET credit_total=invoice_total * .1,
payment_total = invoice_total - credit_total
WHERE invoice_id = 115;

-- Ch 5. ex 7

UPDATE vendors
SET default_account_number = 403
WHERE vendor_id = 44;

 -- Ch 5. ex 8
 
 UPDATE invoices
 SET terms_id = 2
 WHERE vendor_id IN
	(SELECT vendor_id 
    FROM vendors
    WHERE default_terms_id = 2);
    
-- Ch 5. ex 9 
-- tip: delete child first and then parent table
    
DELETE FROM invoice_line_items
WHERE invoice_id = 115;

DELETE FROM invoices
WHERE invoice_id = 115;    