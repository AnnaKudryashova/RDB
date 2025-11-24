CREATE TABLE IF NOT EXISTS Department (
    department_id   SERIAL PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    specialization  TEXT,
    parent_id       INT REFERENCES Department (department_id)
);

CREATE TABLE IF NOT EXISTS Employee (
    employee_id   SERIAL PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    birthday      DATE,
    salary        DECIMAL(10,2),
    position      VARCHAR(50),
    manager_id    INT REFERENCES Employee (employee_id),
    department_id INT REFERENCES Department (department_id)
);