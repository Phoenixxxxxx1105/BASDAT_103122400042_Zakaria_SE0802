-- A. Membuat Tabel departments
CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(50) NOT NULL,
    manager_id NUMBER,
    location_id NUMBER
);

-- B. Membuat Tabel employees
CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(50) UNIQUE,
    salary NUMBER(8,2),
    commission_pct NUMBER(2,2),
    hire_date DATE NOT NULL,
    department_id NUMBER,
    CONSTRAINT fk_emp_dept FOREIGN KEY (department_id) 
        REFERENCES departments(department_id)
);

-- C. Membuat Tabel Tambahan yang Berelasi
-- Tabel Pemasok (Suppliers)
CREATE TABLE suppliers (
    supplier_id NUMBER PRIMARY KEY,
    supplier_name VARCHAR2(100) NOT NULL,
    contact_info VARCHAR2(50)
);

-- Tabel Barang (Products)
CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(100) NOT NULL,
    price NUMBER(10,2),
    supplier_id NUMBER,
    CONSTRAINT fk_prod_supp FOREIGN KEY (supplier_id) 
        REFERENCES suppliers(supplier_id)
);

-- Tabel Persediaan Barang (Inventory)
CREATE TABLE inventory (
    inventory_id NUMBER PRIMARY KEY,
    product_id NUMBER,
    quantity NUMBER DEFAULT 0,
    last_updated DATE,
    CONSTRAINT fk_inv_prod FOREIGN KEY (product_id) 
        REFERENCES products(product_id)
);

ANALYZE TABLE departments COMPUTE STATISTICS;
ANALYZE TABLE employees COMPUTE STATISTICS;
ANALYZE TABLE suppliers COMPUTE STATISTICS;
ANALYZE TABLE products COMPUTE STATISTICS;
ANALYZE TABLE inventory COMPUTE STATISTICS;

-- Insert 10 record ke departments
INSERT INTO departments VALUES (10, 'Administration', 200, 1700);
INSERT INTO departments VALUES (20, 'Marketing', 201, 1800);
INSERT INTO departments VALUES (30, 'Purchasing', 114, 1700);
INSERT INTO departments VALUES (40, 'Human Resources', 203, 2400);
INSERT INTO departments VALUES (50, 'Shipping', 121, 1500);
INSERT INTO departments VALUES (60, 'IT', 103, 1400);
INSERT INTO departments VALUES (70, 'Public Relations', 204, 2700);
INSERT INTO departments VALUES (80, 'Sales', 145, 2500); -- Penting untuk soal No. 5
INSERT INTO departments VALUES (90, 'Executive', 100, 1700);
INSERT INTO departments VALUES (100, 'Finance', 108, 1700);

-- Insert 10 record ke employees
INSERT INTO employees VALUES (101, 'Kochhar', 'NKOCHHAR', 17000, NULL, TO_DATE('21-SEP-2005','DD-MON-YYYY'), 90);
INSERT INTO employees VALUES (102, 'De Haan', 'LDEHAAN', 17000, NULL, TO_DATE('13-JAN-2001','DD-MON-YYYY'), 90);
INSERT INTO employees VALUES (103, 'Hunold', 'AHUNOLD', 9000, NULL, TO_DATE('03-JAN-2006','DD-MON-YYYY'), 60);
INSERT INTO employees VALUES (104, 'Ernst', 'BERNST', 6000, NULL, TO_DATE('21-MAY-2007','DD-MON-YYYY'), 60);
INSERT INTO employees VALUES (145, 'Russell', 'JRUSSEL', 14000, .4, TO_DATE('01-OCT-2004','DD-MON-YYYY'), 80); -- Dept 80
INSERT INTO employees VALUES (146, 'Partners', 'KPARTNER', 13500, .3, TO_DATE('05-JAN-2005','DD-MON-YYYY'), 80); -- Dept 80
INSERT INTO employees VALUES (147, 'Errazuriz', 'AERRAZUR', 12000, .3, TO_DATE('10-MAR-2005','DD-MON-YYYY'), 80); -- Dept 80
INSERT INTO employees VALUES (200, 'Whalen', 'JWHALEN', 4400, NULL, TO_DATE('17-SEP-2003','DD-MON-YYYY'), 10);
INSERT INTO employees VALUES (201, 'Hartstein', 'MHARTSTE', 13000, NULL, TO_DATE('17-FEB-2004','DD-MON-YYYY'), 20);
INSERT INTO employees VALUES (202, 'Fay', 'PFAY', 6000, NULL, TO_DATE('17-AUG-2005','DD-MON-YYYY'), 20);

