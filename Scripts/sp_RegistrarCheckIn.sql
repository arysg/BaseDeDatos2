CREATE PROCEDURE sp_RegistrarCheckIn
(
    @id_reserva INT
)
AS
BEGIN

BEGIN TRY

    IF NOT EXISTS
    (
        SELECT 1
        FROM Reservas
        WHERE id_reserva = @id_reserva
    )
    BEGIN
        RAISERROR('La reserva no existe.',16,1)
    END

    IF NOT EXISTS
    (
        SELECT 1
        FROM Reservas
        WHERE id_reserva = @id_reserva
        AND (estado = 'Pendiente' OR estado = 'Confirmada')
    )
    BEGIN
        RAISERROR('La reserva no se encuentra en un estado válido para realizar el check-in.',16,1)
    END

    UPDATE Reservas
    SET Id_EstadoReserva = 6
    WHERE id_reserva = @id_reserva

    PRINT 'Check-In realizado correctamente.'

END TRY

BEGIN CATCH

    PRINT ERROR_MESSAGE()

END CATCH

END
GO
