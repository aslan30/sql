CREATE TABLE IF NOT EXISTS departments (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	location VARCHAR(50)
);

-- INSERT INTO departments (name, location) VALUES
-- ('Sales','Tashkent, Mirabad 5a'),
-- ('Menagement','Tashkent, Mirabad 5a'),
-- ('Finance','Tashkent, Mirabad 5a');


CREATE TABLE IF NOT EXISTS employees (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	age SMALLINT,
	position VARCHAR(50),
	department_id INT REFERENCES departments(id)
);

-- INSERT INTO employees (name, age, position, department_id) VALUES
-- ('Аслан Камалов', 25, 'Sales', 1),
-- ('Даниэль Хансеверов', 27, 'Menagement', 2),
-- ('Богдан Макаров', 30, 'Finance', 3);

-- ALTER TABLE employees
-- ADD COLUMN department_id INT REFERENCES departmens(id); --запрос добавление поля department_id

-- ALTER TABLE employees 
-- ADD CONSTRAINT fk_department_id FOREIGN KEY (department_id) REFERENCES departments(id); --запрос на связывание таб с пом. внеш. ключа


CREATE TABLE IF NOT EXISTS projects (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL
);

-- INSERT INTO projects (name) VALUES
-- ('New Seasonal Discounts'),
-- ('Financial Analytic');


CREATE TABLE IF NOT EXISTS employee_projects (
	id SERIAL PRIMARY KEY,
	employee_id INT REFERENCES employees(id),
	projects_id INT REFERENCES projects(id)
);

-- INSERT INTO employee_projects (employee_id, projects_id) VALUES
-- (1, 1),
-- (3, 2);

SELECT * FROM  employees;

SELECT employees.name, departments.name AS department_name
FROM employees
JOIN departments ON employees.department_id = departments.id;

SELECT e.name AS employee_name, COUNT(ep.employee_id) AS projects_count
FROM employees e
LEFT JOIN employee_projects ep ON e.id = ep.employee_id
GROUP BY e.name
ORDER BY e.name;

SELECT AVG(age) AS avarage_age FROM employees;

SELECT d.name AS department_name, COUNT(e.id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.name;

SELECT d.name AS department_name, COUNT(e.id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.name
ORDER BY COUNT(e.id) DESC; --по убыванию!!!

SELECT d.name AS department_name, COUNT(e.id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.name
ORDER BY COUNT(e.id) ASC; --по возрастанию!!!

CREATE INDEX idx_employees_name ON employees(name);

CREATE OR REPLACE FUNCTION set_created_date()
RETURNS TRIGGER AS $$
BEGIN
    NEW.created_date := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_created_date_trigger
BEFORE INSERT ON employees
FOR EACH ROW
EXECUTE FUNCTION set_created_date();

CREATE OR REPLACE FUNCTION update_last_updated()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_last_updated_trigger
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION update_last_updated();

INSERT INTO employees (name, age, position, department_id) VALUES
('Акмаль шакиржанов', 26, 'Sales', 1);

UPDATE employees
SET age = 45
WHERE id = 1;