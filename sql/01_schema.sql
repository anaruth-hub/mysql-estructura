USE mydb;

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS glasses;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS provider;

CREATE TABLE provider (
  id_provider INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  number_phone VARCHAR(20) NOT NULL,
  fax VARCHAR(20),
  nif VARCHAR(20) NOT NULL,
  street VARCHAR(100),
  number VARCHAR(10),
  piso VARCHAR(10),
  door VARCHAR(10),
  city VARCHAR(50),
  codigo_postal VARCHAR(10),
  country VARCHAR(50)
);

CREATE TABLE employee (
  id_employee INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100)
);

CREATE TABLE customer (
  id_customer INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  address VARCHAR(150),
  number_phone VARCHAR(20),
  email VARCHAR(100),
  date_register DATE,
  id_recommender INT,
  CONSTRAINT fk_customer_recommender
    FOREIGN KEY (id_recommender)
    REFERENCES customer(id_customer)
);

CREATE TABLE glasses (
  id_glasses INT AUTO_INCREMENT PRIMARY KEY,
  brand VARCHAR(50),
  mount_tipe VARCHAR(20),
  mount_color VARCHAR(30),
  price DECIMAL(10,2) NOT NULL,
  id_provider INT NOT NULL,
  CONSTRAINT fk_glasses_provider
    FOREIGN KEY (id_provider)
    REFERENCES provider(id_provider)
);

CREATE TABLE sales (
  id_sales INT AUTO_INCREMENT PRIMARY KEY,
  sale_date DATE,
  id_customer INT NOT NULL,
  id_employee INT NOT NULL,
  id_glasses INT NOT NULL,
  CONSTRAINT fk_sales_customer
    FOREIGN KEY (id_customer)
    REFERENCES customer(id_customer),
  CONSTRAINT fk_sales_employee
    FOREIGN KEY (id_employee)
    REFERENCES employee(id_employee),
  CONSTRAINT fk_sales_glasses
    FOREIGN KEY (id_glasses)
    REFERENCES glasses(id_glasses)
);
