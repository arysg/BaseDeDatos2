
INSERT INTO Huespedes (nombre, apellido, tipo_documento, nro_documento, telefono, email, direccion, fecha_nacimiento, nacionalidad) VALUES
('Carlos', 'González', 'DNI', 35678901, '3514567890', 'carlos.gonzalez@gmail.com', 'Av. Colón 1234, Córdoba', '1990-03-15', 'Argentina'),
('María', 'López', 'DNI', 28345612, '3515678901', 'maria.lopez@hotmail.com', 'San Martín 567, Rosario', '1985-07-22', 'Argentina'),
('João', 'Silva', 'Pasaporte', 44556677, '5511987654321', 'joao.silva@gmail.com', 'Rua Augusta 300, São Paulo', '1992-11-10', 'Brasil'),
('Laura', 'Martínez', 'DNI', 40123456, '3516789012', 'laura.martinez@yahoo.com', 'Belgrano 890, Buenos Aires', '1998-01-30', 'Argentina'),
('Pedro', 'Ramírez', 'DNI', 33789012, '3517890123', 'pedro.ramirez@gmail.com', 'Rivadavia 2345, Mendoza', '1988-05-18', 'Argentina'),
('Ana', 'Fernández', 'DNI', 37456789, '3518901234', NULL, 'Sarmiento 456, Córdoba', '1993-09-05', 'Argentina'),
('Diego', 'Torres', 'DNI', 42567890, '3519012345', 'diego.torres@outlook.com', NULL, '2000-12-25', 'Argentina'),
('Lucía', 'Morales', 'DNI', 31234567, NULL, 'lucia.morales@gmail.com', 'Vélez Sarsfield 678, Córdoba', '1986-04-12', 'Argentina'),
('Roberto', 'Acosta', 'Pasaporte', 55667788, '5989876543', 'roberto.acosta@gmail.com', 'Av. 18 de Julio 1500, Montevideo', '1979-08-20', 'Uruguay'),
('Valentina', 'Ruiz', 'DNI', 39876543, '3512345678', 'vale.ruiz@gmail.com', 'Chacabuco 123, Córdoba', '1996-06-14', 'Argentina');

-- =============================================
-- TIPOS DE HABITACION
-- =============================================

INSERT INTO Tipo_Habitacion (nombre, capacidad, precio_por_noche, descripcion) VALUES
('Single', 1, 35000.00, 'Habitación individual con cama single, TV y baño privado'),
('Doble', 2, 55000.00, 'Habitación con cama doble, TV, minibar y baño privado'),
('Triple', 3, 72000.00, 'Habitación con cama doble y single, TV, minibar y baño privado'),
('Suite', 2, 120000.00, 'Suite premium con jacuzzi, sala de estar, minibar y vista panorámica');

-- =============================================
-- SERVICIOS
-- =============================================

INSERT INTO Servicios (nombre, descripcion, precio, activo) VALUES
('Minibar', 'Consumo de bebidas y snacks del minibar de la habitación', 8500.00, 1),
('Spa', 'Sesión de spa con acceso a sauna y pileta climatizada', 25000.00, 1),
('Lavandería', 'Servicio de lavado y planchado de ropa', 12000.00, 1),
('Restaurante', 'Almuerzo o cena en el restaurante del hotel', 18000.00, 1),
('Estacionamiento', 'Cochera cubierta por día', 7000.00, 1),
('Traslado Aeropuerto', 'Transfer desde/hacia el aeropuerto', 30000.00, 1),
('Room Service', 'Servicio de comida y bebida a la habitación', 5000.00, 1),
('Desayuno Extra', 'Desayuno buffet (no incluido en la tarifa)', 9500.00, 0);

-- =============================================
-- EMPLEADOS
-- =============================================

