-- lab 4
-- Ch. 8 ex 1
USE ap;
SELECT invoice_total, format(invoice_total, 1) AS total_format,
convert(invoice_total, SIGNED) AS total_convert,
cast(invoice_total AS SIGNED) AS total_cast
FROM invoices;

-- Ch. 8 ex 2
SELECT invoice_date,
CAST(invoice_date AS DATETIME) AS invoice_datetime,
CAST(invoice_date AS CHAR(7)) AS invoice_char7
FROM invoices;

-- Ch. 9 ex 1
SELECT invoice_total,
round(invoice_total,1) AS one_digit,
round(invoice_total,0) AS zero_digit_round,
truncate(invoice_total,0) AS zero_digit_truncate
FROM invoices;

-- Ch. 9 ex 2
USE ex;
SELECT start_date,
DATE_FORMAT(start_date, '%b/%d/%y') AS format1,
DATE_FORMAT(start_date, '%c/%e/%y') AS format2,
DATE_FORMAT(start_date, '%l:%i %p') AS format3
FROM date_sample;

-- Ch. 9 ex 3
USE ap;
SELECT invoice_number,
       invoice_date,
       DATE_ADD(invoice_date, INTERVAL 30 DAY) AS date_plus_30_days,
       payment_date,
       DATEDIFF(payment_date, invoice_date) AS days_to_pay,
       MONTH(invoice_date) AS "month",
       YEAR(invoice_date) AS "year"
FROM invoices
WHERE MONTH(invoice_date) = 05;
