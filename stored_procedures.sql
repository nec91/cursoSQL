USE standard_db

-- Store procedure para insertar una orden cada vez que se genera un pedido

DELIMITER //

CREATE PROCEDURE sp_InsertCaracterizacionAPI(
    IN p_id_pedido INT,
    IN p_fecha DATE
)
BEGIN
    INSERT INTO CARACTERIZACION_API (ID_ORDEN, ID_PEDIDO, FECHA)
    VALUES (p_id_pedido, p_fecha);
END //

DELIMITER ;

-- Store procedure para marcar las ordenes como Completo

DELIMITER //

CREATE PROCEDURE sp_CompletarPedido(
    IN p_id_pedido INT
)
BEGIN
    -- Marcar la caracterización como completa
    UPDATE CARACTERIZACION_API
    SET COMPLETO = TRUE
    WHERE ID_PEDIDO = p_id_pedido;

    -- Confirmar el cambio
    SELECT CONCAT('Pedido ', p_id_pedido, ' marcado como completo.') AS Mensaje;
END//

DELIMITER ;

-- Store procedure para monitorear proximos vencimientos en pedidos

DELIMITER //

CREATE PROCEDURE sp_PedidosProximosAVencer(
    IN p_dias INT -- Número de días antes del vencimiento
)
BEGIN
    -- Seleccionar los pedidos con lotes próximos a vencer
    SELECT 
        P.ID_PEDIDO,
        P.NOMBRE_API,
        E.LOTE_STD,
        E.VENCIMIENTO,
        DATEDIFF(E.VENCIMIENTO, CURDATE()) AS Dias_para_vencimiento
    FROM 
        PEDIDO P
    INNER JOIN ESTANDAR E ON P.NOMBRE_API = E.ID_API
    WHERE 
        E.VENCIMIENTO <= DATE_ADD(CURDATE(), INTERVAL p_dias DAY)
        AND E.VENCIMIENTO >= CURDATE()
    ORDER BY 
        E.VENCIMIENTO ASC;
END//

DELIMITER ;