INSERT INTO Empleados (nombre, apellido, cargo, telefono, email, fecha_ingreso, activo) VALUES
('Martín', 'Herrera', 'Gerente', '3511111111', 'martin.herrera@hoteldb.com', '2018-03-01', 'Si'),
('Sofía', 'Castro', 'Recepcionista', '3512222222', 'sofia.castro@hoteldb.com', '2020-06-15', 'Si'),
('Lucas', 'Pereyra', 'Recepcionista', '3513333333', 'lucas.pereyra@hoteldb.com', '2021-01-10', 'Si'),
('Romina', 'Díaz', 'Mucama', '3514444444', NULL, '2019-09-20', 'Si'),
('Fernando', 'Rojas', 'Mantenimiento', '3515555555', 'fernando.rojas@hoteldb.com', '2017-11-05', 'Si'),
('Gabriel', 'Molina', 'Mantenimiento', '3516666666', NULL, '2022-04-01', 'Si'),
('Carolina', 'Vega', 'Conserje', '3517777777', 'carolina.vega@hoteldb.com', '2023-02-14', 'Si'),
('Ricardo', 'Paz', 'Recepcionista', '3518888888', 'ricardo.paz@hoteldb.com', '2024-08-01', 'No');

-- =============================================
-- HABITACIONES (50 habitaciones, 5 pisos, 10 por piso)
-- =============================================

-- Piso 1: 4 Single + 4 Doble + 2 Triple
INSERT INTO Habitaciones (numero, piso, id_tipo_habitacion, estado) VALUES
(101, 1, 1, 'Disponible'),
(102, 1, 1, 'Disponible'),
(103, 1, 1, 'Disponible'),
(104, 1, 1, 'Ocupada'),
(105, 1, 2, 'Disponible'),
(106, 1, 2, 'Ocupada'),
(107, 1, 2, 'Disponible'),
(108, 1, 2, 'Disponible'),
(109, 1, 3, 'Disponible'),
(110, 1, 3, 'Disponible');

-- Piso 2: 4 Single + 4 Doble + 2 Triple
INSERT INTO Habitaciones (numero, piso, id_tipo_habitacion, estado) VALUES
(201, 2, 1, 'Disponible'),
(202, 2, 1, 'Disponible'),
(203, 2, 1, 'Ocupada'),
(204, 2, 1, 'Disponible'),
(205, 2, 2, 'Disponible'),
(206, 2, 2, 'Disponible'),
(207, 2, 2, 'En Mantenimiento'),
(208, 2, 2, 'Disponible'),
(209, 2, 3, 'Disponible'),
(210, 2, 3, 'Disponible');

-- Piso 3: 4 Single + 4 Doble + 2 Triple
INSERT INTO Habitaciones (numero, piso, id_tipo_habitacion, estado) VALUES
(301, 3, 1, 'Disponible'),
(302, 3, 1, 'Disponible'),
(303, 3, 1, 'Disponible'),
(304, 3, 1, 'Disponible'),
(305, 3, 2, 'Ocupada'),
(306, 3, 2, 'Disponible'),
(307, 3, 2, 'Disponible'),
(308, 3, 2, 'Disponible'),
(309, 3, 3, 'Disponible'),
(310, 3, 3, 'Disponible');

-- Piso 4: 3 Single + 3 Doble + 2 Triple + 2 Suite
INSERT INTO Habitaciones (numero, piso, id_tipo_habitacion, estado) VALUES
(401, 4, 1, 'Disponible'),
(402, 4, 1, 'Disponible'),
(403, 4, 1, 'Disponible'),
(404, 4, 2, 'Disponible'),
(405, 4, 2, 'Disponible'),
(406, 4, 2, 'Disponible'),
(407, 4, 3, 'Disponible'),
(408, 4, 3, 'Disponible'),
(409, 4, 4, 'Disponible'),
(410, 4, 4, 'Ocupada');

-- Piso 5: 3 Single + 3 Doble + 2 Triple + 2 Suite
INSERT INTO Habitaciones (numero, piso, id_tipo_habitacion, estado) VALUES
(501, 5, 1, 'Disponible'),
(502, 5, 1, 'Disponible'),
(503, 5, 1, 'Disponible'),
(504, 5, 2, 'Disponible'),
(505, 5, 2, 'Disponible'),
(506, 5, 2, 'Disponible'),
(507, 5, 3, 'Disponible'),
(508, 5, 3, 'En Mantenimiento'),
(509, 5, 4, 'Disponible'),
(510, 5, 4, 'Disponible');

-- =============================================
-- RESERVAS
-- =============================================

