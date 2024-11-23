# BASE DE DATOS "standard_db"
## _Creación de una base de datos para manejo de stock de estandares de principios activos en la industria farmacéutica._

# Descripción de la temática de la base de datos.

Se intenciona crear una base de datos para manejar drogas altamente reguladas y de alto valor, a las que de ahora en mas llamaremos "estándar". Dichos estandares tienen diferentes categorias, primarios o secundarios. 

Los estandares secundarios son producidos por los laboratorios de la industria farmaceutica a travez de un estandar primario, el cual es producido por una entidad regulatoria (USP, EP, ANMAT).

A su vez, el departamento que se encarga de comprar y producir el producto en cuestion, se encarga de distribuirlos por todas las areas del laboratorio para su uso, el cual debe ser controlado ya que muchas drogas son reguladas por diferentes entidades.

El problema aparece, cuando dicha informacion se encuentra solamente en planillas de excel, y se comunica a travez de correos electronicos o de forma prescencial. Para ello se propone la implementacion de una base de datos robusta, la cual pueda agilizar y trazar dicha gestion.

# Listado de tablas

## Tabla API
Contiene información sobre cada principio activo en forma de materia prima.

| PK   | COLUMN      | TYPE    | NOT NULL | UNIQUE | LEN   | NOTES                   |
|------|-------------|---------|----------|--------|-------|-------------------------|
| TRUE | ID_API      | VARCHAR | TRUE     | TRUE   | 20    | LOTE INTERNO API        |
|      | NOMBRE      | VARCHAR | TRUE     |        | 250   | NOMBRE DEL API          |
|      | LOTE_MP     | VARCHAR | TRUE     |        | 20    | LOTE ORIGEN             |
|      | TITULO      | DECIMAL | TRUE     |        | (5,1) | TÍTULO EN (SDTC) %      |
|      | VENCIMIENTO | DATE    | TRUE     |        |       | VENCIMIENTO PROVEEDOR   |
|      | PROVEEDOR   | VARCHAR | TRUE     |        | 50    | NOMBRE DEL PROVEEDOR    |
|      | ORIGEN      | VARCHAR |          |        | 50    | PAÍS DE ORIGEN          |

## Tabla ESTANDAR
Contiene información de los estándares primarios o secundarios.

| PK   | COLUMN          | TYPE    | NOT NULL | UNIQUE | LEN   | NOTES                                              |
|------|-----------------|---------|----------|--------|-------|----------------------------------------------------|
| TRUE | LOTE_STD        | VARCHAR | TRUE     | TRUE   | 20    | LOTE DEL ESTÁNDAR                                  |
| FK   | ID_API          | VARCHAR |          |        | 20    | LOTE INTERNO DEL API PARA SECUNDARIOS             |
|      | PRESENTACION    | INT     | TRUE     |        |       | PRESENTACIÓN DE VIALES (mg)                       |
|      | TITULO          | DECIMAL | TRUE     |        | (5,1) | TÍTULO EN (SDTC) %                                 |
|      | VENCIMIENTO     | DATE    | TRUE     |        |       | VENCIMIENTO INTERNO                                |
|      | RENALISIS       | DATE    | TRUE     |        |       | REANÁLISIS INTERNO                                 |
|      | OBSERVACIONES   | VARCHAR |          |        | 250   | DESCRIPCIÓN GENERAL DEL ESTÁNDAR                  |
|      | CATEGORIA       | VARCHAR | TRUE     |        | 10    | PRIMARIO/SECUNDARIO/WORKING                       |
|      | CANT_VIAL_TOTAL | INT     | TRUE     |        |       | CANTIDAD DE VIALES GENERADOS/COMPRADOS            |

## Tabla STOCK
Contiene información del stock correspondiente a cada departamento.

| PK   | COLUMN            | TYPE    | NOT NULL | UNIQUE | LEN   | NOTES                                             |
|------|-------------------|---------|----------|--------|-------|---------------------------------------------------|
| TRUE | ID_STOCK          | INT     | TRUE     | TRUE   |       | NÚMERO DE IDENTIFICACIÓN DEL REGISTRO DE STOCK   |
| FK   | LOTE_STD          | VARCHAR | TRUE     | TRUE   | 20    | LOTE DEL ESTÁNDAR PROPORCIONADO                  |
| FK   | ID_ALMACENAMIENTO | VARCHAR | TRUE     |        | 5     | ID DEL ALMACENAMIENTO                            |
|      | CANT_VIALES       | INT     | TRUE     |        |       | CANTIDAD DE VIALES POR DEPARTAMENTO              |
| FK   | ID_ORDEN          | INT     | TRUE     | TRUE   |       | ID DE LA ORDEN EJECUTADA POR CARACTERIZACION_API |

## Tabla DEPARTAMENTO
Contiene la descripción del departamento.

