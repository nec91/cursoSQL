USE standard_db;

DROP view IF EXISTS detalle_ordenes;
DROP view IF EXISTS ordenes_pendientes;
DROP view IF EXISTS ordenes_completas;

-- Vista que detalla estado de la orden y por quien fue solicitada.

CREATE OR REPLACE VIEW view_detalle_ordenes AS
SELECT 
    c.ID_ORDEN,
    p.NOMBRE_API,        
    a.NOMBRE,       
    a.APELLIDO,
	p.LEGAJO_ANALISTA,
    d.NOMBRE AS Departamento,
    CASE
		WHEN c.Completo = 1 THEN "Completo"
        WHEN c.Completo = 0 THEN "Pendiente"
	END AS Estado_Orden
FROM 
    CARACTERIZACION_API c
JOIN 
    PEDIDO p ON c.ID_PEDIDO = p.ID_PEDIDO  
JOIN 
    ANALISTA a ON p.LEGAJO_ANALISTA = a.LEGAJO_ANALISTA
JOIN
	DEPARTAMENTO d ON a.ID_DEP = d.ID_DEP;  
   
-- Listado de estandares con codigo, nombre y cantidad de viales
    CREATE OR REPLACE VIEW view_estandares_disponibles AS
SELECT 
    a.ID_API,          
    a.NOMBRE,           
    e.LOTE_STD,
	e.PRESENTACION,
	e.CANT_VIAL_TOTAL,
    e.VENCIMIENTO,
    e.REANALISIS
    
FROM 
    API a
JOIN 
    ESTANDAR e ON a.ID_API = e.ID_API;
    
    -- Listado de estandares asignados a un stock
CREATE OR REPLACE VIEW view_stock_estandar AS
SELECT 
    s.ID_STOCK,
    api.NOMBRE AS NOMBRE_ESTANDAR,
    s.LOTE_STD,
	e.TITULO AS 'Titulo (% sdtc)',
    e.PRESENTACION AS 'mg/vial',
    s.CANT_VIALES AS Vaiales,
	a.DESCRIPCION_ALM AS 'Condicion de almacenamiento',
    e.VENCIMIENTO,
    e.REANALISIS,
    d.NOMBRE AS DEPARTAMENTO,
	s.ID_ORDEN
FROM 
    STOCK s
INNER JOIN 
    ESTANDAR e ON s.LOTE_STD = e.LOTE_STD
INNER JOIN 
    API api ON e.ID_API = api.ID_API
INNER JOIN 
    ALMACENAMIENTO a ON s.ID_ALMACENAMIENTO = a.ID_ALMACENAMIENTO
INNER JOIN 
    CARACTERIZACION_API ca ON s.ID_ORDEN = ca.ID_ORDEN
INNER JOIN 
    PEDIDO p ON ca.ID_PEDIDO = p.ID_PEDIDO
INNER JOIN 
    ANALISTA an ON p.LEGAJO_ANALISTA = an.LEGAJO_ANALISTA
INNER JOIN 
    DEPARTAMENTO d ON an.ID_DEP = d.ID_DEP;
    
    
    -- Muestra los estandares proximos a vencer en los proximos 30 dias
    CREATE OR REPLACE VIEW view_estandares_proximos_vencer AS
SELECT 
    LOTE_STD,
    ID_API,
    PRESENTACION,
    TITULO,
    VENCIMIENTO,
    DATEDIFF(VENCIMIENTO, CURDATE()) AS DiasParaVencimiento,
    CANT_VIAL_TOTAL
FROM 
    ESTANDAR
WHERE 
    VENCIMIENTO <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) -- Próximos 30 días
    AND VENCIMIENTO >= CURDATE() -- Asegurar que no estén vencidos
ORDER BY 
    VENCIMIENTO ASC;
    
    -- Muestra estandares agotados
    
    CREATE OR REPLACE VIEW view_estandares_sin_viales AS
SELECT 
    LOTE_STD,
    ID_API,
    PRESENTACION,
    TITULO,
    VENCIMIENTO,
    CANT_VIAL_TOTAL,
    REANALISIS,
    OBSERVACIONES
FROM 
    ESTANDAR
WHERE 
    CANT_VIAL_TOTAL = 0
ORDER BY 
    VENCIMIENTO ASC;