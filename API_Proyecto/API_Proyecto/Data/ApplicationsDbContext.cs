using Microsoft.EntityFrameworkCore;

namespace API_Proyecto.Data
{
    // Crear la funcionalidadpara conectar con la base de datos
    //Para esto se necesita crear una clase que herede con DbContext,
    //esta clase se encargara de manejar la conexion con la base de datos.
    public class ApplicationsDbContext: DbContext
    {
        //Tipo primitivo = int, string, bool, DateTime, etc
        //Tipos genericos = List 
        public ApplicationsDbContext( DbContextOptions<ApplicationsDbContext> options )
            : base(options)
        {
            
        }

    }

}
