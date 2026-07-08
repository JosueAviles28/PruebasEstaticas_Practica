using System.Linq;
using System.Text;
using Newtonsoft.Json;
using Proyecto_Web.Modelos;

namespace Proyecto_Web.Servicios
{
    public interface IClientesServicio
    {
        // Para obtener una lista de Clientes
        public Task<IEnumerable<ClientesModelo>> ListarClientes();

        // Para crear un nuevo cliente
        public Task<bool> CrearClientes(ClienteModeloPost cliente);

        // Para actualizar un cliente existente
        public Task<bool> ActualizarClientes(ClienteModeloPost cliente);

        // Para eliminar un cliente por su ID
        public Task<bool> eliminarClientes(int Idcliente);
    }

    public class ClientesServicio: IClientesServicio
    {
        private readonly HttpClient _httpClient;
        private string _baseURL = "http://localhost:5000/api/Clientes"; 

        // Constructor para inyectar HttpClient
        public ClientesServicio(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<IEnumerable<ClientesModelo>> ListarClientes()
        {
            // Realizamos la petición GET a la API
            var respuesta = await _httpClient.GetAsync(_baseURL);

            if (!respuesta.IsSuccessStatusCode)
            {
                return Enumerable.Empty<ClientesModelo>();
            }

            // Esperamos el contenido de forma asíncrona
            var contenido = await respuesta.Content.ReadAsStringAsync();

            // Deserializamos el contenido JSON a una lista de ClientesModelo
            var clientes = JsonConvert.DeserializeObject<IEnumerable<ClientesModelo>>(contenido) ?? Enumerable.Empty<ClientesModelo>();

            return clientes;
        }

        public async Task<bool> CrearClientes(ClienteModeloPost cliente)
        {
            if (cliente == null)
                return false;

            // Serializa el modelo a JSON
            var json = JsonConvert.SerializeObject(cliente);
            using var content = new StringContent(json, Encoding.UTF8, "application/json");

            // Enviar POST a la API
            var respuesta = await _httpClient.PostAsync(_baseURL, content);

            // Devuelve true si la API respondió con código 2xx
            return respuesta.IsSuccessStatusCode;
        }

        public Task<bool> ActualizarClientes(ClienteModeloPost cliente)
        {
            throw new NotImplementedException();
        }

        public Task<bool> eliminarClientes(int Idcliente)
        {
            throw new NotImplementedException();
        }
    }
}
