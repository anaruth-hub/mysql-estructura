-- =========================================================
-- OPTICA - 03_tests.sql
-- =========================================================
USE mydb;

-- Sanity check: conteos
SELECT 'provider' tabla, COUNT(*) total FROM provider
UNION ALL SELECT 'employee', COUNT(*) FROM employee
UNION ALL SELECT 'customer', COUNT(*) FROM customer
UNION ALL SELECT 'glasses',  COUNT(*) FROM glasses
UNION ALL SELECT 'sales',    COUNT(*) FROM sales;

-- JOIN real (venta completa)
SELECT
  s.id_sales,
  s.sale_date,
  c.name AS customer,
  e.name AS employee,
  g.brand,
  g.price
FROM sales s
JOIN customer c ON s.id_customer = c.id_customer
JOIN employee e ON s.id_employee = e.id_employee
JOIN glasses  g ON s.id_glasses  = g.id_glasses
ORDER BY s.sale_date DESC, s.id_sales DESC;

SHOW CREATE TABLE sales;

-- Tests negativos (deben FALLAR por FK)
INSERT INTO sales (sale_date, id_customer, id_employee, id_glasses)
VALUES ('2026-01-18', 99999, 1, 1);

INSERT INTO sales (sale_date, id_customer, id_employee, id_glasses)
VALUES ('2026-01-18', 1, 1, 99999);

-- Ver ventas (si fallaron los inserts, seguirá habiendo 2)
SELECT * FROM sales ORDER BY id_sales;
