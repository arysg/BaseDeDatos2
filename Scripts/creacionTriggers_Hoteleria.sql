-- Trigger cuando una reserva esta "En curso" el estado de esa habitacion pasa a "OCUPADA"
CREATE TRIGGER trg_reserva_insert
ON Reservas
AFTER INSERT
AS
BEGIN
    UPDATE Habitaciones
    SET estado = 'Ocupada'
    WHERE id_habitacion IN (
        SELECT id_habitacion FROM inserted WHERE estado = 'En Curso'
    );
END;

-- select * from Habitaciones;
------------------------------------------------------------------------

-- Este trigger modifica el estado de la habitacion cuando se updetea el estado de la reserva.
create trigger trg_reserva_update
on reservas
after update
as begin 
    if UPDATE(estado)
    begin
    update habitaciones
    set estado = 'Disponible'
    where id_habitacion in (
    select id_habitacion from inserted where estado in ('Cancelada','Finalizada'));

    update habitaciones
    set estado = 'Ocupada'
    where id_habitacion in (
    select id_habitacion from inserted where estado in ('En Curso'));
    end;
end;
 --select * from Habitaciones;
 --select * from Reservas;
------------------------------------------------------------------------
-- Trigger para calcular subtotal (precio x cantidad)
create trigger trg_consumo_insert
on consumos
after insert 
AS
BEGIN
    UPDATE c
    SET c.subtotal = i.cantidad * s.precio
    from consumos c
    inner join inserted i on i.id_consumo = c.id_consumo
    inner join Servicios s on s.id_servicio = c.id_servicio;
END;

--select * from consumos;
--select * from servicios;
------------------------------------------------------------------------
-- Trigger para mantenimientos(cuando se ingresa un mantenimiento sin fecha fin la habitacion pasa a "EN MANTENIMIENTO"

create trigger trg_mantenimiento_insert
on mantenimiento
after insert
as
begin 
    update Habitaciones
    set estado = 'EN MANTENIMIENTO'
    where id_habitacion in (select id_habitacion from inserted where fecha_fin is  null);
end;

--select * from Mantenimiento;
--select * from Habitaciones;
------------------------------------------------------------------------
-- Al eliminar un consumo recalcula los totales de la factura
create trigger trg_consumo_delete
on consumos
after delete
as 
begin
    update f
    set f.total_consumos = ISNULL((
    select sum(c.subtotal)
    from consumos c
    where c.id_reserva = f.id_reserva
    ),0),
    f.total = f.total_alojamiento + ISNULL((
    select sum (c.subtotal)
    from consumos c
    where c.id_reserva = f.id_reserva
    ),0)
    from facturas f 
    inner join deleted d on d.id_reserva = f.id_reserva;
 end;

  --  select * from consumos;
  --  select * from Facturas;
------------------------------------------------------------------------
-- al eliminar una reserva se cambia el estado de la habitacion

create trigger trg_reserva_delete
on reservas
after delete
as
begin
    update Habitaciones
    set estado = 'Disponible'
    where id_habitacion in 
    (select id_habitacion from deleted where estado = 'En Curso' );
end;


-- select * from Reservas;
-- select * from Habitaciones;


------------------------------------------------------------------------

--Trigger cuando se finaliza un mantenimiento (se carga fecha_fin) libera la habitacion
CREATE TRIGGER trg_mantenimiento_update
ON Mantenimiento
AFTER UPDATE
AS
BEGIN
    IF UPDATE(fecha_fin)
    BEGIN
        UPDATE Habitaciones
        SET estado = 'Disponible'
        WHERE id_habitacion IN (
            SELECT I.id_habitacion
            FROM inserted I
            INNER JOIN deleted D ON D.id_mantenimiento = I.id_mantenimiento
            WHERE D.fecha_fin IS NULL AND I.fecha_fin IS NOT NULL
        );
    END;
END;
------------------------------------------------------------------------

-- TRIGGER PARA ACTUALIZAR EL ESTADO cuando se inserta una reserva.

CREATE TRIGGER trg_reserva_insertaEstado
ON Reservas
AFTER INSERT
AS
BEGIN
    UPDATE r
    SET r.estado = e.estadoNombre
    from reservas r
    inner join inserted i on i.id_reserva = r.id_reserva
    inner join Estados e on e.Id_Estado =  r.Id_EstadoReserva
    where e.tabla = 'Reservas'
END;

------------------------------------------------------------------------
-- Trigger para actualizar el estado cuando se updatea el id_estadohabitacion

CREATE TRIGGER trg_habitaciones_updateEstado
ON habitaciones
AFTER UPDATE
AS
BEGIN
    UPDATE r
    SET r.estado = e.estadoNombre
    from Habitaciones r
    inner join inserted i on i.id_habitacion = r.id_habitacion
    inner join Estados e on e.Id_Estado =  r.id_estadoHabitacion
    where e.tabla = 'Habitaciones'
END;