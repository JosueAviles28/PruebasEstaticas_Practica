DROP PROCEDURE IF EXISTS MAN_PERSONAL;
GO

CREATE PROCEDURE MAN_PERSONAL
    @PROCESO            TINYINT,
    @PersonalID         INT = NULL, -- Se usa para operaciones de actualización y eliminación
    @Nombre             VARCHAR(100),
    @Apellido           VARCHAR(100),
    @Rol                VARCHAR(100),
    @Telefono           VARCHAR(20),
    @CorreoElectronico  VARCHAR(255),
    @RESPUESTA          VARCHAR(200) OUTPUT

AS BEGIN
    DECLARE @NUMERROR AS TINYINT

    SET NOCOUNT ON
    SET DATEFORMAT DMY

    IF @PROCESO = 1 BEGIN
        INSERT INTO Personal (Nombre, Apellido, Rol, Telefono, CorreoElectronico)
        VALUES (@Nombre, @Apellido, @Rol, @Telefono, @CorreoElectronico)

        SET @NUMERROR = @@ERROR
        IF @NUMERROR <> 0 BEGIN
            SET @RESPUESTA = CASE @NUMERROR WHEN 2627 THEN 'DUPLICIDAD DE REGISTRO'
                                            ELSE 'NO SE PUDO INGRESAR REGISTRO : ' + CAST(@NUMERROR AS VARCHAR(10))
                             END
            RETURN
        END ELSE BEGIN
            SET @RESPUESTA = 'OK'
        END
    END

    IF @PROCESO = 2 BEGIN
        UPDATE Personal
        SET Nombre = @Nombre,
            Apellido = @Apellido,
            Rol = @Rol,
            Telefono = @Telefono,
            CorreoElectronico = @CorreoElectronico
        WHERE PersonalID = @PersonalID

        SET @NUMERROR = @@ERROR
        IF @NUMERROR <> 0 BEGIN
            SET @RESPUESTA = CASE @NUMERROR WHEN 2627 THEN 'DUPLICIDAD DE REGISTRO'
                                            ELSE 'ERROR AL MODIFICAR REGISTRO : ' + CAST(@NUMERROR AS VARCHAR(10))
                             END
            RETURN
        END ELSE BEGIN
            SET @RESPUESTA = 'OK'
        END
    END

    IF @PROCESO = 3 BEGIN
        DELETE FROM Personal WHERE PersonalID = @PersonalID

        SET @NUMERROR = @@ERROR
        IF @NUMERROR <> 0 BEGIN
            SET @RESPUESTA = CASE @NUMERROR WHEN 2627 THEN 'DUPLICIDAD DE REGISTRO'
                                            ELSE 'ERROR AL ELIMINAR REGISTRO : ' + CAST(@NUMERROR AS VARCHAR(10))
                             END
            RETURN
        END ELSE BEGIN
            SET @RESPUESTA = 'OK'
        END
    END

    IF @PROCESO = 90 BEGIN
        SELECT * FROM Personal WHERE PersonalID = ISNULL(@PersonalID, PersonalID)
        SET @RESPUESTA = 'OK'
    END
END
GO
