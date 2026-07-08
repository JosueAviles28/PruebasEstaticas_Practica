-- Documentación del Procedimiento Almacenado MAN_PERSONAL

--# Nombre del Procedimiento: MAN_PERSONAL

--# Descripción:
/*
  Este procedimiento almacenado se utiliza para realizar operaciones de mantenimiento sobre la tabla Personal, incluyendo inserción, actualización, eliminación y consulta de registros. 
  El procedimiento permite gestionar los datos personales y profesionales de los empleados del sistema, tales como nombre, apellido, rol, teléfono y correo electrónico.

-- Parámetros de Entrada:
- @PROCESO (TINYINT) - Obligatorio. Define la operación que se desea realizar:
  - 1: Inserta un nuevo registro de personal.
  - 2: Actualiza un registro de personal existente.
  - 3: Elimina un registro de personal.
  - 90: Consulta un registro de personal o la lista completa.
  
- @PersonalID (INT) - Opcional. Utilizado para las operaciones de actualización (2), eliminación (3) y consulta (90). En las operaciones de inserción, este valor no es necesario.
  
- @Nombre (VARCHAR(100)) - Nombre del personal. Obligatorio para inserción y actualización.

- @Apellido (VARCHAR(100)) - Apellido del personal. Obligatorio para inserción y actualización.

- @Rol (VARCHAR(100)) - Rol o posición del personal dentro de la organización. Obligatorio para inserción y actualización.

- @Telefono (VARCHAR(20)) - Número de teléfono del personal. Obligatorio para inserción y actualización.

- @CorreoElectronico (VARCHAR(255)) - Correo electrónico del personal. Obligatorio para inserción y actualización.

- @RESPUESTA (VARCHAR(200) OUTPUT) - Parámetro de salida que devuelve el estado de la operación, ya sea 'OK' si fue exitosa o un mensaje de error detallado.

--# Comportamiento del Procedimiento:
El procedimiento almacena realiza distintas operaciones en función del valor de @PROCESO:

1. Inserción de Personal (@PROCESO = 1):
   - Inserta un nuevo registro en la tabla Personal con los datos proporcionados.
   - Si ocurre un error (por ejemplo, duplicación de registros), se devuelve un mensaje de error en el parámetro @RESPUESTA.
   - Si la inserción es exitosa, se retorna 'OK' en el parámetro @RESPUESTA.

2. Actualización de Personal (@PROCESO = 2):
   - Actualiza un registro existente en la tabla Personal utilizando @PersonalID como referencia.
   - Si ocurre un error durante la actualización (como duplicación de datos), se devuelve un mensaje detallado en @RESPUESTA.
   - Si la actualización es exitosa, se devuelve 'OK' en el parámetro @RESPUESTA.

3. Eliminación de Personal (@PROCESO = 3):
   - Elimina un registro de la tabla Personal basado en el @PersonalID.
   - Si ocurre un error durante la eliminación, se devuelve un mensaje detallado en @RESPUESTA.
   - Si la eliminación es exitosa, se devuelve 'OK' en el parámetro @RESPUESTA.

4. Consulta de Personal (@PROCESO = 90):
   - Devuelve los registros de la tabla Personal. Si se proporciona @PersonalID, devuelve el registro específico. Si no se proporciona, devuelve todos los registros.
   - El parámetro @RESPUESTA contendrá 'OK' si la operación es exitosa.
*/
--# Ejemplo de Uso:

--1. Inserción de un nuevo personal:

   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_PERSONAL @PROCESO = 1, @PersonalID = NULL, @Nombre = 'Carlos', @Apellido = 'Rodríguez',
                     @Rol = 'Gerente de Ventas', @Telefono = '555-1234', @CorreoElectronico = 'carlos.rodriguez@example.com',
                     @RESPUESTA = @RESPUESTA OUTPUT;

   

--2. Actualización de personal existente:

   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_PERSONAL @PROCESO = 2, @PersonalID = 2, @Nombre = 'Carlos', @Apellido = 'Rodríguez Actualizado',
                     @Rol = 'Gerente de Ventas', @Telefono = '555-1234', @CorreoElectronico = 'carlos.rodriguez@example.com',
                     @RESPUESTA = @RESPUESTA OUTPUT;

   

--3. Eliminación de un registro de personal:

   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_PERSONAL @PROCESO = 3, @PersonalID = 2, @Nombre = NULL, @Apellido = NULL, @Rol = NULL,
                     @Telefono = NULL, @CorreoElectronico = NULL, @RESPUESTA = @RESPUESTA OUTPUT;

   

--4. Consulta de un registro de personal específico:

   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_PERSONAL @PROCESO = 90, @PersonalID = 2, @Nombre = NULL, @Apellido = NULL, @Rol = NULL,
                     @Telefono = NULL, @CorreoElectronico = NULL, @RESPUESTA = @RESPUESTA OUTPUT;

   

--5. Consulta de todos los registros de personal:

   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_PERSONAL @PROCESO = 90, @PersonalID = NULL, @Nombre = NULL, @Apellido = NULL, @Rol = NULL,
                     @Telefono = NULL, @CorreoElectronico = NULL, @RESPUESTA = @RESPUESTA OUTPUT;

   
