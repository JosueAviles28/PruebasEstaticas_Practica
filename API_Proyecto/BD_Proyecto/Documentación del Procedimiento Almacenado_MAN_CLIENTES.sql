--Documentación del Procedimiento Almacenado: MAN_CLIENTES

--Nombre del Procedimiento--: MAN_CLIENTES

--Descripción--:
--Este procedimiento almacenado gestiona las operaciones de mantenimiento (inserción, actualización, eliminación y consulta) sobre la tabla Clientes. 
--Dependiendo del valor del parámetro @PROCESO, el procedimiento realizará una de las siguientes acciones: crear un nuevo cliente, actualizar un cliente existente, 
--eliminar un cliente o consultar la lista de clientes.

 --Parámetros de Entrada--:
/* @PROCESO (INT) - Obligatorio. Indica la operación a realizar:
 - 1: Insertar un nuevo cliente.
   - 2: Actualizar un cliente existente.
   - 3: Eliminar un cliente.
   - 90: Obtener la lista de clientes.
  
- @ClienteID (INT) - Requerido para los procesos de actualización (2) y eliminación (3). Es el identificador único del cliente en la tabla.

- @Nombre (VARCHAR(100)) - Nombre del cliente. Obligatorio para inserción y actualización.
  
- @Apellido (VARCHAR(100)) - Apellido del cliente. Obligatorio para inserción y actualización.
  
- @CorreoElectronico (VARCHAR(50)) - Correo electrónico del cliente. Obligatorio para inserción y actualización.
  
- @Telefono (VARCHAR(20)) - Teléfono del cliente. Obligatorio para inserción y actualización.
  
- @Direccion (VARCHAR(100)) - Dirección del cliente. Obligatorio para inserción y actualización.

- @RESPUESTA (VARCHAR(200) OUTPUT) - Parámetro de salida que indica el estado de la operación. Devuelve 'OK' si la operación se realiza con éxito o un mensaje de error si ocurre un problema.

 --Comportamiento del Procedimiento--:
El procedimiento almacena realiza distintas operaciones dependiendo del valor de @PROCESO:

1. --Inserción de Cliente (@PROCESO = 1)--:
   - Inserta un nuevo registro en la tabla Clientes con los valores proporcionados.
   - Si ocurre un error (como duplicación de datos), se retorna un mensaje de error en el parámetro @RESPUESTA.
   - Si la inserción es exitosa, se devuelve la lista completa de clientes y @RESPUESTA contiene 'OK'.

2. --Actualización de Cliente (@PROCESO = 2)--:
   - Actualiza un registro existente en la tabla Clientes basado en el @ClienteID.
   - Si ocurre un error durante la actualización, se devuelve un mensaje detallado en @RESPUESTA.
   - Si la actualización es exitosa, se devuelve el cliente actualizado y @RESPUESTA contiene 'OK'.

3. --Eliminación de Cliente (@PROCESO = 3)--:
   - Elimina un cliente existente de la tabla Clientes basado en el @ClienteID.
   - Si ocurre un error durante la eliminación, se retorna un mensaje de error en @RESPUESTA.
   - Si la eliminación es exitosa, se devuelve un mensaje indicando que el cliente fue eliminado y @RESPUESTA contiene 'OK'.

4. --Consulta de Clientes (@PROCESO = 90)--:
   - Devuelve la lista completa de clientes con los nombres en mayúsculas.
   - @RESPUESTA contendrá 'OK' si la operación es exitosa.
*/
 --Ejemplo de Uso--:

--1. Inserción de un cliente--:
   
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_CLIENTES @PROCESO = 1, @ClienteID = NULL, @Nombre = 'Juan', @Apellido = 'Perez', 
                     @CorreoElectronico = 'juan.perez@example.com', @Telefono = '555-1234', 
                     @Direccion = 'Calle Falsa 123', @RESPUESTA = @RESPUESTA OUTPUT;
 
--2. Actualización de un cliente--:
   
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_CLIENTES @PROCESO = 2, @ClienteID = 1, @Nombre = 'Juan', @Apellido = 'Pérez Modificado', 
                     @CorreoElectronico = 'juan.perez@example.com', @Telefono = '555-1234', 
                     @Direccion = 'Calle Real 123', @RESPUESTA = @RESPUESTA OUTPUT;
 

--3. Eliminación de un cliente--:
  
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_CLIENTES @PROCESO = 3, @ClienteID = 1, @Nombre = NULL, @Apellido = NULL, 
                     @CorreoElectronico = NULL, @Telefono = NULL, @Direccion = NULL, 
                     @RESPUESTA = @RESPUESTA OUTPUT;
 

--4. Consulta de la lista de clientes--:
   
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_CLIENTES @PROCESO = 90, @ClienteID = NULL, @Nombre = NULL, @Apellido = NULL, 
                     @CorreoElectronico = NULL, @Telefono = NULL, @Direccion = NULL, 
                     @RESPUESTA = @RESPUESTA OUTPUT;
 
 