using API_Proyecto.Modelos;
using API_Proyecto.Repositorios;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace API_Proyecto.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    
    public class ClientesController : ControllerBase
    {

        private readonly ClientesRepositorio _clienteRepositorio;

        public ClientesController(  ClientesRepositorio clientesRepositorio )
        {
            _clienteRepositorio = clientesRepositorio;
        }

        //Get = Para obtener todos los clientes
        //Post = Para agregar un nuevo cliente
        //Put = Para actualizar un nuevo cliente
        //Delete = Paraliminar un cliente existente

        [HttpGet]
        public async Task<IActionResult> ObtenerClientes()
        {
            var modelo = new Cliente
            {
                Proceso = 90
            };

            var respuesta = await _clienteRepositorio.EjecutarSpClientes(modelo);

            if (respuesta.Tables.Count > 0)
            {
                //Declara una variable para manejar o manipular tablas
                var listaRespuesta = new List<Dictionary<string, object>>();

                foreach (DataRow fila in respuesta.Tables[0].Rows)
                {
                    var filaDatos = new Dictionary<string, object>();

                    foreach(DataColumn columna in respuesta.Tables[0].Columns)
                    {
                        filaDatos[columna.ColumnName] = fila[columna];
                    }

                    listaRespuesta.Add(filaDatos);
                }

                return Ok(listaRespuesta);

            }

            return NotFound("No se encontraron registros");

        }

        [HttpPost]
        [Authorize]  //Agrega el atricuto Authorize para protefer los endpoints de este controlador
        public async Task<IActionResult> AgregarClientes([FromBody] Cliente cliente )
        {
            var respuesta = await _clienteRepositorio.EjecutarSpClientes(cliente);

            if(respuesta.Tables.Count > 0)
            {
                return Ok();

            }
            else
            {
                return BadRequest("No se pudo agregar el cliente");
            }

        }


        [HttpPut]
        [Authorize]  //Agrega el atricuto Authorize para protefer los endpoints de este controlador
        public async Task<IActionResult> ActualizarCliente([FromBody] Cliente cliente)
        {
            var modelo = new Cliente
            {
                Proceso = 2,
                ClienteID = cliente.ClienteID,
                Nombre = cliente.Nombre,
                Apellido = cliente.Apellido,
                Correo = cliente.Correo,
                Telefono = cliente.Telefono,
                Direccion = cliente.Direccion
            };
            var respuesta = await _clienteRepositorio.EjecutarSpClientes(modelo);
            if (respuesta.Tables.Count > 0)
            {
                return Ok();
            }
            else 
            {
                return BadRequest("No se pudo actualizar el cliente");
            }
        }

        // Metodo DELETE para eliminar clientes existentes
        [HttpDelete]
        [Authorize]  //Agrega el atricuto Authorize para protefer los endpoints de este controlador

        public async Task<IActionResult> EliminarCliente(int IdCliente)
        {
            var modelo = new Cliente
            {
                Proceso = 3,
                ClienteID = IdCliente,
                Nombre = string.Empty,
                Apellido = string.Empty,
                Correo = string.Empty,
                Telefono = string.Empty,
                Direccion = string.Empty
            };

            var respuesta = await _clienteRepositorio.EjecutarSpClientes(modelo);
            if (respuesta.Tables.Count > 0)
            {
                return Ok();
            }
            else
            {
                return BadRequest("No se pudo aliminar el cliente");
            }

        }

    }
}
