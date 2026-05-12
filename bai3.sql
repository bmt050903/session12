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

--Viết TRIGGER AFTER INSERT để giảm số lượng stock trong products
CREATE OR REPLACE FUNCTION update_stock_after_sale()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_stock_after_sale
AFTER INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION update_stock_after_sale();

--Thêm đơn hàng và kiểm tra products để thấy số lượng tồn kho giảm đúng
SELECT * FROM products;

INSERT INTO sales(product_id, quantity)
VALUES (1, 2);

SELECT * FROM products;