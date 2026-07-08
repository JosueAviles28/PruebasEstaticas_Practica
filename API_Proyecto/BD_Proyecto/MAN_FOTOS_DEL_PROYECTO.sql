DROP PROCEDURE IF EXISTS MAN_FOTOS_DEL_PROYECTO;
GO

CREATE PROCEDURE MAN_FOTOS_DEL_PROYECTO
    @PROCESO           INT,
    @FotoID            INT = NULL, -- Se usa para operaciones de actualización y eliminación
    @ProyectoID        INT,
    @URLDeLaFoto       VARCHAR(255),
    @Descripcion       VARCHAR(255),
    @FechaDeLaFoto     VARCHAR(10),
    @RESPUESTA         VARCHAR(200) OUTPUT

AS BEGIN
    DECLARE @NUMERROR AS TINYINT

    SET NOCOUNT ON
    SET DATEFORMAT DMY

    IF @PROCESO = 1 BEGIN
        INSERT INTO FotosDelProyecto (ProyectoID, URLDeLaFoto, Descripcion, FechaDeLaFoto)
        VALUES (@ProyectoID, @URLDeLaFoto, @Descripcion, @FechaDeLaFoto)

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
        UPDATE FotosDelProyecto
        SET ProyectoID = @ProyectoID,
            URLDeLaFoto = @URLDeLaFoto,
            Descripcion = @Descripcion,
            FechaDeLaFoto = @FechaDeLaFoto
        WHERE FotoID = @FotoID

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
        DELETE FROM FotosDelProyecto WHERE FotoID = @FotoID

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
        SELECT FotoID, ProyectoID, URLDeLaFoto, Descripcion, FechaDeLaFoto FROM FotosDelProyecto  
        SET @RESPUESTA = 'OK'
    END
END
GO
