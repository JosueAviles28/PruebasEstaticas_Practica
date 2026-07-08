using API_Proyecto.Data;
using API_Proyecto.Modelos;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace API_Proyecto.Repositorios
{
    public class PersonalRepositorio
    {
        private readonly ApplicationsDbContext _contextDb;

        public PersonalRepositorio(ApplicationsDbContext context)
        {
            _contextDb = context;
        }

        public async Task<(DataSet dataset, string respuesta)> EjecutarSpPersonal(Personal modelo)
        {
            var ProcesoParam = new SqlParameter("@PROCESO", SqlDbType.Int) { Value = modelo.Proceso };
            var PersonalIdParam = new SqlParameter("@PersonalID", SqlDbType.Int)
            {
                Value = modelo.PersonalID == 0 ? DBNull.Value : (object)modelo.PersonalID
            };
            var NombreParam = new SqlParameter("@Nombre", SqlDbType.VarChar, 100) { Value = modelo.Nombre ?? (object)DBNull.Value };
            var ApellidoParam = new SqlParameter("@Apellido", SqlDbType.VarChar, 100) { Value = modelo.Apellido ?? (object)DBNull.Value };
            var RolParam = new SqlParameter("@Rol", SqlDbType.VarChar, 100) { Value = modelo.Rol ?? (object)DBNull.Value };
            var TelefonoParam = new SqlParameter("@Telefono", SqlDbType.VarChar, 20) { Value = modelo.Telefono ?? (object)DBNull.Value };
            var CorreoElectronicoParam = new SqlParameter("@CorreoElectronico", SqlDbType.VarChar, 255) { Value = modelo.CorreoElectronico ?? (object)DBNull.Value };

            var RespuestaParam = new SqlParameter("@RESPUESTA", SqlDbType.VarChar, 200)
            {
                Direction = ParameterDirection.Output
            };

            var dataset = new DataSet();

            using (var conexion = _contextDb.Database.GetDbConnection())
            {
                using (var comando = conexion.CreateCommand())
                {
                    comando.CommandType = CommandType.StoredProcedure;
                    comando.CommandText = "MAN_PERSONAL";

                    comando.Parameters.Add(ProcesoParam);
                    comando.Parameters.Add(PersonalIdParam);
                    comando.Parameters.Add(NombreParam);
                    comando.Parameters.Add(ApellidoParam);
                    comando.Parameters.Add(RolParam);
                    comando.Parameters.Add(TelefonoParam);
                    comando.Parameters.Add(CorreoElectronicoParam);
                    comando.Parameters.Add(RespuestaParam);

                    if (conexion.State != ConnectionState.Open)
                        await conexion.OpenAsync();

                    using (var data = new SqlDataAdapter((SqlCommand)comando))
                    {
                        data.Fill(dataset);
                    }

                    string respuesta = RespuestaParam.Value?.ToString() ?? "";
                    return (dataset, respuesta);
                }
            }
        }
    }
}