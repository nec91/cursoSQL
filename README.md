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

| PK   | COLUMN      | TYPE    | NOT NULL | UNIQUE | LEN | NOTES                        |
|------|-------------|---------|----------|--------|-----|------------------------------|
| TRUE | ID_API      | VARCHAR | TRUE     | TRUE   | 20  | LOTE INTERNO API              |
|      | NOMBRE      | VARCHAR | TRUE     |        | 50  | NOMBRE DEL API               |
|      | LOTE_MP     | VARCHAR | TRUE     |        | 20  | LOTE ORIGEN                  |
|      | TITULO      | DEC     | TRUE     |        |(5,2)| TITULO EN (SDTC) %           |
|      | VENCIMIENTO | DATE    | TRUE     |        |     | VENCIMIENTO PROVEEDOR         |
|      | PROVEEDOR   | VARCHAR | TRUE     |        | 50  | NOMBRE DE PROVEEDOR           |
|      | ORIGEN      | VARCHAR |          |        | 50  | PAÍS DE ORIGEN               |

## Tabla ESTANDAR
Contiene información de los estándares primarios o secundarios.

| PK   | COLUMN         | TYPE    | NOT NULL | UNIQUE | LEN | NOTES                                                |
|------|----------------|---------|----------|--------|-----|------------------------------------------------------|
| TRUE | LOTE_STD       | VARCHAR | TRUE     | TRUE   | 20  | LOTE DEL ESTÁNDAR                                    |
| FK   | ID_API         | VARCHAR |          |        | 20  | LOTE INTERNO DEL API PARA GENERACIÓN (APLICA SECUNDARIOS) |
|      | PRESENTACION   | INT     | TRUE     |        |     | PRESENTACIÓN DE VIALES (mg)                          |
|      | TITULO         | DEC     | TRUE     |        |(5,2)| TITULO EN (SDTC) %                                   |
|      | VENCIMIENTO    | DATE    | TRUE     |        |     | VENCIMIENTO INTERNO                                  |
|      | RENALISIS      | DATE    | TRUE     |        |     | REANÁLISIS INTERNO                                   |
|      | OBSERVACIONES  | VARCHAR |          |        | 250  | DESCRIPCIÓN GENERAL DEL ESTÁNDAR                     |
|      | CATEGORIA      | VARCHAR | TRUE     |        | 10  | PRIMARIO/SECUNDARIO/WORKING                          |
|      | CANT_VIAL_TOTAL| INT     | TRUE     |        |     | CANTIDAD DE VIALES GENERADOS/COMPRADOS               |

## Tabla STOCK
Contiene información del stock correspondiente a cada departamento.

| PK   | COLUMN      | TYPE    | NOT NULL | UNIQUE | LEN | NOTES                                             |
|------|-------------|---------|----------|--------|-----|---------------------------------------------------|
| TRUE | ID_STOCK    | VARCHAR | TRUE     | TRUE   | 50  | ID STOCK CORRESPONDIENTE A CADA DEPARTAMENTO      |
| FK   | LOTE_STD    | VARCHAR | TRUE     | TRUE   | 20  | LOTE DEL ESTÁNDAR                                 |
|      | CANT_VIALES | INT     | TRUE     |        |     | CANTIDAD DE VIALES QUE POSEE CADA DEPARTAMENTO    |
| FK   | ID_ORDEN    | INT     | TRUE     | TRUE   |     | ID QUE DERIBA EL ESTÁNDAR AL STOCK CORRESPONDIENTE|

## Tabla DEPARTAMENTO
Contiene la descripción del departamento.

| PK   | COLUMN  | TYPE    | NOT NULL | UNIQUE | LEN | NOTES                               |
|------|---------|---------|----------|--------|-----|-------------------------------------|
| TRUE | ID_DEP  | VARCHAR | TRUE     | TRUE   | 5   | CÓDIGO INTERNO DE LOS DEPARTAMENTOS |
|      | NOMBRE  | VARCHAR | TRUE     | TRUE   | 20  | NOMBRE DETALLADO DEL DEPARTAMENTO   |

## Tabla ANALISTA
Contiene información de los analistas.

| PK   | COLUMN          | TYPE    | NOT NULL | UNIQUE | LEN | NOTES                               |
|------|-----------------|---------|----------|--------|-----|-------------------------------------|
| TRUE | LEGAJO_ANALISTA  | INT     | TRUE     | TRUE   |     | LEGAJO DE LOS ANALISTAS             |
| FK   | ID_DEP          | VARCHAR | TRUE     | TRUE   | 5   | CÓDIGO INTERNO DE LOS DEPARTAMENTOS |
|      | NOMBRE          | VARCHAR | TRUE     |        | 30  | NOMBRE DEL ANALISTA                 |
|      | APELLIDO        | VARCHAR | TRUE     |        | 30  | APELLIDO DEL ANALISTA               |
|      | DNI             | INT     | TRUE     | TRUE   |     | DOCUMENTO DE IDENTIDAD DEL ANALISTA |

## Tabla PEDIDO
Contiene información sobre los pedidos de estándares realizados por analistas de diferentes sectores.

| PK   | COLUMN          | TYPE    | NOT NULL | UNIQUE | LEN | NOTES                               |
|------|-----------------|---------|----------|--------|-----|-------------------------------------|
| TRUE | ID_PEDIDO        | INT     | TRUE     | TRUE   |     | IDENTIFICACIÓN ÚNICA DEL PEDIDO (ORDEN) |
| FK   | LEGAJO_ANALISTA  | INT     | TRUE     | TRUE   |     | LEGAJO DE LOS ANALISTAS             |
|      | FECHA           | DATE    | TRUE     |        |     | FECHA DE SOLICITUD DEL PEDIDO       |
|      | NOMBRE_API      | VARCHAR | TRUE     |        | 50  | API DEL ESTÁNDAR SOLICITADO         |

## Tabla CARACTERIZACION_API
Contiene información sobre el manejo de pedidos.

| PK   | COLUMN      | TYPE    | NOT NULL | UNIQUE | LEN | NOTES                                             |
|------|-------------|---------|----------|--------|-----|---------------------------------------------------|
| TRUE | ID_ORDEN    | INT     | TRUE     | TRUE   |     | ID QUE DERIBA EL ESTÁNDAR AL STOCK CORRESPONDIENTE|
| FK   | ID_PEDIDO   | INT     | TRUE     | TRUE   |     | IDENTIFICACIÓN ÚNICA DEL PEDIDO (ORDEN)           |
|      | FECHA       | DATE    | TRUE     |        |     | FECHA DE EJECUCIÓN DE LA ORDEN                    |
|      | COMPLETO    | BOOLEAN | TRUE     |        |     | ESTADO DE LA ORDEN, DEFAULT FALSE                 |
