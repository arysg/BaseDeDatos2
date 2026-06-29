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

CREATE VIEW vw_Reservas_ConTotalEstimado AS
SELECT
    r.id_reserva,
    hu.nombre + ' ' + hu.apellido AS huesped,
    hab.numero AS numero_habitacion,
    th.nombre AS tipo_habitacion,
    r.fecha_checkin,
    r.fecha_checkout,
    r.estado,
    dbo.fn_TotalEstimadoReserva(r.id_reserva) AS total_estimado,
    dbo.fn_DiasHastaCheckout(r.id_reserva) AS dias_restantes
FROM Reservas r
INNER JOIN Huespedes hu ON hu.id_huesped = r.id_huesped
INNER JOIN Habitaciones hab ON hab.id_habitacion = r.id_habitacion
INNER JOIN Tipo_Habitacion th ON th.id_tipo_habitacion = hab.id_tipo_habitacion
WHERE r.estado IN ('En Curso', 'Confirmada', 'Pendiente');
GO

CREATE VIEW vw_Huespedes_Frecuentes AS
SELECT
    hu.id_huesped,
    hu.nombre + ' ' + hu.apellido AS huesped,
    hu.nro_documento,
    hu.nacionalidad,
    dbo.fn_CantidadReservasHuesped(hu.id_huesped) AS reservas_activas,
    (SELECT COUNT(*) FROM Reservas r WHERE r.id_huesped = hu.id_huesped) AS reservas_totales,
    ISNULL((SELECT SUM(f.total) FROM Facturas f INNER JOIN Reservas r ON r.id_reserva = f.id_reserva WHERE r.id_huesped = hu.id_huesped AND f.estado = 'Pagada'), 0) AS gasto_total
FROM Huespedes hu
WHERE dbo.fn_CantidadReservasHuesped(hu.id_huesped) > 0;
GO
