CREATE VIEW vw_Habitaciones_Detalle AS
SELECT 
    h.id_habitacion,
    h.numero,
    h.piso,
    th.nombre AS tipo_habitacion,
    th.capacidad,
    th.precio_por_noche,
    h.estado
FROM Habitaciones h
INNER JOIN Tipo_Habitacion th ON th.id_tipo_habitacion = h.id_tipo_habitacion;
GO

CREATE VIEW vw_Reservas_Completas AS
SELECT 
    r.id_reserva,
    hu.nombre + ' ' + hu.apellido AS huesped,
    hu.nro_documento,
    hu.telefono AS telefono_huesped,
    hab.numero AS numero_habitacion,
    hab.piso,
    th.nombre AS tipo_habitacion,
    th.precio_por_noche,
    r.fecha_checkin,
    r.fecha_checkout,
    DATEDIFF(DAY, r.fecha_checkin, r.fecha_checkout) AS noches,
    r.estado,
    r.fecha_reserva,
    r.observaciones
FROM Reservas r
INNER JOIN Huespedes hu ON hu.id_huesped = r.id_huesped
INNER JOIN Habitaciones hab ON hab.id_habitacion = r.id_habitacion
INNER JOIN Tipo_Habitacion th ON th.id_tipo_habitacion = hab.id_tipo_habitacion;
GO

CREATE VIEW vw_Ocupacion_Actual AS
SELECT 
    estado,
    COUNT(*) AS cantidad,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Habitaciones) AS DECIMAL(5,2)) AS porcentaje
FROM Habitaciones
GROUP BY estado;
GO

CREATE VIEW vw_Habitaciones_Disponibles AS
SELECT 
    h.numero,
    h.piso,
    th.nombre AS tipo_habitacion,
    th.capacidad,
    th.precio_por_noche
FROM Habitaciones h
INNER JOIN Tipo_Habitacion th ON th.id_tipo_habitacion = h.id_tipo_habitacion
WHERE h.estado = 'Disponible';
GO

CREATE VIEW vw_Consumos_Detallados AS
SELECT 
    c.id_consumo,
    r.id_reserva,
    hu.nombre + ' ' + hu.apellido AS huesped,
    hab.numero AS numero_habitacion,
    s.nombre AS servicio,
    c.cantidad,
    s.precio AS precio_unitario,
    c.subtotal,
    c.fecha_consumo
FROM Consumos c
INNER JOIN Reservas r ON r.id_reserva = c.id_reserva
INNER JOIN Huespedes hu ON hu.id_huesped = r.id_huesped
INNER JOIN Habitaciones hab ON hab.id_habitacion = r.id_habitacion
INNER JOIN Servicios s ON s.id_servicio = c.id_servicio;
GO

CREATE VIEW vw_Facturacion_Completa AS
SELECT 
    f.id_factura,
    hu.nombre + ' ' + hu.apellido AS huesped,
    hu.nro_documento,
    hab.numero AS numero_habitacion,
    r.fecha_checkin,
    r.fecha_checkout,
    DATEDIFF(DAY, r.fecha_checkin, r.fecha_checkout) AS noches,
    f.total_alojamiento,
    f.total_consumos,
    f.total,
    f.metodo_pago,
    f.estado,
    f.fecha_emision
FROM Facturas f
INNER JOIN Reservas r ON r.id_reserva = f.id_reserva
INNER JOIN Huespedes hu ON hu.id_huesped = r.id_huesped
INNER JOIN Habitaciones hab ON hab.id_habitacion = r.id_habitacion;
GO

CREATE VIEW vw_Mantenimientos_Activos AS
SELECT 
    m.id_mantenimiento,
    hab.numero AS numero_habitacion,
    hab.piso,
    e.nombre + ' ' + e.apellido AS empleado_asignado,
    e.cargo,
    m.fecha_inicio,
    DATEDIFF(DAY, m.fecha_inicio, GETDATE()) AS dias_en_mantenimiento,
    m.descripcion,
    m.costo
FROM Mantenimiento m
INNER JOIN Habitaciones hab ON hab.id_habitacion = m.id_habitacion
INNER JOIN Empleados e ON e.id_empleado = m.id_empleado
WHERE m.fecha_fin IS NULL;
GO

CREATE VIEW vw_Ingresos_Por_Tipo AS
SELECT 
    th.nombre AS tipo_habitacion,
    COUNT(DISTINCT f.id_factura) AS cantidad_facturas,
    SUM(f.total_alojamiento) AS total_alojamiento,
    SUM(f.total_consumos) AS total_consumos,
    SUM(f.total) AS ingresos_totales
FROM Facturas f
INNER JOIN Reservas r ON r.id_reserva = f.id_reserva
INNER JOIN Habitaciones hab ON hab.id_habitacion = r.id_habitacion
INNER JOIN Tipo_Habitacion th ON th.id_tipo_habitacion = hab.id_tipo_habitacion
WHERE f.estado = 'Pagada'
GROUP BY th.nombre;
GO

CREATE VIEW vw_Huespedes_Historial AS
SELECT 
    hu.id_huesped,
    hu.nombre + ' ' + hu.apellido AS huesped,
    hu.nro_documento,
    hu.nacionalidad,
    COUNT(r.id_reserva) AS total_reservas,
    SUM(CASE WHEN r.estado = 'Finalizada' THEN 1 ELSE 0 END) AS reservas_finalizadas,
    SUM(CASE WHEN r.estado = 'Cancelada' THEN 1 ELSE 0 END) AS reservas_canceladas,
    ISNULL(SUM(f.total), 0) AS gasto_total
FROM Huespedes hu
LEFT JOIN Reservas r ON r.id_huesped = hu.id_huesped
LEFT JOIN Facturas f ON f.id_reserva = r.id_reserva AND f.estado = 'Pagada'
GROUP BY hu.id_huesped, hu.nombre, hu.apellido, hu.nro_documento, hu.nacionalidad;
GO

CREATE VIEW vw_Reservas_EnCurso AS
SELECT 
    r.id_reserva,
    hu.nombre + ' ' + hu.apellido AS huesped,
    hab.numero AS numero_habitacion,
    th.nombre AS tipo_habitacion,
    r.fecha_checkin,
    r.fecha_checkout,
    DATEDIFF(DAY, r.fecha_checkin, r.fecha_checkout) AS noches_totales,
    DATEDIFF(DAY, r.fecha_checkin, GETDATE()) AS noches_transcurridas,
    th.precio_por_noche * DATEDIFF(DAY, r.fecha_checkin, r.fecha_checkout) AS total_alojamiento_estimado,
    ISNULL((SELECT SUM(c.subtotal) FROM Consumos c WHERE c.id_reserva = r.id_reserva), 0) AS total_consumos,
    th.precio_por_noche * DATEDIFF(DAY, r.fecha_checkin, r.fecha_checkout) 
        + ISNULL((SELECT SUM(c.subtotal) FROM Consumos c WHERE c.id_reserva = r.id_reserva), 0) AS total_estimado
FROM Reservas r
INNER JOIN Huespedes hu ON hu.id_huesped = r.id_huesped
INNER JOIN Habitaciones hab ON hab.id_habitacion = r.id_habitacion
INNER JOIN Tipo_Habitacion th ON th.id_tipo_habitacion = hab.id_tipo_habitacion
WHERE r.estado = 'En Curso';
GO
