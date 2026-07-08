-- Documentación del Procedimiento Almacenado: MAN_DOCUMENTOS

-- Nombre del Procedimiento: MAN_DOCUMENTOS

-- Descripción:
/*
Este procedimiento almacenado gestiona los documentos asociados a los proyectos. Permite realizar operaciones como insertar, actualizar, eliminar y consultar documentos dentro del sistema. 
Cada documento tiene una URL asociada y está vinculado a un proyecto específico.

-- Parámetros de Entrada:
- @PROCESO (TINYINT) - Obligatorio. Define la operación a realizar:
  - 1: Inserta un nuevo documento para un proyecto.
  - 2: Actualiza un documento existente.
  - 3: Elimina un documento.
  - 90: Consulta los documentos asociados a un proyecto.
  
- @DocumentoID (INT) - Opcional. Se utiliza para las operaciones de actualización (@PROCESO = 2) y eliminación (@PROCESO = 3). No es necesario para la inserción de un nuevo documento.

- @ProyectoID (INT) - Obligatorio. Identificador del proyecto al cual pertenece el documento.

- @Tipo (VARCHAR(50)) - Obligatorio para inserción y actualización. Indica el tipo de documento (por ejemplo, "Contrato", "Informe").

- @URLDelDocumento (VARCHAR(255)) - Obligatorio para inserción y actualización. Contiene la URL o ruta del documento almacenado.

- @FechaDelDocumento (DATE) - Obligatorio para inserción y actualización. Fecha en que fue creado o almacenado el documento.

- @RESPUESTA (VARCHAR(200) OUTPUT) - Parámetro de salida que indica el resultado de la operación. Retorna 'OK' si la operación fue exitosa o un mensaje de error detallado en caso de problemas.

-- Comportamiento del Procedimiento:
El procedimiento realiza diversas operaciones dependiendo del valor de @PROCESO:

1. Inserción de Documento (@PROCESO = 1):
   - Inserta un nuevo documento en la tabla Documentos, vinculado a un proyecto y con los detalles proporcionados.
   - Si ocurre un error (como duplicación de registros), devuelve un mensaje de error en @RESPUESTA.
   - Si la inserción es exitosa, @RESPUESTA devuelve 'OK'.

2. Actualización de Documento (@PROCESO = 2):
   - Actualiza los datos de un documento existente en la tabla Documentos, utilizando @DocumentoID como referencia.
   - Si ocurre un error, como duplicación de datos, devuelve un mensaje de error en @RESPUESTA.
   - Si la actualización es exitosa, @RESPUESTA devuelve 'OK'.

3. Eliminación de Documento (@PROCESO = 3):
   - Elimina un documento de la tabla Documentos basándose en el @DocumentoID.
   - Si ocurre un error durante la eliminación, devuelve un mensaje de error en @RESPUESTA.
   - Si la eliminación es exitosa, @RESPUESTA devuelve 'OK'.

4. Consulta de Documentos (@PROCESO = 90):
   - Consulta todos los documentos registrados en la tabla Documentos que están asociados al @ProyectoID. Si @ProyectoID es NULL, devuelve todos los documentos.
   - Si la consulta es exitosa, @RESPUESTA devuelve 'OK'.
*/

-- Ejemplo de Uso:

--1. Inserción de un nuevo documento:
  
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_DOCUMENTOS @PROCESO = 1, @DocumentoID = NULL, 
                      @ProyectoID = 5, @Tipo = 'Contrato', 
                      @URLDelDocumento = 'http://example.com/documento1.pdf', 
                      @FechaDelDocumento = '2024-10-20', 
                      @RESPUESTA = @RESPUESTA OUTPUT;
 

--2. Actualización de un documento existente:
  
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_DOCUMENTOS @PROCESO = 2, @DocumentoID = 3, 
                      @ProyectoID = 5, @Tipo = 'Informe', 
                      @URLDelDocumento = 'http://example.com/documento1_editado.pdf', 
                      @FechaDelDocumento = '2024-10-22', 
                      @RESPUESTA = @RESPUESTA OUTPUT;
   

--3. Eliminación de un documento:
  
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_DOCUMENTOS @PROCESO = 3, @DocumentoID = 3, 
                      @ProyectoID = NULL, @Tipo = NULL, 
                      @URLDelDocumento = NULL, @FechaDelDocumento = NULL, 
                      @RESPUESTA = @RESPUESTA OUTPUT;
 

--4. Consulta de documentos asociados a un proyecto:
  
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_DOCUMENTOS @PROCESO = 90, @DocumentoID = NULL, 
                      @ProyectoID = 5, @Tipo = NULL, 
                      @URLDelDocumento = NULL, @FechaDelDocumento = NULL, 
                      @RESPUESTA = @RESPUESTA OUTPUT;
  