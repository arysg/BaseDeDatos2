CREATE PROCEDURE sp_ReporteReservasPorPeriodo
(
    @fechaInicio DATE,
    @fechaFin DATE
)
AS
BEGIN

BEGIN TRY

    IF @fechaInicio > @fechaFin
    BEGIN
        RAISERROR('La fecha de inicio no puede ser mayor que la fecha de fin.',16,1)
    END

    SELECT
        R.id_reserva,
        H.nombre,
        H.apellido,
        HA.numero AS Habitacion,
        TH.nombre AS TipoHabitacion,
        R.fecha_checkin,
        R.fecha_checkout,
        R.estado
    FROM Reservas R
    INNER JOIN Huespedes H
        ON R.id_huesped = H.id_huesped
    INNER JOIN Habitaciones HA
        ON R.id_habitacion = HA.id_habitacion
    INNER JOIN Tipo_Habitacion TH
        ON HA.id_tipo_habitacion = TH.id_tipo_habitacion
    WHERE R.fecha_checkin BETWEEN @fechaInicio AND @fechaFin
    ORDER BY R.fecha_checkin;

END TRY

BEGIN CATCH

    PRINT ERROR_MESSAGE()

END CATCH

END
GO
