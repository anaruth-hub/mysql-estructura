USE mydb;

-- Providers
INSERT INTO provider
(name, number_phone, fax, nif, street, number, city, codigo_postal, country)
VALUES
('Proveedor Óptico SA', '933112233', '933112244', 'A12345678', 'Calle Mayor', '10', 'Barcelona', '08001', 'España');

-- Employees
INSERT INTO employee (name)
VALUES
('Laura Pérez'),
('Carlos Gómez');

-- Customers
INSERT INTO customer
(name, address, number_phone, email, date_register, id_recommender)
VALUES
('Ana Torres', 'Av. Diagonal 123', '600111222', 'ana@mail.com', '2025-01-10', NULL),
('Luis Martín', 'C/ Aragón 45', '600333444', 'luis@mail.com', '2025-01-15', 1);

-- Glasses
INSERT INTO glasses
(brand, mount_tipe, mount_color, price, id_provider)
VALUES
('Ray-Ban', 'Metal', 'Negro', 120.50, 1),
('Oakley', 'Plástico', 'Azul', 95.00, 1);

-- Sales
INSERT INTO sales (`date`, id_customer, id_employee, id_glasses)
VALUES
('2026-01-16',
 (SELECT id_customer FROM customer WHERE name='Ana Ruiz' LIMIT 1),
 (SELECT id_employee FROM employee WHERE name='Laura' LIMIT 1),
 (SELECT id_glasses FROM glasses WHERE brand='RayBan' LIMIT 1)
),
('2026-01-17',
 (SELECT id_customer FROM customer WHERE name='Carlos Pérez' LIMIT 1),
 (SELECT id_employee FROM employee WHERE name='Miguel' LIMIT 1),
 (SELECT id_glasses FROM glasses WHERE brand='Oakley' LIMIT 1)
);

