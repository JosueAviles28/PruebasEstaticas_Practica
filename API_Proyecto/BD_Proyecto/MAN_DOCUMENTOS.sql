DROP PROCEDURE IF EXISTS MAN_DOCUMENTOS;
GO

CREATE PROCEDURE MAN_DOCUMENTOS
    @PROCESO            TINYINT,
    @DocumentoID        INT = NULL, -- Se usa para operaciones de actualización y eliminación
    @ProyectoID         INT,
    @Tipo               VARCHAR(50),
    @URLDelDocumento    VARCHAR(255),
    @FechaDelDocumento  DATE,
    @RESPUESTA          VARCHAR(200) OUTPUT

AS BEGIN
    DECLARE @NUMERROR AS TINYINT

    SET NOCOUNT ON
    SET DATEFORMAT DMY

    IF @PROCESO = 1 BEGIN
        INSERT INTO Documentos (ProyectoID, Tipo, URLDelDocumento, FechaDelDocumento)
        VALUES (@ProyectoID, @Tipo, @URLDelDocumento, @FechaDelDocumento)

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
        UPDATE Documentos
        SET ProyectoID = @ProyectoID,
            Tipo = @Tipo,
            URLDelDocumento = @URLDelDocumento,
            FechaDelDocumento = @FechaDelDocumento
        WHERE DocumentoID = @DocumentoID

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
        DELETE FROM Documentos WHERE DocumentoID = @DocumentoID

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
        SELECT * FROM Documentos WHERE ProyectoID = ISNULL(@ProyectoID, ProyectoID)
        SET @RESPUESTA = 'OK'
    END
END
GO
