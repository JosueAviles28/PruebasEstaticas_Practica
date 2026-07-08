using API_Proyecto.Data;
using API_Proyecto.Modelos;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace API_Proyecto.Repositorios
{
    public class LoginRepositorio
    {
        public readonly ApplicationsDbContext _contextDb;
        public LoginRepositorio(ApplicationsDbContext dbContext)
        {
            _contextDb = dbContext;
        }


        public async Task<DataSet> EjecutarLogin (LoginUsuario usuario)
        {
            var UsuarioParam = new SqlParameter("@Usuario", SqlDbType.VarChar, 50) { Value = usuario.Usuario ?? (object)DBNull.Value };
            var ContrasenaParam = new SqlParameter("@Password", SqlDbType.VarChar, 50) { Value = usuario.Contrasena ?? (object)DBNull.Value };

            var RespuestaParam = new SqlParameter("@Respuesta", SqlDbType.VarChar, 100)
            {
                Direction = ParameterDirection.Output
            };

            //Declaro la variable data ser para almacenar el resultado del SP
            var dataset = new DataSet();

            using (var comando = _contextDb.Database.GetDbConnection().CreateCommand())
            {

                comando.CommandType = CommandType.StoredProcedure; //Especificar que el comando es un procedimiento almacenado
                comando.CommandText = "SP_VALIDARLOGIN";

                comando.Parameters.Add(UsuarioParam);
                comando.Parameters.Add(ContrasenaParam);
                comando.Parameters.Add(RespuestaParam);

                //Abrir la conexion si no esta abierta
                //Funcion CallBack : Es una funcion que se ejecuta despues de que se complete una tarea asincrona  ()=>{ }
                using (var data = new SqlDataAdapter((SqlCommand)comando))
                {

                    await Task.Run(() =>
                    {
                        data.Fill(dataset); //Llenar el DataSet con los resultados del procedimiento almacenado
                    });

                }

                return dataset;


            }

        }

    }

 
}
