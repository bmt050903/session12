CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    price NUMERIC
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity INT,
    total_amount NUMERIC
);

--Viết TRIGGER BEFORE INSERT để tự động tính total_amount
CREATE OR REPLACE FUNCTION calculate_total_amount()
RETURNS TRIGGER AS $$
DECLARE
    product_price NUMERIC;
BEGIN
    -- Lấy giá sản phẩm
    SELECT price
    INTO product_price
    FROM products
    WHERE product_id = NEW.product_id;

    -- Tính tổng tiền
    NEW.total_amount := NEW.quantity * product_price;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calculate_total
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION calculate_total_amount();


--Thêm vài đơn hàng và kiểm tra cột total_amount

INSERT INTO products(name, price)
VALUES
('Laptop', 1000),
('Mouse', 50);

INSERT INTO orders(product_id, quantity)
VALUES (1, 2);

SELECT * FROM orders;