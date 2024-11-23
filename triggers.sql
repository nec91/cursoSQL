USE standard_db

-- Trigger que llama al store procedure "InsertCaracterizacionAPI", cada vez que se genera un pedido nuevo

DELIMITER //

CREATE TRIGGER trg_AfterInsertPedido
AFTER INSERT ON PEDIDO
FOR EACH ROW
BEGIN
    CALL sp_InsertCaracterizacionAPI(NEW.ID_PEDIDO, NEW.FECHA);
END //

DELIMITER ;

-- Trigger para actualizar la cantidad de viales totales relacionados al estandar (tabla estandar)

DELIMITER //

CREATE TRIGGER trg_ActualizarCantVialTotal
AFTER INSERT ON STOCK
FOR EACH ROW
BEGIN
    -- Actualizar CANT_VIAL_TOTAL en la tabla ESTANDAR
    UPDATE ESTANDAR
    SET CANT_VIAL_TOTAL = CANT_VIAL_TOTAL - NEW.CANT_VIALES
    WHERE LOTE_STD = NEW.LOTE_STD;

    -- Verificar que la cantidad no sea negativa
    IF (SELECT CANT_VIAL_TOTAL FROM ESTANDAR WHERE LOTE_STD = NEW.LOTE_STD) < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: La cantidad de viales restante no puede ser negativa.';
    END IF;
END;
//

DELIMITER ;


