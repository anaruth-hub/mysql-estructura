-- =========================================================
-- PIZZERÍA - 01_schema.sql
-- Base de datos: pizzeria_db
-- =========================================================

DROP DATABASE IF EXISTS pizzeria_db;
CREATE DATABASE pizzeria_db CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE pizzeria_db;

-- =========================
-- 1) UBICACIÓN
-- =========================

CREATE TABLE province (
  id_province INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  UNIQUE (name)
);

CREATE TABLE locality (
  id_locality INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  id_province INT NOT NULL,
  CONSTRAINT fk_locality_province
    FOREIGN KEY (id_province) REFERENCES province(id_province),
  UNIQUE (name, id_province)
);

-- =========================
-- 2) CLIENTES
-- =========================

CREATE TABLE customer (
  id_customer INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name  VARCHAR(150) NOT NULL,
  address    VARCHAR(200) NOT NULL,
  postal_code VARCHAR(10) NOT NULL,
  id_locality INT NOT NULL,
  phone VARCHAR(20) NOT NULL,
  CONSTRAINT fk_customer_locality
    FOREIGN KEY (id_locality) REFERENCES locality(id_locality)
);

-- =========================
-- 3) TIENDAS
-- =========================

CREATE TABLE store (
  id_store INT AUTO_INCREMENT PRIMARY KEY,
  address VARCHAR(200) NOT NULL,
  postal_code VARCHAR(10) NOT NULL,
  id_locality INT NOT NULL,
  CONSTRAINT fk_store_locality
    FOREIGN KEY (id_locality) REFERENCES locality(id_locality)
);

-- =========================
-- 4) EMPLEADOS
-- =========================

CREATE TABLE employee (
  id_employee INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name  VARCHAR(150) NOT NULL,
  nif VARCHAR(20) NOT NULL UNIQUE,
  phone VARCHAR(20) NOT NULL,
  role ENUM('COOK', 'DELIVERY') NOT NULL,
  id_store INT NOT NULL,
  CONSTRAINT fk_employee_store
    FOREIGN KEY (id_store) REFERENCES store(id_store)
);

-- =========================
-- 5) CATEGORÍAS DE PIZZA
-- =========================

CREATE TABLE pizza_category (
  id_category INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  UNIQUE (name)
);

-- =========================
-- 6) PRODUCTOS
-- =========================
-- Un producto puede ser PIZZA, BURGER o DRINK.
-- Solo las PIZZA deben tener categoría.

CREATE TABLE product (
  id_product INT AUTO_INCREMENT PRIMARY KEY,
  type ENUM('PIZZA', 'BURGER', 'DRINK') NOT NULL,
  name VARCHAR(120) NOT NULL,
  description VARCHAR(255),
  image_url VARCHAR(255),
  price DECIMAL(10,2) NOT NULL,
  id_category INT NULL,
  CONSTRAINT fk_product_category
    FOREIGN KEY (id_category) REFERENCES pizza_category(id_category),
  CONSTRAINT chk_pizza_category
    CHECK (
      (type = 'PIZZA' AND id_category IS NOT NULL)
      OR (type <> 'PIZZA' AND id_category IS NULL)
    )
);

-- =========================
-- 7) PEDIDOS
-- =========================
-- delivery_type: DELIVERY (a domicilio) o PICKUP (recoger)
-- delivery_employee_id y delivered_at solo aplican si es DELIVERY.

CREATE TABLE `order` (
  id_order INT AUTO_INCREMENT PRIMARY KEY,
  created_at DATETIME NOT NULL,
  delivery_type ENUM('DELIVERY', 'PICKUP') NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  id_customer INT NOT NULL,
  id_store INT NOT NULL,

  delivery_employee_id INT NULL,
  delivered_at DATETIME NULL,

  CONSTRAINT fk_order_customer
    FOREIGN KEY (id_customer) REFERENCES customer(id_customer),

  CONSTRAINT fk_order_store
    FOREIGN KEY (id_store) REFERENCES store(id_store),

  CONSTRAINT fk_order_delivery_employee
    FOREIGN KEY (delivery_employee_id) REFERENCES employee(id_employee),

  CONSTRAINT chk_delivery_fields
    CHECK (
      (delivery_type = 'DELIVERY' AND delivery_employee_id IS NOT NULL AND delivered_at IS NOT NULL)
      OR (delivery_type = 'PICKUP' AND delivery_employee_id IS NULL AND delivered_at IS NULL)
    )
);

-- =========================
-- 8) LÍNEAS DE PEDIDO (Order items)
-- =========================
-- Aquí se guarda "la cantidad de productos que se han seleccionado"
-- (cantidad por producto dentro de un pedido)

CREATE TABLE order_item (
  id_order INT NOT NULL,
  id_product INT NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,

  PRIMARY KEY (id_order, id_product),

  CONSTRAINT fk_order_item_order
    FOREIGN KEY (id_order) REFERENCES `order`(id_order),

  CONSTRAINT fk_order_item_product
    FOREIGN KEY (id_product) REFERENCES product(id_product),

  CONSTRAINT chk_quantity_positive CHECK (quantity > 0)
);
USE pizzeria_db;
SHOW TABLES;
