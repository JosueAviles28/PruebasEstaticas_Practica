namespace API_Proyecto.Modelos
{
    // Clase modelo para clientes, con sus respectivas propiedades
    public class Cliente
    {
        public int Proceso { get; set; }
        public int ClienteID { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Correo { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }

    }
}
