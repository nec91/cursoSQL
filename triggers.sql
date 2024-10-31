USE standard_db

-- Trigger que llama al store procedure "InsertCaracterizacionAPI", cada vez que se genera un pedido nuevo

DELIMITER //

CREATE TRIGGER AfterInsertPedido
AFTER INSERT ON PEDIDO
FOR EACH ROW
BEGIN
    CALL InsertCaracterizacionAPI(NEW.ID_PEDIDO, NEW.FECHA);
END //

DELIMITER ;

