USE standard_db;

DROP view IF EXISTS detalle_ordenes;
DROP view IF EXISTS ordenes_pendientes;
DROP view IF EXISTS ordenes_completas;

-- Vista que detalla estado de la orden y por quien fue solicitada.

CREATE OR REPLACE VIEW detalle_ordenes AS
SELECT 
    c.ID_ORDEN,
    p.NOMBRE_API,        
    a.NOMBRE,           
    a.APELLIDO,
	p.LEGAJO_ANALISTA,    
    c.Completo AS Estado_Orden
FROM 
    CARACTERIZACION_API c
JOIN 
    PEDIDO p ON c.ID_PEDIDO = p.ID_PEDIDO  
JOIN 
    ANALISTA a ON p.LEGAJO_ANALISTA = a.LEGAJO_ANALISTA;  

-- Vista que detalla ordenes pendientes

CREATE OR REPLACE VIEW ordenes_pendientes AS
SELECT 
    p.NOMBRE_API,          
    c.ID_ORDEN,           
    c.Completo AS Estado_Orden
FROM 
    CARACTERIZACION_API c
JOIN 
    PEDIDO p ON c.ID_PEDIDO = p.ID_PEDIDO
WHERE 
    c.Completo = FALSE;
    
    -- Vista que detalla ordenes completas

CREATE OR REPLACE VIEW ordenes_completas AS
SELECT 
    p.NOMBRE_API,          
    c.ID_ORDEN,           
    c.Completo AS Estado_Orden
FROM 
    CARACTERIZACION_API c
JOIN 
    PEDIDO p ON c.ID_PEDIDO = p.ID_PEDIDO
WHERE 
    c.Completo = TRUE;