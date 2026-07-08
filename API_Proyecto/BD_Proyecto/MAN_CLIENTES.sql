DROP PROCEDURE IF EXISTS MAN_CLIENTES;
GO

CREATE PROCEDURE MAN_CLIENTES
    @PROCESO            INT,
    @ClienteID          INT, -- Se usa para operaciones de actualización y eliminación
    @Nombre             VARCHAR(100),
    @Apellido           VARCHAR(100),
    @CorreoElectronico  VARCHAR(50),
    @Telefono           VARCHAR(20),
    @Direccion          VARCHAR(100),
    @RESPUESTA          VARCHAR(200) OUTPUT
AS BEGIN
    DECLARE @NUMERROR AS TINYINT

    SET NOCOUNT ON
    SET DATEFORMAT DMY

    IF @PROCESO = 1 BEGIN
        --LA VALIDACION DE ESE CAMPO

        INSERT INTO Clientes 
		(Nombre, Apellido, CorreoElectronico, Telefono, Direccion)
        VALUES 
		(@Nombre, @Apellido, @CorreoElectronico, @Telefono, @Direccion)

        SET @NUMERROR = @@ERROR
        IF @NUMERROR <> 0 BEGIN
            SET @RESPUESTA = CASE @NUMERROR WHEN 2627 THEN 'DUPLICIDAD DE REGISTRO'
                                            ELSE 'NO SE PUDO INGRESAR REGISTRO : ' + CAST(@NUMERROR AS VARCHAR(10))
                             END
            RETURN
        END ELSE BEGIN
			SELECT * FROM Clientes
            SET @RESPUESTA = 'OK'
        END
    END

    IF @PROCESO = 2 BEGIN

        UPDATE Clientes
        SET 
			Nombre = @Nombre,
            Apellido = @Apellido,
            CorreoElectronico = @CorreoElectronico,
            Telefono = @Telefono,
            Direccion = @Direccion
        WHERE ClienteID = @ClienteID

        SET @NUMERROR = @@ERROR
        IF @NUMERROR <> 0 BEGIN
            SET @RESPUESTA = CASE @NUMERROR WHEN 2627 THEN 'DUPLICIDAD DE REGISTRO'
                                            ELSE 'ERROR AL MODIFICAR REGISTRO : ' + CAST(@NUMERROR AS VARCHAR(10))
                             END
            RETURN
        END ELSE BEGIN
			SELECT ClienteID, Nombre, Apellido, CorreoElectronico, Telefono, Direccion FROM Clientes  
            SET @RESPUESTA = 'OK'
        END
    END

    IF @PROCESO = 3 BEGIN

        DELETE FROM Clientes 
		WHERE ClienteID = @ClienteID

        SET @NUMERROR = @@ERROR
        IF @NUMERROR <> 0 BEGIN
            SET @RESPUESTA = CASE @NUMERROR WHEN 2627 THEN 'DUPLICIDAD DE REGISTRO'
                                            ELSE 'ERROR AL ELIMINAR REGISTRO : ' + CAST(@NUMERROR AS VARCHAR(10))
                             END
            RETURN
        END ELSE BEGIN
			SELECT 'CLIENTE BORRADO EXITOSAMENTE'  AS MENSAJE
            SET @RESPUESTA = 'OK'
        END
    END

    IF @PROCESO = 90 BEGIN
        SELECT ClienteID, UPPER(Nombre) AS Nombre, Apellido, CorreoElectronico, Telefono, Direccion FROM Clientes  
        SET @RESPUESTA = 'OK'
    END

    IF @PROCESO = 91 BEGIN 

        SELECT ClienteID, UPPER(Nombre) AS Nombre, Apellido, CorreoElectronico, Telefono, Direccion FROM Clientes  
        WHERE 
        ClienteID = @ClienteID

        SET @RESPUESTA = 'OK'

    END

    IF @PROCESO = 92 BEGIN 

        SELECT ClienteID, UPPER(Nombre) AS Nombre, Apellido, CorreoElectronico, Telefono, Direccion FROM Clientes  
        WHERE 
        Nombre + Apellido like'%'+ @Nombre + '%'

        SET @RESPUESTA = 'OK'

    END

END
GO
