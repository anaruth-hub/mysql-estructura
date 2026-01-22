USE pizzeria_db;

-- =========================
-- 1) PROVINCES
-- =========================
INSERT INTO province (name)
VALUES ('Barcelona'), ('Madrid');

-- =========================
-- 2) LOCALITIES
-- =========================
INSERT INTO locality (name, id_province)
VALUES
('Barcelona', (SELECT id_province FROM province WHERE name='Barcelona' LIMIT 1)),
('Hospitalet de Llobregat', (SELECT id_province FROM province WHERE name='Barcelona' LIMIT 1)),
('Madrid', (SELECT id_province FROM province WHERE name='Madrid' LIMIT 1));

-- =========================
-- 3) STORES
-- =========================
INSERT INTO store (address, postal_code, id_locality)
VALUES
('C/ Gran Via 100', '08010', (SELECT id_locality FROM locality WHERE name='Barcelona' LIMIT 1)),
('Av. Diagonal 250', '08020', (SELECT id_locality FROM locality WHERE name='Hospitalet de Llobregat' LIMIT 1));

-- =========================
-- 4) EMPLOYEES
-- =========================
-- Nota: creamos al menos 1 DELIVERY para pedidos a domicilio
INSERT INTO employee (first_name, last_name, nif, phone, role, id_store)
VALUES
('Laura', 'Pérez', '11111111A', '600111222', 'COOK',
 (SELECT id_store FROM store WHERE address='C/ Gran Via 100' LIMIT 1)),
('Miguel', 'Gómez', '22222222B', '600333444', 'DELIVERY',
 (SELECT id_store FROM store WHERE address='C/ Gran Via 100' LIMIT 1)),
('Ana', 'Ruiz', '33333333C', '600555666', 'COOK',
 (SELECT id_store FROM store WHERE address='Av. Diagonal 250' LIMIT 1)),
('Carlos', 'López', '44444444D', '600777888', 'DELIVERY',
 (SELECT id_store FROM store WHERE address='Av. Diagonal 250' LIMIT 1));

-- =========================
-- 5) CUSTOMERS
-- =========================
INSERT INTO customer (first_name, last_name, address, postal_code, id_locality, phone)
VALUES
('Ana', 'Torres', 'C/ Balmes 22', '08001',
 (SELECT id_locality FROM locality WHERE name='Barcelona' LIMIT 1),
 '699111222'),
('Luis', 'Martín', 'C/ Aragó 45', '08013',
 (SELECT id_locality FROM locality WHERE name='Barcelona' LIMIT 1),
 '699333444'),
('Marta', 'Sánchez', 'Av. Madrid 10', '28001',
 (SELECT id_locality FROM locality WHERE name='Madrid' LIMIT 1),
 '699555666');

-- =========================
-- 6) PIZZA CATEGORIES
-- =========================
INSERT INTO pizza_category (name)
VALUES ('Clásicas'), ('Especiales');

-- =========================
-- 7) PRODUCTS
-- =========================
-- PIZZAS (con categoría)
INSERT INTO product (type, name, description, image_url, price, id_category)
VALUES
('PIZZA', 'Margarita', 'Tomate, mozzarella, albahaca', 'margarita.jpg', 9.50,
 (SELECT id_category FROM pizza_category WHERE name='Clásicas' LIMIT 1)),
('PIZZA', 'Barbacoa', 'Pollo, salsa BBQ, cebolla', 'bbq.jpg', 11.90,
 (SELECT id_category FROM pizza_category WHERE name='Especiales' LIMIT 1));

-- BURGERS (sin categoría)
INSERT INTO product (type, name, description, image_url, price, id_category)
VALUES
('BURGER', 'Cheeseburger', 'Ternera, queso, pepinillo', 'cheeseburger.jpg', 8.90, NULL);

-- DRINKS (sin categoría)
INSERT INTO product (type, name, description, image_url, price, id_category)
VALUES
('DRINK', 'Coca-Cola', 'Lata 33cl', 'coke.jpg', 2.20, NULL),
('DRINK', 'Agua', 'Botella 50cl', 'water.jpg', 1.50, NULL);

-- =========================
-- 8) ORDERS
-- =========================
-- Pedido 1: DELIVERY (con repartidor + delivered_at)
INSERT INTO `order` (created_at, delivery_type, total_price, id_customer, id_store, delivery_employee_id, delivered_at)
VALUES
(
  '2026-01-22 20:10:00',
  'DELIVERY',
  0.00,
  (SELECT id_customer FROM customer WHERE first_name='Ana' AND last_name='Torres' LIMIT 1),
  (SELECT id_store FROM store WHERE address='C/ Gran Via 100' LIMIT 1),
  (SELECT id_employee FROM employee WHERE role='DELIVERY' AND id_store = (SELECT id_store FROM store WHERE address='C/ Gran Via 100' LIMIT 1) LIMIT 1),
  '2026-01-22 20:45:00'
);

-- Pedido 2: PICKUP (sin repartidor y sin delivered_at)
INSERT INTO `order` (created_at, delivery_type, total_price, id_customer, id_store, delivery_employee_id, delivered_at)
VALUES
(
  '2026-01-22 21:00:00',
  'PICKUP',
  0.00,
  (SELECT id_customer FROM customer WHERE first_name='Luis' AND last_name='Martín' LIMIT 1),
  (SELECT id_store FROM store WHERE address='Av. Diagonal 250' LIMIT 1),
  NULL,
  NULL
);

-- =========================
-- 9) ORDER ITEMS
-- =========================
-- Pedido 1: 1 Margarita + 2 Coca-Cola
INSERT INTO order_item (id_order, id_product, quantity, unit_price)
VALUES
(
  (SELECT id_order FROM `order` WHERE created_at='2026-01-22 20:10:00' LIMIT 1),
  (SELECT id_product FROM product WHERE name='Margarita' LIMIT 1),
  1,
  (SELECT price FROM product WHERE name='Margarita' LIMIT 1)
),
(
  (SELECT id_order FROM `order` WHERE created_at='2026-01-22 20:10:00' LIMIT 1),
  (SELECT id_product FROM product WHERE name='Coca-Cola' LIMIT 1),
  2,
  (SELECT price FROM product WHERE name='Coca-Cola' LIMIT 1)
);

-- Pedido 2: 1 Barbacoa + 1 Cheeseburger + 1 Agua
INSERT INTO order_item (id_order, id_product, quantity, unit_price)
VALUES
(
  (SELECT id_order FROM `order` WHERE created_at='2026-01-22 21:00:00' LIMIT 1),
  (SELECT id_product FROM product WHERE name='Barbacoa' LIMIT 1),
  1,
  (SELECT price FROM product WHERE name='Barbacoa' LIMIT 1)
),
(
  (SELECT id_order FROM `order` WHERE created_at='2026-01-22 21:00:00' LIMIT 1),
  (SELECT id_product FROM product WHERE name='Cheeseburger' LIMIT 1),
  1,
  (SELECT price FROM product WHERE name='Cheeseburger' LIMIT 1)
),
(
  (SELECT id_order FROM `order` WHERE created_at='2026-01-22 21:00:00' LIMIT 1),
  (SELECT id_product FROM product WHERE name='Agua' LIMIT 1),
  1,
  (SELECT price FROM product WHERE name='Agua' LIMIT 1)
);

-- =========================
-- 10) UPDATE total_price (calculado desde order_item)
-- =========================
UPDATE `order` o
SET total_price = (
  SELECT SUM(oi.quantity * oi.unit_price)
  FROM order_item oi
  WHERE oi.id_order = o.id_order
);