INSERT INTO Reservas (id_huesped, id_habitacion, fecha_checkin, fecha_checkout, estado, fecha_reserva, observaciones) VALUES
(1, 4,  '2026-05-20', '2026-05-25', 'En Curso', '2026-05-10', 'Solicita almohada extra'),
(2, 6,  '2026-05-22', '2026-05-28', 'En Curso', '2026-05-15', NULL),
(3, 13, '2026-05-25', '2026-05-30', 'En Curso', '2026-05-18', 'Llegada tarde, después de las 22hs'),
(4, 25, '2026-05-28', '2026-06-02', 'En Curso', '2026-05-20', NULL),
(5, 40, '2026-05-29', '2026-06-03', 'En Curso', '2026-05-22', 'Aniversario, pide decoración'),
(6, 1,  '2026-06-05', '2026-06-08', 'Confirmada', '2026-05-25', NULL),
(7, 9,  '2026-06-10', '2026-06-15', 'Confirmada', '2026-05-28', 'Viaja con mascota'),
(8, 20, '2026-06-12', '2026-06-14', 'Confirmada', '2026-05-30', NULL),
(9, 39, '2026-06-15', '2026-06-20', 'Confirmada', '2026-06-01', 'Requiere estacionamiento'),
(10, 5, '2026-04-10', '2026-04-15', 'Finalizada', '2026-04-01', NULL),
(1, 8,  '2026-03-01', '2026-03-05', 'Finalizada', '2026-02-20', NULL),
(3, 30, '2026-04-20', '2026-04-22', 'Cancelada', '2026-04-10', 'Canceló por motivos personales');

-- =============================================
-- CONSUMOS (asociados a reservas en curso y finalizadas)
-- =============================================

INSERT INTO Consumos (id_reserva, id_servicio, cantidad, fecha_consumo, subtotal) VALUES
-- Reserva 1 (Carlos en hab 104)
(1, 1, 2, '2026-05-21', 17000.00),
(1, 4, 1, '2026-05-22', 18000.00),
(1, 7, 3, '2026-05-23', 15000.00),
-- Reserva 2 (María en hab 106)
(2, 2, 1, '2026-05-23', 25000.00),
(2, 3, 1, '2026-05-24', 12000.00),
-- Reserva 3 (João en hab 203)
(3, 1, 1, '2026-05-26', 8500.00),
(3, 5, 3, '2026-05-26', 21000.00),
(3, 4, 2, '2026-05-27', 36000.00),
(3, 6, 1, '2026-05-25', 30000.00),
-- Reserva 4 (Laura en hab 305)
(4, 7, 1, '2026-05-29', 5000.00),
-- Reserva 5 (Pedro en suite 410)
(5, 2, 2, '2026-05-30', 50000.00),
(5, 4, 2, '2026-05-31', 36000.00),
(5, 1, 1, '2026-06-01', 8500.00),
-- Reserva 10 (Valentina, finalizada)
(10, 1, 1, '2026-04-11', 8500.00),
(10, 4, 1, '2026-04-12', 18000.00),
-- Reserva 11 (Carlos, finalizada)
(11, 7, 2, '2026-03-02', 10000.00),
(11, 3, 1, '2026-03-03', 12000.00);

-- =============================================
-- FACTURAS (solo para reservas finalizadas)
-- =============================================

INSERT INTO Facturas (id_reserva, fecha_emision, total_alojamiento, total_consumos, total, metodo_pago, estado) VALUES
(10, '2026-04-15', 275000.00, 26500.00, 301500.00, 'Tarjeta Crédito', 'Pagada'),
(11, '2026-03-05', 220000.00, 22000.00, 242000.00, 'Efectivo', 'Pagada');

-- =============================================
-- MANTENIMIENTO
-- =============================================

INSERT INTO Mantenimiento (id_habitacion, id_empleado, fecha_inicio, fecha_fin, descripcion, costo) VALUES
(17, 5, '2026-05-28', NULL, 'Reparación de aire acondicionado', 45000.00),
(48, 6, '2026-05-30', NULL, 'Cambio de cañerías en el baño', 60000.00),
(3,  5, '2026-05-01', '2026-05-03', 'Pintura completa de la habitación', 35000.00),
(12, 6, '2026-04-15', '2026-04-16', 'Reparación de cerradura electrónica', 15000.00),
(25, 5, '2026-04-20', '2026-04-22', 'Cambio de colchón y sommier', 80000.00);
