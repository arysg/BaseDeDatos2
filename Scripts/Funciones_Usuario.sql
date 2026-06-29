CREATE FUNCTION fn_TotalEstimadoReserva
(
    @id_reserva INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = 
        (r.PrecioHabitacion * DATEDIFF(DAY, r.fecha_checkin, r.fecha_checkout))
        + ISNULL((SELECT SUM(c.subtotal) FROM Consumos c WHERE c.id_reserva = r.id_reserva), 0)
    FROM Reservas r
    WHERE r.id_reserva = @id_reserva;

    RETURN ISNULL(@total, 0);
END;
GO

CREATE FUNCTION fn_DiasHastaCheckout
(
    @id_reserva INT
)
RETURNS INT
AS
BEGIN
    DECLARE @dias INT;

    SELECT @dias = DATEDIFF(DAY, GETDATE(), r.fecha_checkout)
    FROM Reservas r
    WHERE r.id_reserva = @id_reserva;

    RETURN ISNULL(@dias, 0);
END;
GO

CREATE FUNCTION fn_CantidadReservasHuesped
(
    @id_huesped INT
)
RETURNS INT
AS
BEGIN
    DECLARE @cantidad INT;

    SELECT @cantidad = COUNT(*)
    FROM Reservas
    WHERE id_huesped = @id_huesped
      AND estado <> 'Cancelada';

    RETURN ISNULL(@cantidad, 0);
END;
GO
