USE standard_db

-- Store procedure para insertar una orden cada vez que se genera un pedido

DELIMITER //

CREATE PROCEDURE InsertCaracterizacionAPI(
    IN p_id_pedido INT,
    IN p_fecha DATE
)
BEGIN
    INSERT INTO CARACTERIZACION_API (ID_ORDEN, ID_PEDIDO, FECHA)
    VALUES (p_id_pedido, p_fecha);
END //

DELIMITER ;



