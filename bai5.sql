CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    position VARCHAR(50)
);

CREATE TABLE employee_log (
    log_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(50),
    action_time TIMESTAMP
);

--Viết TRIGGER AFTER UPDATE để ghi log khi thông tin nhân viên thay đổi

CREATE OR REPLACE FUNCTION log_employee_update()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO employee_log(emp_name, action_time)
    VALUES (NEW.name, NOW());

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trg_employee_update
AFTER UPDATE
ON employees
FOR EACH ROW
EXECUTE FUNCTION log_employee_update();

--Thực hiện UPDATE và kiểm tra bảng employee_log

INSERT INTO employees(name, position)
VALUES
('Nguyen Van A', 'Manager'),
('Tran Thi B', 'Staff');

UPDATE employees
SET position = 'Senior Staff'
WHERE name = 'Tran Thi B';

SELECT * 
FROM employee_log;

