namespace Proyecto_Web.Modelos
{
    public class ClientesModelo
    {
        public int ClienteID { get; set; }

        public string Nombre { get; set; }

        public string Apellido { get; set; }

        public string CorreoElectronico { get; set; }

        public string Telefono { get; set; }

        public string Direccion { get; set; }

    }

    public class ClienteModeloPost
    {
        public int proceso { get; set; }
        public int clienteId { get; set; }
        public string nombre { get; set; }
        public string apellido { get; set; }
        public string correo { get; set; }
        public string telefono { get; set; }
        public string direccion { get; set; }
    }

}
