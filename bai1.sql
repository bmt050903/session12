CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE customer_log (
    log_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50),
    action_time TIMESTAMP
);

INSERT INTO customers(name, email)
VALUES
('Nguyen Van A', 'a@gmail.com'),
('Tran Thi B', 'b@gmail.com');

--Tạo TRIGGER để tự động ghi log khi INSERT vào customers

CREATE OR REPLACE FUNCTION log_new_customer()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO customer_log(customer_name, action_time)
    VALUES (NEW.name, NOW());

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Thêm vài bản ghi vào customers và kiểm tra customer_log

CREATE TRIGGER trg_log_customer
AFTER INSERT ON customers
FOR EACH ROW
EXECUTE FUNCTION log_new_customer();

SELECT * FROM customer_log;