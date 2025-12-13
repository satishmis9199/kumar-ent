-- SQL for Kumar Ent
CREATE DATABASE IF NOT EXISTS kumar_ent;
USE kumar_ent;

CREATE TABLE IF NOT EXISTS admin (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS material (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  quantity INT NOT NULL,
  image_path VARCHAR(512),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_uid VARCHAR(30) UNIQUE NOT NULL,
  customer_name VARCHAR(255) NOT NULL,
  customer_contact VARCHAR(100) NOT NULL,
  customer_email VARCHAR(255),
  address TEXT,
  total_amount DECIMAL(10,2) NOT NULL,
  status VARCHAR(50) DEFAULT 'Pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS order_item (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  material_id INT,
  material_name VARCHAR(255) NOT NULL,
  quantity INT NOT NULL,
  price_each DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

INSERT INTO admin (username, password_hash, email) VALUES ('admin','admin123','youradmin@gmail.com');

INSERT INTO material (name, description, price, quantity, image_path) VALUES
('Cement (50kg)', 'Ordinary Portland Cement', 450.00, 100, NULL),
('Bricks (per 1000)', 'Standard red bricks', 3500.00, 200, NULL),
('Sand (per ton)', 'River sand', 1800.00, 50, NULL);
