-- =========================================================
-- OPTICA - 02_seed.sql
-- =========================================================
USE mydb;

-- 1) PROVIDERS
INSERT INTO provider
(name, number_phone, fax, nif, street, number, piso, door, city, codigo_postal, country)
VALUES
('Proveedor Óptico SA', '933112233', '933112244', 'A12345678', 'Calle Mayor', '10', '2', 'B', 'Barcelona', '08001', 'España'),
('VisionDistrib SL',    '932001122', '932001133', 'B87654321', 'Av. Diagonal', '350', '5', 'A', 'Barcelona', '08013', 'España');

-- 2) EMPLOYEES
INSERT INTO employee (name)
VALUES ('Laura Pérez'), ('Carlos Gómez');

-- 3) CUSTOMERS (sin recomendador)
INSERT INTO customer (name, address, number_phone, email, date_register, id_recommender)
VALUES
('Ana Torres',  'Av. Diagonal 123', '600111222', 'ana@mail.com',  '2025-01-10', NULL),
('Luis Martín', 'C/ Aragón 45',     '600333444', 'luis@mail.com', '2025-01-15', NULL);

-- Ahora ponemos recomendador (Luis recomendado por Ana)
UPDATE customer
SET id_recommender = (
  SELECT id_customer FROM (
    SELECT id_customer
    FROM customer
    WHERE name = 'Ana Torres'
    LIMIT 1
  ) t
)
WHERE name = 'Luis Martín';

-- 4) GLASSES
INSERT INTO glasses (brand, mount_tipe, mount_color, price, id_provider)
VALUES
('Ray-Ban', 'Metal',    'Negro', 120.50,
 (SELECT id_provider FROM provider WHERE name='Proveedor Óptico SA' LIMIT 1)
),
('Oakley',  'Plástico', 'Azul',   95.00,
 (SELECT id_provider FROM provider WHERE name='VisionDistrib SL' LIMIT 1)
);

-- 5) SALES
INSERT INTO sales (sale_date, id_customer, id_employee, id_glasses)
VALUES
('2026-01-16',
 (SELECT id_customer FROM customer WHERE name='Ana Torres' LIMIT 1),
 (SELECT id_employee FROM employee WHERE name='Laura Pérez' LIMIT 1),
 (SELECT id_glasses  FROM glasses  WHERE brand='Ray-Ban' LIMIT 1)
),
('2026-01-17',
 (SELECT id_customer FROM customer WHERE name='Luis Martín' LIMIT 1),
 (SELECT id_employee FROM employee WHERE name='Carlos Gómez' LIMIT 1),
 (SELECT id_glasses  FROM glasses  WHERE brand='Oakley' LIMIT 1)
);
