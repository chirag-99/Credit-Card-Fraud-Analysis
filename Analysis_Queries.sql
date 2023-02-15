-- Creating a view to group all the transactions per user (25 unique cardholders)

CREATE VIEW cardholder_transactions AS
	SELECT cardholder_details.id AS ch_id, cardholder_details.name, credit_card_details.card, transactions.id AS t_id, 
  transactions.date::date AS date, transactions.amount
	FROM cardholder_details, transactions, credit_card_details
	WHERE transactions.card = credit_card_details.card
	AND credit_card_details.id_card_holder = cardholder_details.id
	GROUP BY cardholder_details.id, cardholder_details.name, credit_card_details.card, transactions.id, transactions.date, transactions.amount
	ORDER BY cardholder_details.id ASC;
	
SELECT * FROM cardholder_transactions;



-- Analyzing top 100 (by amount) transactions during the timespan of 7A.M to 9A.M

CREATE VIEW top_100_7am_to_9am_transactions AS
	SELECT id, date::date AS date, date::time(0) AS purchase_time, card, amount FROM transactions
	WHERE amount IN (SELECT amount FROM transactions WHERE date::time(0) 
  BETWEEN '07:00:00' AND '09:00:00' ORDER BY amount DESC LIMIT 100) 
	ORDER by card, date DESC, amount DESC;
	
SELECT * FROM top_100_7am_to_9am_transactions;



-- Creating a view to count the number of transactions that were <= $2

CREATE VIEW small_transactions AS
	SELECT cardholder_details.id AS ch_id, cardholder_details.name, credit_card_details.card, COUNT(amount) AS count_transactions
	FROM cardholder_details, transactions, credit_card_details
	WHERE transactions.card = credit_card_details.card
	AND credit_card_details.id_card_holder = cardholder_details.id
	AND amount BETWEEN '$0.00' AND '$2.00'
	GROUP BY cardholder_details.id, cardholder_details.name, credit_card_details.card
	ORDER BY cardholder_details.id ASC
	;
	
SELECT * FROM small_transactions;



-- Analyzing top 10 merchants under potential fraud threat

CREATE VIEW under_threat_merchants AS
	SELECT merchant_details.id, merchant_details.name, COUNT(amount) AS transactions_between_0_and_2
	FROM  transactions, merchant_details
	WHERE transactions.id_merchant = merchant_details.id
	AND transactions.amount BETWEEN '$0.00' AND '$2.00'
	GROUP BY merchant_details.id, merchant_details.name
	ORDER BY transactions_between_0_and_2 DESC LIMIT 10;

SELECT * FROM under_threat_merchants;