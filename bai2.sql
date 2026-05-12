CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    stock INT
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity INT
);

--Viết TRIGGER BEFORE INSERT để kiểm tra tồn kho
CREATE OR REPLACE FUNCTION check_stock()
RETURNS TRIGGER AS $$
DECLARE
    current_stock INT;
BEGIN
    SELECT stock
    INTO current_stock
    FROM products
    WHERE product_id = NEW.product_id;
	
    IF current_stock < NEW.quantity THEN
        RAISE EXCEPTION 'Không đủ tồn kho!';
    END IF;

    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_check_stock
BEFORE INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION check_stock();

--Thử thêm các đơn hàng vượt quá tồn kho và quan sát Trigger hoạt động
INSERT INTO products(name, stock)
VALUES
('Laptop', 5),
('Mouse', 10);

INSERT INTO sales(product_id, quantity)
VALUES (1, 3);

SELECT * FROM products;
SELECT * FROM sales;

