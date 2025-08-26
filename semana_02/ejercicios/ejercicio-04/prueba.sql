CREATE TABLE IF NOT EXISTS empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_ingreso DATE NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    departamento VARCHAR(50) NOT NULL
);

INSERT INTO empleados(nombre, apellido, fecha_ingreso, salario, departamento) VALUES
('Juan', 'Pérez', '2020-01-15', 3000.00, 'Recursos Humanos'),
('Ana', 'Gómez', '2019-03-22', 3500.00, 'Finanzas'),
('Luis', 'Martínez', '2021-07-10', 2800.00, 'Marketing'),
('María', 'López', '2018-11-05', 4000.00, 'IT'),
('Carlos', 'Sánchez', '2022-02-18', 3200.00, 'Ventas');