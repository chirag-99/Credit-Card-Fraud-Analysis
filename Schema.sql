CREATE TABLE cardholder_details(
    id SERIAL PRIMARY KEY,
    name VARCHAR(40) NOT NULL);

CREATE TABLE credit_card_details(
	card VARCHAR(30) NOT NULL PRIMARY KEY,
	id_card_holder INT,
	FOREIGN KEY (id_card_holder) REFERENCES cardholder_details(id));

CREATE TABLE merchant_category(
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL);

CREATE TABLE merchant_details(
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	id_merchant_category INT,
	FOREIGN KEY (id_merchant_category) REFERENCES merchant_category(id));

CREATE TABLE transactions(
	id SERIAL PRIMARY KEY,
	date TIMESTAMP,
	amount MONEY NOT NULL,
	card VARCHAR(20),
	id_merchant INT,
	FOREIGN KEY (card) REFERENCES credit_card_details(card),
	FOREIGN KEY (id_merchant) REFERENCES merchant_details(id));
