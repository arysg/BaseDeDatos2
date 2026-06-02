
-- =============================================
-- Tablas sin dependencias (sin FKs)
-- =============================================

CREATE TABLE Huespedes (
    id_huesped      INT IDENTITY(1,1) PRIMARY KEY,
    nombre          VARCHAR(255)    NOT NULL,
    apellido        VARCHAR(255)    NOT NULL,
    tipo_documento  VARCHAR(255)    NOT NULL,
    nro_documento   INT             NOT NULL UNIQUE,
    telefono        VARCHAR(255)    NULL,
    email           VARCHAR(255)    NULL,
    direccion       VARCHAR(255)    NULL,
    fecha_nacimiento DATE           NULL,
    nacionalidad    VARCHAR(255)    NULL
);

CREATE TABLE Tipo_Habitacion (
    id_tipo_habitacion  INT IDENTITY(1,1) PRIMARY KEY,
    nombre              VARCHAR(255)    NOT NULL,
    capacidad           INT             NOT NULL,
    precio_por_noche    DECIMAL(10,2)   NOT NULL,
    descripcion         VARCHAR(255)    NULL
);

CREATE TABLE Servicios (
    id_servicio     INT IDENTITY(1,1) PRIMARY KEY,
    nombre          VARCHAR(255)    NOT NULL,
    descripcion     VARCHAR(255)    NULL,
    precio          DECIMAL(10,2)   NOT NULL,
    activo          INT             NOT NULL DEFAULT 1
);

CREATE TABLE Empleados (
    id_empleado     INT IDENTITY(1,1) PRIMARY KEY,
    nombre          VARCHAR(255)    NOT NULL,
    apellido        VARCHAR(255)    NOT NULL,
    cargo           VARCHAR(255)    NOT NULL,
    telefono        VARCHAR(255)    NULL,
    email           VARCHAR(255)    NULL,
    fecha_ingreso   DATE            NOT NULL,
    activo          VARCHAR(255)    NOT NULL DEFAULT 'Si'
);

-- =============================================
-- Tablas con 1 FK
-- =============================================

CREATE TABLE Habitaciones (
    id_habitacion       INT IDENTITY(1,1) PRIMARY KEY,
    numero              INT             NOT NULL UNIQUE,
    piso                INT             NOT NULL,
    id_tipo_habitacion  INT             NOT NULL,
    estado              VARCHAR(255)    NOT NULL DEFAULT 'Disponible',
    CONSTRAINT fk_Habitaciones_id_tipo_habitacion_Tipo_Habitacion
        FOREIGN KEY (id_tipo_habitacion) REFERENCES Tipo_Habitacion(id_tipo_habitacion)
);

-- =============================================
-- Tablas con 2 FKs
-- =============================================

CREATE TABLE Reservas (
    id_reserva      INT IDENTITY(1,1) PRIMARY KEY,
    id_huesped      INT             NOT NULL,
    id_habitacion   INT             NOT NULL,
    fecha_checkin   DATE            NOT NULL,
    fecha_checkout  DATE            NOT NULL,
    estado          VARCHAR(255)    NOT NULL DEFAULT 'Pendiente',
    fecha_reserva   DATE            NOT NULL DEFAULT GETDATE(),
    observaciones   VARCHAR(255)    NULL,
    CONSTRAINT fk_Huespedes_id_huesped_Reservas
        FOREIGN KEY (id_huesped) REFERENCES Huespedes(id_huesped),
    CONSTRAINT fk_Reservas_id_habitacion_Habitaciones
        FOREIGN KEY (id_habitacion) REFERENCES Habitaciones(id_habitacion)
);

CREATE TABLE Mantenimiento (
    id_mantenimiento    INT IDENTITY(1,1) PRIMARY KEY,
    id_habitacion       INT             NOT NULL,
    id_empleado         INT             NOT NULL,
    fecha_inicio        DATE            NOT NULL,
    fecha_fin           DATE            NULL,
    descripcion         VARCHAR(255)    NULL,
    costo               DECIMAL(10,2)   NOT NULL DEFAULT 0,
    CONSTRAINT fk_Mantenimiento_id_habitacion_Habitaciones
        FOREIGN KEY (id_habitacion) REFERENCES Habitaciones(id_habitacion),
    CONSTRAINT fk_Mantenimiento_id_empleado_Empleados
        FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE Facturas (
    id_factura          INT IDENTITY(1,1) PRIMARY KEY,
    id_reserva          INT             NOT NULL,
    fecha_emision       DATE            NOT NULL DEFAULT GETDATE(),
    total_alojamiento   DECIMAL(10,2)   NULL,
    total_consumos      DECIMAL(10,2)   NOT NULL DEFAULT 0,
    total               DECIMAL(10,2)   NOT NULL DEFAULT 0,
    metodo_pago         VARCHAR(255)    NOT NULL,
    estado              VARCHAR(255)    NOT NULL DEFAULT 'Pendiente',
    CONSTRAINT fk_id_reserva_Facturas
        FOREIGN KEY (id_reserva) REFERENCES Reservas(id_reserva)
);

CREATE TABLE Consumos (
    id_consumo      INT IDENTITY(1,1) PRIMARY KEY,
    id_reserva      INT             NOT NULL,
    id_servicio     INT             NOT NULL,
    cantidad        INT             NOT NULL DEFAULT 1,
    fecha_consumo   DATE            NOT NULL DEFAULT GETDATE(),
    subtotal        DECIMAL(10,2)   NULL,
    CONSTRAINT fk_Consumos_id_reserva_Reservas
        FOREIGN KEY (id_reserva) REFERENCES Reservas(id_reserva),
    CONSTRAINT fk_Consumos_id_servicio_Servicios
        FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio)
);