| PK   | COLUMN  | TYPE    | NOT NULL | UNIQUE | LEN   | NOTES                               |
|------|---------|---------|----------|--------|-------|-------------------------------------|
| TRUE | ID_DEP  | VARCHAR | TRUE     | TRUE   | 5     | CÓDIGO INTERNO DE LOS DEPARTAMENTOS |
|      | NOMBRE  | VARCHAR | TRUE     | TRUE   | 20    | NOMBRE DETALLADO DEL DEPARTAMENTO   |

## Tabla ANALISTA
Contiene información de los analistas.

| PK   | COLUMN           | TYPE    | NOT NULL | UNIQUE | LEN   | NOTES                               |
|------|------------------|---------|----------|--------|-------|-------------------------------------|
| TRUE | LEGAJO_ANALISTA  | INT     | TRUE     | TRUE   |       | LEGAJO DE LOS ANALISTAS             |
| FK   | ID_DEP           | VARCHAR | TRUE     | TRUE   | 5     | CÓDIGO INTERNO DE LOS DEPARTAMENTOS |
|      | NOMBRE           | VARCHAR | TRUE     |        | 30    | NOMBRE DEL ANALISTA                 |
|      | APELLIDO         | VARCHAR | TRUE     |        | 30    | APELLIDO DEL ANALISTA               |
|      | DNI              | INT     | TRUE     | TRUE   |       | DOCUMENTO DE IDENTIDAD DEL ANALISTA |

## Tabla PEDIDO
Contiene información sobre los pedidos de estándares realizados por analistas de diferentes sectores.

| PK   | COLUMN          | TYPE    | NOT NULL | UNIQUE | LEN   | NOTES                               |
|------|-----------------|---------|----------|--------|-------|-------------------------------------|
| TRUE | ID_PEDIDO       | INT     | TRUE     | TRUE   |       | IDENTIFICACIÓN ÚNICA DEL PEDIDO     |
| FK   | LEGAJO_ANALISTA | INT     | TRUE     | TRUE   |       | LEGAJO DE LOS ANALISTAS             |
|      | FECHA           | DATE    | TRUE     |        |       | FECHA DE SOLICITUD DEL PEDIDO       |
|      | NOMBRE_API      | VARCHAR | TRUE     |        | 250   | API DEL ESTÁNDAR SOLICITADO         |

## Tabla CARACTERIZACION_API
Contiene información sobre el manejo de pedidos.

| PK   | COLUMN      | TYPE    | NOT NULL | UNIQUE | LEN   | NOTES                                             |
|------|-------------|---------|----------|--------|-------|---------------------------------------------------|
| TRUE | ID_ORDEN    | INT     | TRUE     | TRUE   |       | ID QUE DERIVA EL ESTÁNDAR AL STOCK CORRESPONDIENTE|
| FK   | ID_PEDIDO   | INT     | TRUE     | TRUE   |       | IDENTIFICACIÓN ÚNICA DEL PEDIDO (ORDEN)           |
|      | FECHA       | DATE    | TRUE     |        |       | FECHA DE EJECUCIÓN DE LA ORDEN                    |
|      | COMPLETO    | BOOLEAN | TRUE     |        |       | ESTADO DE LA ORDEN, DEFAULT FALSE                 |


# Funciones

## CrearPedido

Se encarga de crear los pedidos, esta pensada de tal manera a que el cliente (analista de algun departamento) pase por parametros su legajo para poder identificarlo y el nombre del API del estandar que necesita.

La misma verifica que el analista exista validando su legajo, si el mismo no existe corta el proceso, caso contrario hace un insert en la tabla pedido generando la fila correspondiente.

## AgregarStock

Funcion para manejar las odenes y generar el stock correspondiente para cada sector.

La misma pide por parametros los siguientes datos:

* LOTE_STD: Lote del estandar que será destinado para dicha orden.
* ID_ALMACENAMIENTO: Almacenamiento requerido para dicho estandar (condicion de guardado).
* CANT_VIALES: Cantidad de viales destinadas para dicha orden.
* ID_ORDEN: Orden específica del pedido original.

Una vez pasado todos los parametros la misma verifica que la cantidad de viales disponibles del estandar solicitado sea la suficiente para poder crear el stock, si pasa dicha validacion genera el registro en la tabla STOCK.

# Stored Procedures

## sp_InsertCaracterizacionAPI

El mismo de encarga de generar la orden en la tabla CARACTERIZACION_API, una vez que se dispara el Trigger trg_AfterInsertPedido.

De esta manera, las ordenes con su correspondiente ID_ORDEN se generan automaticamente una vez generado el registro del PEDIDO.

## sp_CompletarOrden

Procedimiento que se dispara a travez de un trigger cada vez que se genera un nuevo registro en la tabla STOCL, el cual a travez de ID_ORDEN verifica que la orde haya sido completada y actualiza la columna "COMPLETO" a TRUE. 

## sp_PedidosProximosAVencer

Se encarga de monitorear proximos vencimientos en los pedidos realizados, su funcionalidad es verificar que se puedan complar dichos pedidos.