-- Insert 10 record ke suppliers
INSERT INTO suppliers VALUES (1, 'TechCorp', 'tech@corp.com');
INSERT INTO suppliers VALUES (2, 'OfficeSupplies Co', 'sales@officesup.com');
INSERT INTO suppliers VALUES (3, 'LogiMech', 'info@logimech.com');
INSERT INTO suppliers VALUES (4, 'Dell IT', 'contact@dellit.com');
INSERT INTO suppliers VALUES (5, 'Cisco Net', 'net@cisco.com');
INSERT INTO suppliers VALUES (6, 'HP Enterprise', 'hp@enterprise.com');
INSERT INTO suppliers VALUES (7, 'Acer World', 'acer@world.com');
INSERT INTO suppliers VALUES (8, 'Lenovo Group', 'lenovo@group.com');
INSERT INTO suppliers VALUES (9, 'Asus Tek', 'asus@tek.com');
INSERT INTO suppliers VALUES (10, 'Apple Inc', 'apple@inc.com');

-- Insert 10 record ke products
INSERT INTO products VALUES (1001, 'ThinkPad T14', 1500, 8);
INSERT INTO products VALUES (1002, 'MacBook Pro 16', 2500, 10);
INSERT INTO products VALUES (1003, 'Cisco Router 2900', 800, 5);
INSERT INTO products VALUES (1004, 'Dell Monitor 24', 200, 4);
INSERT INTO products VALUES (1005, 'HP LaserJet', 400, 6);
INSERT INTO products VALUES (1006, 'Ergonomic Chair', 150, 2);
INSERT INTO products VALUES (1007, 'Logitech Mouse', 50, 3);
INSERT INTO products VALUES (1008, 'Mechanical Keyboard', 100, 3);
INSERT INTO products VALUES (1009, 'Server Rack 42U', 1200, 1);
INSERT INTO products VALUES (1010, 'Cat6 Cable 100m', 80, 1);

-- Insert 10 record ke inventory
INSERT INTO inventory VALUES (501, 1001, 50, SYSDATE);
INSERT INTO inventory VALUES (502, 1002, 20, SYSDATE);
INSERT INTO inventory VALUES (503, 1003, 15, SYSDATE);
INSERT INTO inventory VALUES (504, 1004, 100, SYSDATE);
INSERT INTO inventory VALUES (505, 1005, 30, SYSDATE);
INSERT INTO inventory VALUES (506, 1006, 75, SYSDATE);
INSERT INTO inventory VALUES (507, 1007, 200, SYSDATE);
INSERT INTO inventory VALUES (508, 1008, 150, SYSDATE);
INSERT INTO inventory VALUES (509, 1009, 10, SYSDATE);
INSERT INTO inventory VALUES (510, 1010, 500, SYSDATE);

ANALYZE TABLE departments COMPUTE STATISTICS;
ANALYZE TABLE employees COMPUTE STATISTICS;
ANALYZE TABLE suppliers COMPUTE STATISTICS;
ANALYZE TABLE products COMPUTE STATISTICS;
ANALYZE TABLE inventory COMPUTE STATISTICS;

CREATE VIEW empvu80 AS
SELECT 
    employee_id AS id_number, 
    last_name AS name, 
    salary, 
    department_id 
FROM employees 
WHERE department_id = 80;

DESCRIBE empvu80;

CREATE INDEX emp_department_ix ON employees(department_id);