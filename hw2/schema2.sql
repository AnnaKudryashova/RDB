CREATE TABLE IF NOT EXISTS Specialization (
    specialization_id    SERIAL PRIMARY KEY,
    specialization_name  VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Position (
    position_id    SERIAL PRIMARY KEY,
    position_name  VARCHAR(100) NOT NULL,
    salary         DECIMAL(10,2)
);

ALTER TABLE Department 
DROP COLUMN IF EXISTS specialization,
ADD COLUMN IF NOT EXISTS specialization_id INT,
ADD COLUMN IF NOT EXISTS manager_id INT;

ALTER TABLE Department 
ADD CONSTRAINT fk_department_specialization 
FOREIGN KEY (specialization_id) REFERENCES Specialization(specialization_id);

ALTER TABLE Department 
ADD CONSTRAINT fk_department_manager 
FOREIGN KEY (manager_id) REFERENCES Employee(employee_id);

ALTER TABLE Employee 
DROP COLUMN IF EXISTS position,
DROP COLUMN IF EXISTS salary,
DROP COLUMN IF EXISTS manager_id,
ADD COLUMN IF NOT EXISTS position_id INT;

ALTER TABLE Employee 
ADD CONSTRAINT fk_employee_position 
FOREIGN KEY (position_id) REFERENCES Position(position_id);