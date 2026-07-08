-- Documentación del Procedimiento Almacenado MAN_PROYECTOS

-- Nombre del Procedimiento: MAN_PROYECTOS

-- Descripción:
/*
Este procedimiento almacenado permite gestionar los proyectos en una base de datos, brindando las funcionalidades de inserción, actualización, eliminación y consulta de proyectos. 
Dependiendo del valor del parámetro @PROCESO, se pueden realizar diversas operaciones, como crear un nuevo proyecto, actualizar uno existente, eliminar un proyecto o consultar la lista de proyectos.

-- Parámetros de Entrada:
- @PROCESO (TINYINT) - Obligatorio. Determina la operación a realizar:
  - 1: Inserta un nuevo proyecto.
  - 2: Actualiza un proyecto existente.
  - 3: Elimina un proyecto.
  - 90: Consulta todos los proyectos.
  - 91: Consulta un proyecto específico por @ProyectoID.
  - 92: Busca proyectos por nombre.

- @ProyectoID (INT) - Opcional. Utilizado para las operaciones de actualización (2), eliminación (3) y consulta específica (91). No es requerido para la inserción de nuevos proyectos.

- @NombreDelProyecto (VARCHAR(100)) - Obligatorio para inserción y actualización. Nombre del proyecto.

- @Descripcion (VARCHAR(150)) - Obligatorio para inserción y actualización. Descripción breve del proyecto.

- @FechaDeInicio (VARCHAR(10)) - Obligatorio para inserción y actualización. Fecha de inicio del proyecto en formato DD/MM/YYYY.

- @FechaDeFinalizacion (VARCHAR(10)) - Obligatorio para inserción y actualización. Fecha estimada de finalización del proyecto en formato DD/MM/YYYY.

- @ClienteID (INT) - Obligatorio. Identificador del cliente asociado al proyecto.

- @Estado (VARCHAR(50)) - Obligatorio. Estado actual del proyecto (por ejemplo, "En progreso", "Completado").

- @OPERADOR (INT) - Obligatorio. Identificador del usuario que está realizando la operación.

- @RESPUESTA (VARCHAR(200) OUTPUT) - Parámetro de salida que contiene el estado de la operación ('OK' si la operación fue exitosa, o un mensaje de error detallado si ocurrió un problema).

-- Comportamiento del Procedimiento:
El procedimiento almacena realiza diferentes acciones según el valor de @PROCESO:

1. Inserción de Proyecto (@PROCESO = 1):
   - Inserta un nuevo proyecto en la tabla Proyectos.
   - Si ocurre un error (por ejemplo, duplicación de registro), devuelve un mensaje en @RESPUESTA.
   - Si la inserción es exitosa, devuelve el mensaje "PROYECTO CREADO EXITOSAMENTE" y @RESPUESTA contiene 'OK'.

2. Actualización de Proyecto (@PROCESO = 2):
   - Actualiza los datos de un proyecto existente basándose en @ProyectoID.
   - Si ocurre un error, como duplicación de registro, devuelve un mensaje en @RESPUESTA.
   - Si la actualización es exitosa, devuelve el mensaje "PROYECTO ACTUALIZADO EXITOSAMENTE" y @RESPUESTA contiene 'OK'.

3. Eliminación de Proyecto (@PROCESO = 3):
   - Elimina un proyecto existente de la tabla Proyectos según el @ProyectoID.
   - Si ocurre un error durante la eliminación, devuelve un mensaje de error en @RESPUESTA.
   - Si la eliminación es exitosa, devuelve el mensaje "PROYECTO BORRADO EXITOSAMENTE" y @RESPUESTA contiene 'OK'.

4. Consulta de Todos los Proyectos (@PROCESO = 90):
   - Devuelve todos los proyectos en la tabla Proyectos.
   - Si la consulta es exitosa, @RESPUESTA contiene 'OK'.

5. Consulta de Proyecto por ProyectoID (@PROCESO = 91):
   - Devuelve los datos de un proyecto específico basado en el @ProyectoID.
   - Si la consulta es exitosa, @RESPUESTA contiene 'OK'.

6. Búsqueda de Proyectos por Nombre (@PROCESO = 92):
   - Busca y devuelve proyectos cuyo nombre coincida parcial o totalmente con el valor de @NombreDelProyecto. Si @NombreDelProyecto está vacío, se devuelven todos los proyectos.
   - Si la consulta es exitosa, @RESPUESTA contiene 'OK'.
*/
-- Ejemplo de Uso:

--1. Inserción de un proyecto:
 
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_PROYECTOS @PROCESO = 1, @ProyectoID = NULL, 
                      @NombreDelProyecto = 'Proyecto A', @Descripcion = 'Implementación de software', 
                      @FechaDeInicio = '01/01/2024', @FechaDeFinalizacion = '31/12/2024', 
                      @ClienteID = 1, @Estado = 'En progreso', @OPERADOR = 5, 
                      @RESPUESTA = @RESPUESTA OUTPUT;


--2. Actualización de un proyecto existente:
   
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_PROYECTOS @PROCESO = 2, @ProyectoID = 1, 
                      @NombreDelProyecto = 'Proyecto A Modificado', @Descripcion = 'Actualización de software', 
                      @FechaDeInicio = '01/01/2024', @FechaDeFinalizacion = '30/06/2024', 
                      @ClienteID = 1, @Estado = 'Completado', @OPERADOR = 5, 
                      @RESPUESTA = @RESPUESTA OUTPUT;


--3. Eliminación de un proyecto:
   
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_PROYECTOS @PROCESO = 3, @ProyectoID = 1, 
                      @NombreDelProyecto = NULL, @Descripcion = NULL, 
                      @FechaDeInicio = NULL, @FechaDeFinalizacion = NULL, 
                      @ClienteID = NULL, @Estado = NULL, @OPERADOR = NULL, 
                      @RESPUESTA = @RESPUESTA OUTPUT;


--4. Consulta de todos los proyectos:
   
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_PROYECTOS @PROCESO = 90, @ProyectoID = NULL, 
                      @NombreDelProyecto = NULL, @Descripcion = NULL, 
                      @FechaDeInicio = NULL, @FechaDeFinalizacion = NULL, 
                      @ClienteID = NULL, @Estado = NULL, @OPERADOR = NULL, 
                      @RESPUESTA = @RESPUESTA OUTPUT;


--5. Consulta de un proyecto específico:

   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_PROYECTOS @PROCESO = 91, @ProyectoID = 1, 
                      @NombreDelProyecto = NULL, @Descripcion = NULL, 
                      @FechaDeInicio = NULL, @FechaDeFinalizacion = NULL, 
                      @ClienteID = NULL, @Estado = NULL, @OPERADOR = NULL, 
                      @RESPUESTA = @RESPUESTA OUTPUT;


--6. Búsqueda de proyectos por nombre:
   
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_PROYECTOS @PROCESO = 92, @ProyectoID = NULL, 
                      @NombreDelProyecto = 'Proyecto', @Descripcion = NULL, 
                      @FechaDeInicio = NULL, @FechaDeFinalizacion = NULL, 
                      @ClienteID = NULL, @Estado = NULL, @OPERADOR = NULL, 
                      @RESPUESTA = @RESPUESTA OUTPUT;

