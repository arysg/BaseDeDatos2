-- Prueba de inserts a tablas:
-- Reservas
insert into reservas (id_huesped,id_habitacion,fecha_checkin,fecha_checkout,fecha_reserva,observaciones,Id_EstadoReserva) values (4,7,'2026-05-20','2026-05-25','2026-05-19','Tipazo',3)

-- PRUEBA DE trigger update estado habitaciones
UPDATE Habitaciones SET id_estadoHabitacion=3 WHERE id_habitacion=1;
