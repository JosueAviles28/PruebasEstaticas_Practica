-- Documentación del Procedimiento Almacenado MAN_FOTOS_DEL_PROYECTO

-- Nombre del Procedimiento: MAN_FOTOS_DEL_PROYECTO

-- Descripción:
/*
	Este procedimiento almacenado permite gestionar las fotos asociadas a los proyectos, ofreciendo las funcionalidades de inserción, actualización, eliminación y consulta de registros. 
	Dependiendo del valor del parámetro @PROCESO, se pueden realizar diferentes acciones relacionadas con la gestión de las fotos de un proyecto.

-- Parámetros de Entrada:
- @PROCESO (INT) - Obligatorio. Indica la operación a realizar:
  - 1: Inserta una nueva foto para un proyecto.
  - 2: Actualiza una foto existente.
  - 3: Elimina una foto.
  - 90: Consulta todas las fotos del proyecto.
  
- @FotoID (INT) - Opcional. Utilizado para las operaciones de actualización (@PROCESO = 2) y eliminación (@PROCESO = 3). No es necesario para la inserción de una nueva foto.

- @ProyectoID (INT) - Obligatorio. Identificador del proyecto al cual pertenece la foto.

- @URLDeLaFoto (VARCHAR(255)) - Obligatorio para inserción y actualización. Contiene la URL o ruta de la foto almacenada.

- @Descripcion (VARCHAR(255)) - Obligatorio para inserción y actualización. Descripción de la foto que detalla el contenido o contexto.

- @FechaDeLaFoto (VARCHAR(10)) - Obligatorio para inserción y actualización. Fecha en que fue tomada la foto, en formato DD/MM/YYYY.

- @RESPUESTA (VARCHAR(200) OUTPUT) - Parámetro de salida que indica el resultado de la operación. Retorna 'OK' si la operación fue exitosa, o un mensaje de error detallado si ocurrió algún problema.

-- Comportamiento del Procedimiento:
El procedimiento realiza diversas operaciones dependiendo del valor de @PROCESO:

1. Inserción de Foto (@PROCESO = 1):
   - Inserta un nuevo registro en la tabla FotosDelProyecto con los datos de la foto proporcionados.
   - Si ocurre un error (como una duplicación de registros), devuelve un mensaje de error en @RESPUESTA.
   - Si la inserción es exitosa, @RESPUESTA devuelve 'OK'.

2. Actualización de Foto (@PROCESO = 2):
   - Actualiza los datos de una foto existente en la tabla FotosDelProyecto, basado en el @FotoID.
   - Si ocurre un error, como una duplicación de datos, devuelve un mensaje de error en @RESPUESTA.
   - Si la actualización es exitosa, @RESPUESTA devuelve 'OK'.

3. Eliminación de Foto (@PROCESO = 3):
   - Elimina una foto de la tabla FotosDelProyecto basándose en el @FotoID.
   - Si ocurre un error durante la eliminación, devuelve un mensaje de error en @RESPUESTA.
   - Si la eliminación es exitosa, @RESPUESTA devuelve 'OK'.

4. Consulta de Fotos (@PROCESO = 90):
   - Consulta todas las fotos registradas en la tabla FotosDelProyecto y devuelve los campos FotoID, ProyectoID, URLDeLaFoto, Descripcion, y FechaDeLaFoto.
   - Si la consulta es exitosa, @RESPUESTA contiene 'OK'.
*/
-- Ejemplo de Uso:

--1. Inserción de una nueva foto:
  
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_FOTOS_DEL_PROYECTO @PROCESO = 1, @FotoID = NULL, 
                               @ProyectoID = 5, @URLDeLaFoto = 'http://example.com/foto1.jpg', 
                               @Descripcion = 'Foto del avance del proyecto', 
                               @FechaDeLaFoto = '15/10/2024', 
                               @RESPUESTA = @RESPUESTA OUTPUT; 

--2. Actualización de una foto existente:
  
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_FOTOS_DEL_PROYECTO @PROCESO = 2, @FotoID = 3, 
                               @ProyectoID = 5, @URLDeLaFoto = 'http://example.com/foto1_edit.jpg', 
                               @Descripcion = 'Foto editada del proyecto', 
                               @FechaDeLaFoto = '16/10/2024', 
                               @RESPUESTA = @RESPUESTA OUTPUT;
   

--3. Eliminación de una foto:
  
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_FOTOS_DEL_PROYECTO @PROCESO = 3, @FotoID = 3, 
                               @ProyectoID = NULL, @URLDeLaFoto = NULL, 
                               @Descripcion = NULL, @FechaDeLaFoto = NULL, 
                               @RESPUESTA = @RESPUESTA OUTPUT;
      

--4. Consulta de todas las fotos:
  
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_FOTOS_DEL_PROYECTO @PROCESO = 90, @FotoID = NULL, 
                               @ProyectoID = NULL, @URLDeLaFoto = NULL, 
                               @Descripcion = NULL, @FechaDeLaFoto = NULL, 
                               @RESPUESTA = @RESPUESTA OUTPUT;
