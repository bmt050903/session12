CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    account_name VARCHAR(50),
    balance NUMERIC
);

INSERT INTO accounts(account_name, balance)
VALUES
('A', 1000),
('B', 500);

SELECT * FROM accounts;

BEGIN;

UPDATE accounts
SET balance = balance - 200
WHERE account_name = 'A';

UPDATE accounts
SET balance = balance + 200
WHERE account_name = 'B';

COMMIT;


BEGIN;

SELECT *
FROM accounts
WHERE account_name = 'A';

UPDATE accounts
SET balance = balance - 2000
WHERE account_name = 'A';

ROLLBACK;