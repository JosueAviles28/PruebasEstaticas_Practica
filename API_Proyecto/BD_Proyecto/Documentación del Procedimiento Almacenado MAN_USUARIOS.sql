-- Documentación del Procedimiento Almacenado: MAN_USUARIOS

--# Nombre del Procedimiento:MAN_USUARIOS

--# Descripción:
/*
Este procedimiento almacenado permite gestionar usuarios en el sistema, realizando operaciones de inserción, actualización, eliminación y consulta. 
Las contraseñas se encriptan antes de ser almacenadas. Las operaciones están controladas mediante el parámetro @PROCESO, que determina qué acción se realizará.

--# Parámetros de Entrada:
- @PROCESO (TINYINT) - Obligatorio. Controla la operación que se ejecuta:
  - 1: Inserta un nuevo usuario.
  - 2: Actualiza un usuario existente.
  - 3: Elimina un usuario.
  - 90: Consulta los usuarios.

- @UsuarioID (INT) - Opcional. Se utiliza para la actualización (@PROCESO = 2) y eliminación (@PROCESO = 3). No es necesario para la inserción de un nuevo usuario.

- @NombreUsuario (VARCHAR(20)) - Obligatorio. El nombre del usuario.

- @Contrasena (VARCHAR(256)) - Obligatorio. La contraseña del usuario en texto plano que será encriptada antes de almacenarse.

- @CorreoElectronico (VARCHAR(100)) - Obligatorio. El correo electrónico del usuario.

- @NombreCompleto (VARCHAR(100)) - Obligatorio. El nombre completo del usuario.

- @Activo (INT) - Obligatorio. Define si el usuario está activo (1) o inactivo (0).

- @Rol (VARCHAR(50)) - Obligatorio. El rol asignado al usuario (ej. "ADMIN", "USUARIO").

- @RESPUESTA (VARCHAR(200) OUTPUT) - Parámetro de salida que devuelve el estado de la operación. Si es exitosa, devolverá 'OK', o un mensaje de error en caso de fallos.

--# Comportamiento del Procedimiento:
El procedimiento realiza diferentes operaciones dependiendo del valor del parámetro @PROCESO:

1. Inserción de Usuario (@PROCESO = 1):
   - Inserta un nuevo registro en la tabla Usuarios con los datos proporcionados. La contraseña es encriptada usando el procedimiento almacenado SP_ENCRIPTAR.
   - Si ocurre un error, como la duplicación de registros (nombre de usuario o correo electrónico repetido), devuelve un mensaje de error en @RESPUESTA.
   - Si la inserción es exitosa, devuelve 'OK' en @RESPUESTA.

2. Actualización de Usuario (@PROCESO = 2):
   - Actualiza los detalles de un usuario existente basado en @UsuarioID. Incluye campos como el nombre, contraseña, correo electrónico, y rol.
   - Si ocurre un error, como duplicación de registros, devuelve un mensaje de error en @RESPUESTA.
   - Si la actualización es exitosa, devuelve el registro actualizado del usuario y 'OK' en @RESPUESTA.

3. Eliminación de Usuario (@PROCESO = 3):
   - Elimina un usuario existente basándose en @UsuarioID.
   - Si ocurre un error, devuelve un mensaje de error en @RESPUESTA.
   - Si la eliminación es exitosa, devuelve 'OK' en @RESPUESTA.

4. Consulta de Usuarios (@PROCESO = 90):
   - Consulta todos los usuarios en la tabla Usuarios. Devuelve campos como el nombre, correo, rol y fecha de creación, además de la fecha del último acceso, si disponible.
   - Si la consulta es exitosa, @RESPUESTA contiene 'OK'.
*/
--# Ejemplo de Uso:

--1. Inserción de un nuevo usuario:
   
DECLARE @RESPUESTA VARCHAR(200)
EXEC MAN_USUARIOS @PROCESO = 1, @UsuarioID = NULL, 
                    @NombreUsuario = 'charly', 
                    @Contrasena = 'abc123', 
                    @CorreoElectronico = 'charly@gmail.com', 
                    @NombreCompleto = 'charly quispe', 
                    @Activo = 1, 
                    @Rol = 'ADMIN', 
                    @RESPUESTA = @RESPUESTA OUTPUT


--2. Actualización de un usuario existente:
   
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_USUARIOS @PROCESO = 2, @UsuarioID = 2, 
                     @NombreUsuario = 'CarlosModificado', 
                     @Contrasena = 'NuevaContrasenaSegura', 
                     @CorreoElectronico = 'carlosmodificado@gmail.com', 
                     @NombreCompleto = 'Carlos Miranda Modificado', 
                     @Activo = 1, 
                     @Rol = 'ADMIN', 
                     @RESPUESTA = @RESPUESTA OUTPUT;


--3. Eliminación de un usuario:
   
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_USUARIOS @PROCESO = 3, @UsuarioID = 2, 
                     @NombreUsuario = NULL, 
                     @Contrasena = NULL, 
                     @CorreoElectronico = NULL, 
                     @NombreCompleto = NULL, 
                     @Activo = NULL, 
                     @Rol = NULL, 
                     @RESPUESTA = @RESPUESTA OUTPUT;


--4. Consulta de usuarios:
   
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_USUARIOS @PROCESO = 90, @UsuarioID = NULL, 
                     @NombreUsuario = NULL, 
                     @Contrasena = NULL, 
                     @CorreoElectronico = NULL, 
                     @NombreCompleto = NULL, 
                     @Activo = NULL, 
                     @Rol = NULL, 
                     @RESPUESTA = @RESPUESTA OUTPUT;
