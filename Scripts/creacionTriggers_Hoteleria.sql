CREATE TRIGGER trg_reserva_insert
ON Reservas
AFTER INSERT
AS
BEGIN
    UPDATE Habitaciones
    SET id_estadoHabitacion = 2
    WHERE id_habitacion IN (
        SELECT id_habitacion FROM inserted WHERE Id_EstadoReserva = 6
    );
END;
GO

CREATE TRIGGER trg_reserva_update
ON Reservas
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Id_EstadoReserva)
    BEGIN
        UPDATE Habitaciones
        SET id_estadoHabitacion = 1
        WHERE id_habitacion IN (
            SELECT id_habitacion FROM inserted WHERE Id_EstadoReserva IN (7, 8));

        UPDATE Habitaciones
        SET id_estadoHabitacion = 2
        WHERE id_habitacion IN (
            SELECT id_habitacion FROM inserted WHERE Id_EstadoReserva = 6);
    END;
END;
GO

CREATE TRIGGER trg_consumo_insert
ON Consumos
AFTER INSERT
AS
BEGIN
    UPDATE c
    SET c.subtotal = i.cantidad * s.precio
    FROM Consumos c
    INNER JOIN inserted i ON i.id_consumo = c.id_consumo
    INNER JOIN Servicios s ON s.id_servicio = c.id_servicio;
END;
GO

CREATE TRIGGER trg_mantenimiento_insert
ON Mantenimiento
AFTER INSERT
AS
BEGIN
    UPDATE Habitaciones
    SET id_estadoHabitacion = 3
    WHERE id_habitacion IN (SELECT id_habitacion FROM inserted WHERE fecha_fin IS NULL);
END;
GO

CREATE TRIGGER trg_consumo_delete
ON Consumos
AFTER DELETE
AS
BEGIN
    UPDATE f
    SET f.total_consumos = ISNULL((
        SELECT SUM(c.subtotal)
        FROM Consumos c
        WHERE c.id_reserva = f.id_reserva
    ), 0),
    f.total = f.total_alojamiento + ISNULL((
        SELECT SUM(c.subtotal)
        FROM Consumos c
        WHERE c.id_reserva = f.id_reserva
    ), 0)
    FROM Facturas f
    INNER JOIN deleted d ON d.id_reserva = f.id_reserva;
END;
GO

CREATE TRIGGER trg_reserva_delete
ON Reservas
AFTER DELETE
AS
BEGIN
    UPDATE Habitaciones
    SET id_estadoHabitacion = 1
    WHERE id_habitacion IN (
        SELECT id_habitacion FROM deleted WHERE Id_EstadoReserva = 6);
END;
GO

CREATE TRIGGER trg_mantenimiento_update
ON Mantenimiento
AFTER UPDATE
AS
BEGIN
    IF UPDATE(fecha_fin)
    BEGIN
        UPDATE Habitaciones
        SET id_estadoHabitacion = 1
        WHERE id_habitacion IN (
            SELECT I.id_habitacion
            FROM inserted I
            INNER JOIN deleted D ON D.id_mantenimiento = I.id_mantenimiento
            WHERE D.fecha_fin IS NULL AND I.fecha_fin IS NOT NULL
        );
    END;
END;
GO

CREATE TRIGGER trg_reserva_insertaEstado
ON Reservas
AFTER INSERT
AS
BEGIN
    UPDATE r
    SET r.estado = e.EstadoNombre
    FROM Reservas r
    INNER JOIN inserted i ON i.id_reserva = r.id_reserva
    INNER JOIN Estados e ON e.Id_Estado = r.Id_EstadoReserva
    WHERE e.Tabla = 'Reservas'
END;
GO

CREATE TRIGGER trg_reserva_updateEstado
ON Reservas
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Id_EstadoReserva)
    BEGIN
        UPDATE r
        SET r.estado = e.EstadoNombre
        FROM Reservas r
        INNER JOIN inserted i ON i.id_reserva = r.id_reserva
        INNER JOIN Estados e ON e.Id_Estado = r.Id_EstadoReserva
        WHERE e.Tabla = 'Reservas'
    END;
END;
GO

CREATE TRIGGER trg_habitaciones_updateEstado
ON Habitaciones
AFTER UPDATE
AS
BEGIN
    UPDATE h
    SET h.estado = e.EstadoNombre
    FROM Habitaciones h
    INNER JOIN inserted i ON i.id_habitacion = h.id_habitacion
    INNER JOIN Estados e ON e.Id_Estado = h.id_estadoHabitacion
    WHERE e.Tabla = 'Habitaciones'
END;
GO

CREATE TRIGGER trg_habitaciones_insertaEstado
ON Habitaciones
AFTER INSERT
AS
BEGIN
    UPDATE h
    SET h.estado = e.EstadoNombre
    FROM Habitaciones h
    INNER JOIN inserted i ON i.id_habitacion = h.id_habitacion
    INNER JOIN Estados e ON e.Id_Estado = h.id_estadoHabitacion
    WHERE e.Tabla = 'Habitaciones'
END;
GO

CREATE TRIGGER trg_reserva_updatePrHabitacion
ON Reservas
AFTER INSERT
AS
BEGIN
    UPDATE r
    SET r.PrecioHabitacion = th.precio_por_noche
    FROM Reservas r
    INNER JOIN inserted i ON i.id_reserva = r.id_reserva
    INNER JOIN Habitaciones h ON h.id_habitacion = r.id_habitacion
    INNER JOIN Tipo_Habitacion th ON th.id_tipo_habitacion = h.id_tipo_habitacion
END;
GO

CREATE TRIGGER trg_facturas_updateEstado
ON Facturas
AFTER UPDATE
AS
BEGIN
    IF UPDATE(id_estadoFactura)
    BEGIN
        UPDATE f
        SET f.estado = e.EstadoNombre
        FROM Facturas f
        INNER JOIN inserted i ON i.id_factura = f.id_factura
        INNER JOIN Estados e ON e.Id_Estado = f.id_estadoFactura
        WHERE e.Tabla = 'Facturas'
    END;
END;
GO

CREATE TRIGGER trg_facturas_insertaEstado
ON Facturas
AFTER INSERT
AS
BEGIN
    UPDATE f
    SET f.estado = e.EstadoNombre
    FROM Facturas f
    INNER JOIN inserted i ON i.id_factura = f.id_factura
    INNER JOIN Estados e ON e.Id_Estado = f.id_estadoFactura
    WHERE e.Tabla = 'Facturas'
END;
GO
