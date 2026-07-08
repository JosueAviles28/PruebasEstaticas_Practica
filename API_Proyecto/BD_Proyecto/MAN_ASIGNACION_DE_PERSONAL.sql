DROP PROCEDURE IF EXISTS MAN_ASIGNACION_DE_PERSONAL;
GO

CREATE PROCEDURE MAN_ASIGNACION_DE_PERSONAL
    @PROCESO                TINYINT,
    @AsignacionID           INT = NULL, -- Se usa para operaciones de actualización y eliminación
    @PersonalID             INT,
    @ProyectoID             INT,
    @FechaDeAsignacion      DATE,
    @FechaDeFinDeAsignacion DATE,
    @DescripcionDelTrabajo  VARCHAR(255),
    @RESPUESTA              VARCHAR(200) OUTPUT

AS BEGIN
    DECLARE @NUMERROR AS TINYINT

    SET NOCOUNT ON
    SET DATEFORMAT DMY

    IF @PROCESO = 1 BEGIN
        INSERT INTO AsignacionDePersonal 
		(PersonalID, ProyectoID, FechaDeAsignacion, FechaDeFinDeAsignacion, DescripcionDelTrabajo)
        VALUES (@PersonalID, @ProyectoID, @FechaDeAsignacion, @FechaDeFinDeAsignacion, @DescripcionDelTrabajo)

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

        UPDATE AsignacionDePersonal
        SET PersonalID = @PersonalID,
            ProyectoID = @ProyectoID,
            FechaDeAsignacion = @FechaDeAsignacion,
            FechaDeFinDeAsignacion = @FechaDeFinDeAsignacion,
            DescripcionDelTrabajo = @DescripcionDelTrabajo
        WHERE AsignacionID = @AsignacionID

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
        DELETE FROM AsignacionDePersonal WHERE AsignacionID = @AsignacionID

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
        SELECT * FROM AsignacionDePersonal 
        SET @RESPUESTA = 'OK'
    END
END
GO
