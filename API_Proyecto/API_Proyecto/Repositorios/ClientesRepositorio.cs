using API_Proyecto.Data;
using API_Proyecto.Modelos;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace API_Proyecto.Repositorios
{

    //Existen fos formas de usar una clae dentro de otra clase
    //Herencia 
    // Inyeccion de dependencias
    public class ClientesRepositorio
    {
        //Declarando
        private readonly ApplicationsDbContext _contextDb;

        //Inyectando
        public ClientesRepositorio( ApplicationsDbContext context )
        {
            //Inicializando _contextDb con el valor de context
            _contextDb = context;

        }

        //Metoco para ejecutar el SP
        //DataSet = Es una coleccion de tablas
        public async Task<DataSet> EjecutarSpClientes( Cliente modelo)
        {

            var ProcesoParam = new SqlParameter("@PROCESO", SqlDbType.Int) { Value = modelo.Proceso };
            var ClienteIdParam = new SqlParameter("@ClienteID", SqlDbType.Int) { Value = modelo.ClienteID };
            var NombreParam = new SqlParameter("@Nombre", SqlDbType.VarChar, 100) { Value = modelo.Nombre ?? (object)DBNull.Value };
            var ApellidoParam = new SqlParameter("@Apellido", SqlDbType.VarChar, 100) { Value = modelo.Apellido ?? (object)DBNull.Value };
            var CorreoElectronicoParam = new SqlParameter("@CorreoElectronico", SqlDbType.VarChar, 50) { Value = modelo.Correo ?? (object)DBNull.Value };
            var TelefonoParam = new SqlParameter("@Telefono", SqlDbType.VarChar, 20) { Value = modelo.Telefono ?? (object)DBNull.Value };
            var DireccionParam = new SqlParameter("@Direccion", SqlDbType.VarChar, 100) { Value = modelo.Direccion ?? (object)DBNull.Value };

            var RespuestaParam = new SqlParameter("@RESPUESTA", SqlDbType.VarChar, 100)
            {
                Direction = ParameterDirection.Output
            };

            //declaro la variable dataset para almacenar el resultaddo del SP
            var dataset = new DataSet();

            using (var comando = _contextDb.Database.GetDbConnection().CreateCommand() )
            {

                comando.CommandType = CommandType.StoredProcedure; //Especificar que el comando es un procedimiento almacenado
                comando.CommandText = "MAN_CLIENTES";

                comando.Parameters.Add(ProcesoParam);
                comando.Parameters.Add(ClienteIdParam);
                comando.Parameters.Add(NombreParam);
                comando.Parameters.Add(ApellidoParam);
                comando.Parameters.Add(CorreoElectronicoParam);
                comando.Parameters.Add(TelefonoParam);
                comando.Parameters.Add(DireccionParam);
                comando.Parameters.Add(RespuestaParam);

                //Abrir la conexion si no esta abierta
                //Funcion CallBack : Es una funcion que se ejecuta despues de que se complete una tarea asincrona  ()=>{ }
                using (var data = new SqlDataAdapter((SqlCommand) comando ))
                {
                
                        await Task.Run( () =>
                        {
                            data.Fill(dataset); //Llenar el DataSet con los resultados del procedimiento almacenado
                        });
                
                }

                return dataset;


            }

        }
    }
}
