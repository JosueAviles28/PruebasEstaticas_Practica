-- Documentación del Procedimiento Almacenado: MAN_ASIGNACION_DE_PERSONAL

-- Nombre del Procedimiento:MAN_ASIGNACION_DE_PERSONAL

-- Descripción:
/*
Este procedimiento almacenado gestiona las asignaciones de personal a proyectos. 
Permite realizar las operaciones de inserción, actualización, eliminación y consulta de asignaciones de personal, registrando detalles como las fechas de asignación y finalización, 
así como la descripción del trabajo realizado en el proyecto.

-- Parámetros de Entrada:
- @PROCESO (TINYINT) - Obligatorio. Define la operación que se va a realizar:
  - 1: Inserta una nueva asignación de personal.
  - 2: Actualiza una asignación existente.
  - 3: Elimina una asignación.
  - 90: Consulta todas las asignaciones de personal.
  
- @AsignacionID (INT) - Opcional. Utilizado para las operaciones de actualización (@PROCESO = 2) y eliminación (@PROCESO = 3). No es necesario para la inserción.

- @PersonalID (INT) - Obligatorio. Identificador del personal asignado a un proyecto.

- @ProyectoID (INT) - Obligatorio. Identificador del proyecto al cual se asigna el personal.

- @FechaDeAsignacion (DATE) - Obligatorio para inserción y actualización. Fecha de inicio de la asignación del personal al proyecto.

- @FechaDeFinDeAsignacion (DATE) - Obligatorio para inserción y actualización. Fecha de finalización de la asignación del personal al proyecto.

- @DescripcionDelTrabajo (VARCHAR(255)) - Obligatorio para inserción y actualización. Descripción del trabajo o responsabilidades asignadas al personal durante el proyecto.

- @RESPUESTA (VARCHAR(200) OUTPUT) - Parámetro de salida que indica el resultado de la operación. Retorna 'OK' si la operación fue exitosa o un mensaje de error detallado en caso de problemas.

-- Comportamiento del Procedimiento:
El procedimiento almacena realiza las siguientes operaciones en función del valor de @PROCESO:

1. Inserción de Asignación (@PROCESO = 1):
   - Inserta una nueva asignación de personal en la tabla AsignacionDePersonal.
   - Si ocurre un error (como duplicación de registros), se devuelve un mensaje de error en @RESPUESTA.
   - Si la inserción es exitosa, @RESPUESTA devuelve 'OK'.

2. Actualización de Asignación (@PROCESO = 2):
   - Actualiza los detalles de una asignación existente, basándose en el @AsignacionID.
   - Si ocurre un error, como duplicación de datos, devuelve un mensaje de error en @RESPUESTA.
   - Si la actualización es exitosa, @RESPUESTA devuelve 'OK'.

3. Eliminación de Asignación (@PROCESO = 3):
   - Elimina una asignación de la tabla AsignacionDePersonal basándose en el @AsignacionID.
   - Si ocurre un error durante la eliminación, devuelve un mensaje de error en @RESPUESTA.
   - Si la eliminación es exitosa, @RESPUESTA devuelve 'OK'.

4. Consulta de Asignaciones (@PROCESO = 90):
   - Devuelve todas las asignaciones de personal registradas en la tabla AsignacionDePersonal.
   - Si la consulta es exitosa, @RESPUESTA devuelve 'OK'.
*/
-- Ejemplo de Uso:

--1. Inserción de una nueva asignación de personal:
  
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_ASIGNACION_DE_PERSONAL @PROCESO = 1, @AsignacionID = NULL, 
                                   @PersonalID = 2, @ProyectoID = 5, 
                                   @FechaDeAsignacion = '2024-10-01', 
                                   @FechaDeFinDeAsignacion = '2024-12-31', 
                                   @DescripcionDelTrabajo = 'Desarrollo del módulo de inventario', 
                                   @RESPUESTA = @RESPUESTA OUTPUT;
 

--2. Actualización de una asignación existente:
  
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_ASIGNACION_DE_PERSONAL @PROCESO = 2, @AsignacionID = 3, 
                                   @PersonalID = 2, @ProyectoID = 5, 
                                   @FechaDeAsignacion = '2024-10-01', 
                                   @FechaDeFinDeAsignacion = '2024-12-31', 
                                   @DescripcionDelTrabajo = 'Supervisión del desarrollo del módulo de inventario', 
                                   @RESPUESTA = @RESPUESTA OUTPUT;
 

--3. Eliminación de una asignación:
   
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_ASIGNACION_DE_PERSONAL @PROCESO = 3, @AsignacionID = 3, 
                                   @PersonalID = NULL, @ProyectoID = NULL, 
                                   @FechaDeAsignacion = NULL, @FechaDeFinDeAsignacion = NULL, 
                                   @DescripcionDelTrabajo = NULL, 
                                   @RESPUESTA = @RESPUESTA OUTPUT;
 

--4. Consulta de todas las asignaciones de personal:
   
   DECLARE @RESPUESTA VARCHAR(200)
   EXEC MAN_ASIGNACION_DE_PERSONAL @PROCESO = 90, @AsignacionID = NULL, 
                                   @PersonalID = NULL, @ProyectoID = NULL, 
                                   @FechaDeAsignacion = NULL, @FechaDeFinDeAsignacion = NULL, 
                                   @DescripcionDelTrabajo = NULL, 
                                   @RESPUESTA = @RESPUESTA OUTPUT;
 
 