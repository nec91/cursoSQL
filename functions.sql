USE standard_db;

DROP FUNCTION IF EXISTS ActualizarCompleto;


-- Funcion para actualizar el estado ("COMPLETO") de la orden en "caracterizacion_api" pasando como parametro "ID_ORDEN"

DELIMITER //

CREATE FUNCTION ActualizarCompleto(p_id_orden INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE resultado BOOLEAN;

    -- Verificar si existe la orden y si esta incompleta
    SELECT COMPLETO INTO resultado 
    FROM CARACTERIZACION_API 
    WHERE ID_ORDEN = p_id_orden;

    -- Si la orden esta completa (FALSE), actualizarlo a TRUE
    IF resultado = FALSE THEN
        UPDATE CARACTERIZACION_API
        SET COMPLETO = TRUE
        WHERE ID_ORDEN = p_id_orden;
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END //

DELIMITER ;