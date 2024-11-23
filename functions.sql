-- Funcion para ejecutar el pedido generado y actualizar la tabla Stock

DELIMITER //

CREATE FUNCTION `AgregarStock`(
    p_lote_std VARCHAR(20),
    p_id_almacenamiento VARCHAR(5),
    p_cant_viales INT,
    p_id_orden INT
) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE v_id_stock INT;

    -- Insertar el nuevo registro en la tabla STOCK
    INSERT INTO STOCK (LOTE_STD, ID_ALMACENAMIENTO, CANT_VIALES, ID_ORDEN)
    VALUES (p_lote_std, p_id_almacenamiento, p_cant_viales, p_id_orden);

    -- Obtener el ID_STOCK generado automáticamente
    SET v_id_stock = LAST_INSERT_ID();

    -- Retornar el ID_STOCK generado
    RETURN v_id_stock;
END

DELIMITER ;

-- Funcion para generar un pedido

DELIMITER //
CREATE FUNCTION `CrearPedido`(
    p_legajo_analista INT,
    p_nombre_api VARCHAR(50)
) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE v_id_pedido INT;
    DECLARE v_id_dep VARCHAR(5);

    -- Verificar si el analista existe
    SELECT ID_DEP INTO v_id_dep
    FROM ANALISTA
    WHERE LEGAJO_ANALISTA = p_legajo_analista;

    IF v_id_dep IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El legajo del analista no es válido';
    END IF;

    -- Insertar el pedido
    INSERT INTO PEDIDO (LEGAJO_ANALISTA, FECHA, NOMBRE_API)
    VALUES (p_legajo_analista, CURDATE(), p_nombre_api);

    -- Obtener el ID del pedido recién creado
    SET v_id_pedido = LAST_INSERT_ID();

    RETURN v_id_pedido;
END

DELIMITER ;
