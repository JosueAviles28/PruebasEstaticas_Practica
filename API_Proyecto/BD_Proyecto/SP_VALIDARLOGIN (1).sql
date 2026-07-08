DROP PROCEDURE IF EXISTS SP_VALIDARLOGIN
GO
/*

	DECLARE @V VARCHAR(200)
	EXEC SP_VALIDARLOGIN 'charly', 'abc123', @V OUTPUT
	SELECT @V

*/
GO
CREATE PROCEDURE SP_VALIDARLOGIN
    @Usuario      VARCHAR(20),
    @Password     VARCHAR(256), -- Asume que el hash de la contraseña se genera en la aplicación cliente
	@RESPUESTA    VARCHAR(200) OUTPUT
--WITH ENCRYPTION
AS BEGIN
    SET NOCOUNT ON

    -- Inicializar valores de salida
    DECLARE @UsuarioID							INT
    DECLARE @PasswordHashAlmacenada				VARCHAR(MAX)
    DECLARE @PasswordHashIngresada				VARBINARY(64)
    DECLARE @NombreUsuario		                NVARCHAR(100)
    DECLARE @ApellidoUsuario	                NVARCHAR(100)
    DECLARE @Email				                NVARCHAR(100)
    DECLARE @Role				                NVARCHAR(50)

	--VALIDANDO QUE EL USUARIO EXISTA EN LA BASE DE DATOS
    SELECT 
        @UsuarioID = UsuarioID,
        @NombreUsuario = NombreUsuario,
		@PasswordHashAlmacenada = ContrasenaHash,
        @Role = Rol
    FROM Usuarios
    WHERE NombreUsuario = @Usuario
	  
    -- Calculamos el hash de la contraseña ingresada
    SET @PasswordHashIngresada = HASHBYTES('SHA2_256', @Password)
	 
	--AUTENTICAR LA CONTRASEÑA
	--IF @PasswordHashAlmacenada <> @PasswordHashIngresada BEGIN
	--	SELECT 'USUARIO O CONTRASEÑA INVALIDOS'
	--	RETURN
	--END

    IF @UsuarioID IS NOT NULL
    BEGIN

        -- Actualizar fecha de logeo
        UPDATE Usuarios
        SET UltimoAcceso = GETDATE()
        WHERE UsuarioID = @UsuarioID

        -- Devolver información del usuario
        SELECT 
            UsuarioID,
            NombreUsuario,
            NombreCompleto,
            CorreoElectronico,
            Rol
        FROM Usuarios
        WHERE UsuarioID = @UsuarioID

		SET @RESPUESTA = 'Acceso concedido' 
    END 
	ELSE BEGIN
        SET @RESPUESTA = 'Acceso denegado'
    END

END
GO
