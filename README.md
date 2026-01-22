🗄️ MySQL Structure – Optician & Pizzeria

Description
This project involves the design, implementation, and validation of two relational database models in MySQL, developed as part of an academic exercise for the bootcamp:

Optician: management of clients, suppliers, glasses, employees, and sales.

Pizzeria: management of orders, clients, employees, products, and delivery logistics.

The objective is to correctly apply relational modeling, normalization, foreign keys, integrity constraints, and SQL testing, using Docker for local deployment.

📌 Exercise Statement

Design and build complete relational databases that meet the functional requirements of two distinct domains (optician and pizzeria), including:

Consistent relational model

Creation scripts (schema)

Data loading scripts (seed)

Test scripts (tests)

Entity-relationship diagrams

Reproducible environment with Docker

✨ Functionalities
Optician

Customer management with a recommendation system (self-referral).

Supplier and product management (glasses).

Sales tracking associated with customer, employee, and product.

Referential integrity using foreign keys.

Consistency testing and real-world joins.

Pizzeria

Geographic management (provinces and cities).

Customer, store, and employee management.

Product catalog with validation by type (pizza, beverage, burger).

Order management with delivery/pickup logic.

Management of many (M):many relationships between orders and products using order_item.

🛠 Technologies

Database: MySQL 8

Containers: Docker, Docker Compose

Tools:

MySQL Workbench

IntelliJ IDEA

Language: SQL

🚀 Installation and Execution
1️⃣ Clone the repository
git clone https://github.com/anaruth-hub/mysql-estructura.git
cd mysql-estructura

2️⃣ Start containers with Docker
Optica
docker compose up -d

Pizzeria
docker compose -f docker-compose.pizzeria.yml up -d

3️⃣ Access from MySQL Workbench

Host: localhost

Port:

Optica → 3307

Pizzeria → 3308

Username: root

Password: root

4️⃣ Run SQL Scripts

Run in order from MySQL Workbench:

Optica

sql/optica/01_schema.sql
sql/optica/02_seed.sql
sql/optica/03_tests.sql

Pizzeria

sql/pizzeria/01_schema.sql
sql/pizzeria/02_seed.sql
sql/pizzeria/03_tests.sql

🧪 Tests

Table creation verification (SHOW TABLES)

Referential integrity tests (FK)

Actual JOIN queries

Negative tests that should fail (constraint validation)

The test scripts are located in the 03_tests.sql file.

🧩 Diagrams and Technical Decisions

The entity-relationship diagrams are located in the folder:

/diagram

├── optica.png

└── pizzeria.png

Key Technical Decisions

Normalization up to 3NF

Use of intermediate tables for N:M relationships

CHECK constraints for business rules

Use of ENUM for controlled values

Clear separation of schema, seed, and tests

Use of Docker for environment reproducibility

📌 Project Status

✅ Completed
✅ Validated with tests
✅ Ready for academic submission
