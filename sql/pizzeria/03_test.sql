USE pizzeria_db;

-- =========================
-- 1) SANITY COUNTS
-- =========================
SELECT 'province' AS tabla, COUNT(*) AS total FROM province
UNION ALL SELECT 'locality', COUNT(*) FROM locality
UNION ALL SELECT 'store', COUNT(*) FROM store
UNION ALL SELECT 'employee', COUNT(*) FROM employee
UNION ALL SELECT 'customer', COUNT(*) FROM customer
UNION ALL SELECT 'pizza_category', COUNT(*) FROM pizza_category
UNION ALL SELECT 'product', COUNT(*) FROM product
UNION ALL SELECT 'order', COUNT(*) FROM `order`
UNION ALL SELECT 'order_item', COUNT(*) FROM order_item;

-- =========================
-- 2) LISTADO DE PEDIDOS (con cliente, tienda y repartidor si aplica)
-- =========================
SELECT
  o.id_order,
  o.created_at,
  o.delivery_type,
  o.total_price,
  CONCAT(c.first_name, ' ', c.last_name) AS customer,
  s.address AS store_address,
  CASE
    WHEN o.delivery_type = 'DELIVERY'
    THEN CONCAT(e.first_name, ' ', e.last_name)
    ELSE NULL
  END AS delivery_employee,
  o.delivered_at
FROM `order` o
JOIN customer c ON c.id_customer = o.id_customer
JOIN store s ON s.id_store = o.id_store
LEFT JOIN employee e ON e.id_employee = o.delivery_employee_id
ORDER BY o.id_order;

-- =========================
-- 3) DETALLE DE LÍNEAS POR PEDIDO
-- =========================
SELECT
  o.id_order,
  p.type,
  p.name AS product,
  oi.quantity,
  oi.unit_price,
  (oi.quantity * oi.unit_price) AS line_total
FROM `order` o
JOIN order_item oi ON oi.id_order = o.id_order
JOIN product p ON p.id_product = oi.id_product
ORDER BY o.id_order, p.type, p.name;

-- =========================
-- 4) VALIDACIÓN: total_price vs suma de líneas
-- =========================
SELECT
  o.id_order,
  o.total_price,
  SUM(oi.quantity * oi.unit_price) AS computed_total
FROM `order` o
JOIN order_item oi ON oi.id_order = o.id_order
GROUP BY o.id_order, o.total_price;

-- =========================
-- 5) TESTS NEGATIVOS (deben FALLAR)
-- =========================

-- 5.1) Insertar PIZZA sin categoría (violación CHECK)
-- Si tu MySQL aplica CHECK, debe fallar.
INSERT INTO product (type, name, description, image_url, price, id_category)
VALUES ('PIZZA', 'Pizza Sin Categoria', 'Debe fallar', 'x.jpg', 10.00, NULL);

-- 5.2) Insertar BURGER con categoría (violación CHECK)
INSERT INTO product (type, name, description, image_url, price, id_category)
VALUES ('BURGER', 'Burger Con Categoria', 'Debe fallar', 'x.jpg', 7.00,
        (SELECT id_category FROM pizza_category LIMIT 1));

-- 5.3) Insertar order_item con product inexistente (violación FK)
INSERT INTO order_item (id_order, id_product, quantity, unit_price)
VALUES (
  (SELECT id_order FROM `order` LIMIT 1),
  999999,
  1,
  9.99
);

-- 5.4) Intentar DELIVERY sin repartidor ni delivered_at (violación CHECK)
INSERT INTO `order` (created_at, delivery_type, total_price, id_customer, id_store, delivery_employee_id, delivered_at)
VALUES
(
  '2026-01-23 10:00:00',
  'DELIVERY',
  5.00,
  (SELECT id_customer FROM customer LIMIT 1),
  (SELECT id_store FROM store LIMIT 1),
  NULL,
  NULL
);

-- =========================
-- 6) ESTADO FINAL
-- =========================
SELECT COUNT(*) AS orders_total FROM `order`;
SELECT COUNT(*) AS order_items_total FROM order_item;
