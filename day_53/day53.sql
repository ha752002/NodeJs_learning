-- Tạo database
CREATE DATABASE database_02_hongha;

-- Chuyển sang database
-- \c database_02_hongha;

-- Tạo bảng khách hàng
CREATE TABLE IF NOT EXISTS customers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	email VARCHAR(50),
	phone varchar(11)
);
-- Tạo bảng sản phẩm
CREATE TABLE IF NOT EXISTS products (
	id SERIAL PRIMARY KEY,
	product_code varchar(20),
	name VARCHAR(255),
	price int
);
-- Tạo bảng danh sách đơn hàng
CREATE TABLE IF NOT EXISTS orders (
	id SERIAL PRIMARY KEY,
	status VARCHAR(255),
	order_time TIMESTAMP
);

-- Tạo bảng chi tiết đơn hàng
CREATE TABLE IF NOT EXISTS order_details (
	id SERIAL PRIMARY KEY,
	order_id INT REFERENCES orders (id),
	product_id INT REFERENCES products(id),
	quantity INT
);
 
CREATE OR REPLACE FUNCTION create_order()
  RETURNS TRIGGER AS $$
  BEGIN
      NEW.order_time = now();
      RETURN NEW;
  END;
  $$ language 'plpgsql';
 
CREATE TRIGGER set_order_time
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE PROCEDURE create_order();

INSERT INTO customers (name, email, phone)
VALUES
('Nguyễn Văn A', 'nguyenvana@gmail.com', '0912345678'),
('Trần Thị B', 'tranthib@gmail.com', '0987654321'),
('Lê Văn C', 'levenc@gmail.com', '0123456789');

INSERT INTO products (product_code, name, price)
VALUES
('SP001', 'Áo thun', 120000),
('SP002', 'Quần jean', 250000),
('SP003', 'Giày thể thao', 550000);

INSERT INTO orders (status)
VALUES
('Đang chờ xử lý'),
('Đang giao hàng'),
('Đã giao hàng');

INSERT INTO order_details (order_id, product_id, quantity)
VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(3, 1, 3),
(3, 2, 2),
(3, 3, 1);

SELECT
    orders.id AS order_id,
    customers.name AS customer_name,
    customers.email AS customer_email,
    customers.phone AS customer_phone,
    orders.status AS order_status,
    orders.order_time AS order_time,
    products.product_code AS product_code,
    products.name AS product_name,
    products.price AS product_price,
    order_details.quantity AS product_quantity
FROM orders
JOIN customers ON orders.id = customers.id
JOIN order_details ON orders.id = order_details.order_id
JOIN products ON order_details.product_id = products.id;