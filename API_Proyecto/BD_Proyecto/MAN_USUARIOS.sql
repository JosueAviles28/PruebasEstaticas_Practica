DROP PROCEDURE IF EXISTS MAN_USUARIOS;
GO
/*
	--ESTO ES PARA HACER EL LLAMADO AL PROCEDIMIENTO ALMACENADO
	DECLARE @V VARCHAR(100)
	EXEC MAN_USUARIOS 3, 2, 'CARLOS', 'CARLOS', 'CARLOS@GMAIL.COM', 'CARLOS MIRANDA', 1, 'ADMIN', @V OUTPUT
	SELECT @V

	PROCEDIMIENTO ALMACENADO
	STORE PROCEDURE = SP

*/
GO
CREATE PROCEDURE MAN_USUARIOS
    @PROCESO            TINYINT,
    @UsuarioID          INT = NULL, -- Solo para actualización y eliminación
    @NombreUsuario      VARCHAR(20),
    @Contrasena			VARCHAR(256),
    @CorreoElectronico  VARCHAR(100),
    @NombreCompleto     VARCHAR(100),
    @Activo             INT,		--1 = ACTIVO Y 0 = INACTIVO
    @Rol                VARCHAR(50),
    @RESPUESTA          VARCHAR(200) OUTPUT
WITH ENCRYPTION
AS BEGIN

	DECLARE @NUEVACONTRASENA		VARCHAR(200)
    DECLARE @NUMERROR				TINYINT

    SET NOCOUNT ON
    SET DATEFORMAT DMY

    -- Insertar nuevo usuario
    IF @PROCESO = 1 BEGIN

		--ESTE PROCESO ES PARA ENCRIPTAR LA CONTRASEÑA DE USUARIO
		EXEC SP_ENCRIPTAR @Contrasena, @NUEVACONTRASENA OUTPUT

		INSERT INTO Usuarios 
		(NombreUsuario, ContrasenaHash, CorreoElectronico, NombreCompleto, Activo, Rol, FechaDeCreacion)
        VALUES 
		(@NombreUsuario, @NUEVACONTRASENA, @CorreoElectronico, @NombreCompleto, @Activo, @Rol, GETDATE())

        SET @NUMERROR = @@ERROR
        IF @NUMERROR <> 0 BEGIN
            SET @RESPUESTA = CASE @NUMERROR WHEN 2627 THEN 'DUPLICIDAD DE REGISTRO'
                                            ELSE 'NO SE PUDO INGRESAR REGISTRO : ' + CAST(@NUMERROR AS VARCHAR(10))
                             END
            RETURN
        END ELSE BEGIN

			SELECT 'USUARIO CREADO CORRECTAMENTE'

            SET @RESPUESTA = 'OK'

        END
    END

    -- Actualizar datos del usuario
    IF @PROCESO = 2 AND @UsuarioID IS NOT NULL BEGIN

        UPDATE Usuarios
        SET NombreUsuario = @NombreUsuario,
            ContrasenaHash = @Contrasena,
            CorreoElectronico = @CorreoElectronico,
            NombreCompleto = @NombreCompleto,
            Activo = @Activo,
            Rol = @Rol
        WHERE UsuarioID = @UsuarioID

        SET @NUMERROR = @@ERROR
        IF @NUMERROR <> 0 BEGIN
            SET @RESPUESTA = CASE @NUMERROR WHEN 2627 THEN 'DUPLICIDAD DE REGISTRO'
                                            ELSE 'ERROR AL MODIFICAR REGISTRO : ' + CAST(@NUMERROR AS VARCHAR(10))
                             END
            RETURN
        END ELSE BEGIN

			SELECT 
			NombreUsuario, ContrasenaHash, CorreoElectronico, NombreCompleto, Activo, Rol, FechaDeCreacion 
			FROM Usuarios

            SET @RESPUESTA = 'OK'
        END
    END

    -- Eliminar usuario
    IF @PROCESO = 3 AND @UsuarioID IS NOT NULL BEGIN

        DELETE FROM Usuarios WHERE UsuarioID = @UsuarioID

        SET @NUMERROR = @@ERROR
        IF @NUMERROR <> 0 BEGIN
            SET @RESPUESTA = CASE @NUMERROR WHEN 2627 THEN 'DUPLICIDAD DE REGISTRO'
                                            ELSE 'ERROR AL ELIMINAR REGISTRO : ' + CAST(@NUMERROR AS VARCHAR(10))
                             END
            RETURN
        END ELSE BEGIN
			SELECT 'USUARIO BORRADO EXITOSAMENTE'  AS MENSAJE
            SET @RESPUESTA = 'OK'
        END
    END

    -- Consultar usuario (por ID o NombreUsuario)
    IF @PROCESO = 90 BEGIN

        SELECT 
			UsuarioID, 
			NombreUsuario, 
			ContrasenaHash, 
			CorreoElectronico, 
			NombreCompleto, 
			Activo, 
			Rol, 
			FechaDeCreacion, 
			CASE WHEN UltimoAcceso IS NULL THEN FechaDeCreacion ELSE UltimoAcceso END AS UltimoAcceso
		FROM Usuarios
		--WHERE (UsuarioID = @UsuarioID OR @UsuarioID = '')

        SET @RESPUESTA = 'OK'

    END


END
GO
