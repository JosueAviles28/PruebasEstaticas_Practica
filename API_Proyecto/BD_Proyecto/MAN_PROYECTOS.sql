DROP PROCEDURE IF EXISTS MAN_PROYECTOS;
GO

CREATE PROCEDURE MAN_PROYECTOS
    @PROCESO               TINYINT,
    @ProyectoID            INT = NULL, -- Se usa para operaciones de actualización y eliminación
    @NombreDelProyecto     VARCHAR(100),
    @Descripcion           VARCHAR(150),
    @FechaDeInicio         VARCHAR(10),
    @FechaDeFinalizacion   VARCHAR(10),
    @ClienteID             INT,
    @Estado                VARCHAR(50),
    @OPERADOR              INT,
    @RESPUESTA             VARCHAR(200) OUTPUT

AS BEGIN
    DECLARE @NUMERROR AS TINYINT

    SET NOCOUNT ON
    SET DATEFORMAT DMY

    IF @PROCESO = 1 BEGIN

        INSERT INTO Proyectos 
		(NombreDelProyecto, Descripcion, FechaDeInicio, FechaDeFinalizacion, ClienteID, Estado, UsuarioID)
        VALUES (@NombreDelProyecto, @Descripcion, @FechaDeInicio, @FechaDeFinalizacion, @ClienteID, @Estado, @OPERADOR)

        SET @NUMERROR = @@ERROR
        IF @NUMERROR <> 0 BEGIN
            SET @RESPUESTA = CASE @NUMERROR WHEN 2627 THEN 'DUPLICIDAD DE REGISTRO'
                                            ELSE 'NO SE PUDO INGRESAR REGISTRO : ' + CAST(@NUMERROR AS VARCHAR(10))
                             END
            RETURN
        END ELSE BEGIN
			SELECT 'PROYECTO CREADO EXITOSAMENTE'  AS MENSAJE
            SET @RESPUESTA = 'OK'
        END
    END

    IF @PROCESO = 2 BEGIN
        UPDATE Proyectos
        SET NombreDelProyecto = @NombreDelProyecto,
            Descripcion = @Descripcion,
            FechaDeInicio = @FechaDeInicio,
            FechaDeFinalizacion = @FechaDeFinalizacion,
            ClienteID = @ClienteID,
            Estado = @Estado, 
			UsuarioID = @OPERADOR
        WHERE ProyectoID = @ProyectoID

        SET @NUMERROR = @@ERROR
        IF @NUMERROR <> 0 BEGIN
            SET @RESPUESTA = CASE @NUMERROR WHEN 2627 THEN 'DUPLICIDAD DE REGISTRO'
                                            ELSE 'ERROR AL MODIFICAR REGISTRO : ' + CAST(@NUMERROR AS VARCHAR(10))
                             END
            RETURN
        END ELSE BEGIN
			SELECT 'PROYECTO ACTUALIZADO EXITOSAMENTE'  AS MENSAJE
            SET @RESPUESTA = 'OK'
        END
    END

    IF @PROCESO = 3 BEGIN
        DELETE FROM Proyectos WHERE ProyectoID = @ProyectoID

        SET @NUMERROR = @@ERROR
        IF @NUMERROR <> 0 BEGIN
            SET @RESPUESTA = CASE @NUMERROR WHEN 2627 THEN 'DUPLICIDAD DE REGISTRO'
                                            ELSE 'ERROR AL ELIMINAR REGISTRO : ' + CAST(@NUMERROR AS VARCHAR(10))
                             END
            RETURN
        END ELSE BEGIN
			SELECT 'PROYECTO BORRADO EXITOSAMENTE'  AS MENSAJE	
            SET @RESPUESTA = 'OK'
        END
    END

    IF @PROCESO = 90 BEGIN
        SELECT ProyectoID, NombreDelProyecto, Descripcion, FechaDeInicio, FechaDeFinalizacion, ClienteID, Estado, UsuarioID 
		FROM Proyectos 
        SET @RESPUESTA = 'OK'
    END

	IF @PROCESO = 91 BEGIN
        SELECT ProyectoID, NombreDelProyecto, Descripcion, FechaDeInicio, FechaDeFinalizacion, ClienteID, Estado, UsuarioID 
		FROM Proyectos 
		WHERE 
		ProyectoID = @ProyectoID

        SET @RESPUESTA = 'OK'
    END

	IF @PROCESO = 92 BEGIN

        SELECT ProyectoID, NombreDelProyecto, Descripcion, FechaDeInicio, FechaDeFinalizacion, ClienteID, Estado, UsuarioID 
		FROM Proyectos 
		WHERE 
		NombreDelProyecto like'%' + @NombreDelProyecto + '%' OR @NombreDelProyecto = ''

        SET @RESPUESTA = 'OK'
    END
END
GO
