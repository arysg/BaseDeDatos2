CREATE PROCEDURE sp_CrearReserva
    @id_huesped INT,
    @id_habitacion INT,
    @fecha_checkin DATE,
    @fecha_checkout DATE,
    @observaciones VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Huespedes
        WHERE id_huesped = @id_huesped
    )
    BEGIN
        RAISERROR('El huesped no existe.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM Habitaciones
        WHERE id_habitacion = @id_habitacion
    )
    BEGIN
        RAISERROR('La habitacion no existe.', 16, 1);
        RETURN;
    END;

    IF (@fecha_checkin >= @fecha_checkout)
    BEGIN
        RAISERROR('La fecha de check-out debe ser mayor a la fecha de check-in.', 16, 1);
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM Habitaciones
        WHERE id_habitacion = @id_habitacion
          AND estado <> 'Disponible'
    )
    BEGIN
        RAISERROR('La habitacion no esta disponible.', 16, 1);
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM Reservas
        WHERE id_habitacion = @id_habitacion
          AND estado <> 'Cancelada'
          AND @fecha_checkin < fecha_checkout
          AND @fecha_checkout > fecha_checkin
    )
    BEGIN
        RAISERROR('La habitacion ya tiene una reserva para esas fechas.', 16, 1);
        RETURN;
    END;

    INSERT INTO Reservas
    (
        id_huesped,
        id_habitacion,
        fecha_checkin,
        fecha_checkout,
        fecha_reserva,
        observaciones,
        Id_EstadoReserva
    )
    VALUES
    (
        @id_huesped,
        @id_habitacion,
        @fecha_checkin,
        @fecha_checkout,
        GETDATE(),
        @observaciones,
        4
    );

    PRINT 'Reserva creada correctamente.';
END;
GO
