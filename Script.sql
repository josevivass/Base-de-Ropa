CREATE TABLE railway.clientes (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    direccion VARCHAR(100),
    correo_electronico VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE railway.productos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    precio DECIMAL(10, 2),
    categoria VARCHAR(50),
    stock INT
);

CREATE TABLE railway.pedidos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_cliente INT,
    fecha DATE,
    estado VARCHAR(20),
    total DECIMAL(10, 2),
    FOREIGN KEY (ID_cliente) REFERENCES railway.clientes(ID)
);

CREATE TABLE railway.ventas (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_pedido INT,
    ID_producto INT,
    cantidad INT,
    precio_venta DECIMAL(10, 2),
    FOREIGN KEY (ID_pedido) REFERENCES railway.pedidos(ID),
    FOREIGN KEY (ID_producto) REFERENCES railway.productos(ID)
);

INSERT INTO railway.clientes (nombre, apellido, direccion, correo_electronico, telefono)
VALUES ('Jose', 'Vivas', 'Calle 43', 'jose@example.com', '4234565890');

INSERT INTO railway.clientes (nombre, apellido, direccion, correo_electronico, telefono)
VALUES ('Valeria', 'Santana', 'Calle 86', 'valeria@example.com', '7245657317');

INSERT INTO railway.productos (nombre, descripcion, precio, categoria, stock)
VALUES ('Pijamas de hombre', 'Calcetines medianos', 51.50, 'pantalón de mujer', 50);

INSERT INTO railway.productos (nombre, descripcion, precio, categoria, stock)
VALUES ('Calcetines grandes', 'Suéter manga larga', 76.90, 'Pijamas de mujer', 30);

INSERT INTO railway.pedidos (ID_cliente, fecha, estado, total)
VALUES (1, '2023-02-07', 'Pendiente', 0);

INSERT INTO railway.pedidos (ID_cliente, fecha, estado, total)
VALUES (2, '2024-09-20', 'Completado', 23.99);

INSERT INTO railway.ventas (ID_pedido, ID_producto, cantidad, precio_venta)
VALUES (1, 1, 2, 59.98);

INSERT INTO railway.ventas (ID_pedido, ID_producto, cantidad, precio_venta)
VALUES (2, 2, 1, 39.99);

SELECT c.nombre, c.apellido, c.direccion, c.correo_electronico
FROM railway.clientes c
INNER JOIN railway.pedidos p ON c.ID = p.ID_cliente
WHERE p.fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

SELECT p.nombre, SUM(v.cantidad) AS cantidad_vendida, SUM(v.precio_venta * v.cantidad) AS total_vendido
FROM railway.productos p
INNER JOIN railway.ventas v ON p.ID = v.ID_producto
GROUP BY p.ID
ORDER BY cantidad_vendida DESC;

SELECT c.nombre, c.apellido, COUNT(p.ID) AS cantidad_pedidos
FROM railway.clientes c
INNER JOIN railway.pedidos p ON c.ID = p.ID_cliente
WHERE p.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY c.ID
ORDER BY cantidad_pedidos DESC;

SET SQL_SAFE_UPDATES = 0;

UPDATE railway.productos
SET precio = precio * 1.10
WHERE categoria = 'Camisetas';

DELETE FROM railway.pedidos
WHERE ID NOT IN (SELECT DISTINCT ID_pedido FROM railway.ventas);

SET SQL_SAFE_UPDATES = 1;

CREATE VIEW vista_clientes_pedidos AS
SELECT c.nombre, c.apellido, p.fecha, p.total
FROM railway.clientes c
INNER JOIN railway.pedidos p ON c.ID = p.ID_cliente;
