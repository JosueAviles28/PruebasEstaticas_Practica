using API_Proyecto.Modelos;
using API_Proyecto.Repositorios;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace API_Proyecto.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PersonalController : ControllerBase
    {
        private readonly PersonalRepositorio _personalRepositorio;

        public PersonalController(PersonalRepositorio personalRepositorio)
        {
            _personalRepositorio = personalRepositorio;
        }

        [HttpGet]
        public async Task<IActionResult> ObtenerPersonal()
        {
            var modelo = new Personal
            {
                Proceso = 90
            };

            var resultado = await _personalRepositorio.EjecutarSpPersonal(modelo);
            var respuesta = resultado.dataset;

            if (respuesta.Tables.Count > 0)
            {
                var listaRespuesta = new List<Dictionary<string, object>>();

                foreach (DataRow fila in respuesta.Tables[0].Rows)
                {
                    var filaDatos = new Dictionary<string, object>();

                    foreach (DataColumn columna in respuesta.Tables[0].Columns)
                    {
                        filaDatos[columna.ColumnName] = fila[columna];
                    }

                    listaRespuesta.Add(filaDatos);
                }

                return Ok(listaRespuesta);
            }

            return Ok(new List<object>());
        }

        [HttpPost]
        [Authorize]
        public async Task<IActionResult> AgregarPersonal([FromBody] Personal personal)
        {
            personal.Proceso = 1;

            var resultado = await _personalRepositorio.EjecutarSpPersonal(personal);

            if (resultado.respuesta == "OK")
            {
                return Ok("Personal agregado correctamente");
            }

            return BadRequest("No se pudo agregar el personal. Respuesta SP: " + resultado.respuesta);
        }

        [HttpPut]
        [Authorize]
        public async Task<IActionResult> ActualizarPersonal([FromBody] Personal personal)
        {
            personal.Proceso = 2;

            var resultado = await _personalRepositorio.EjecutarSpPersonal(personal);

            if (resultado.respuesta == "OK")
            {
                return Ok("Personal actualizado correctamente");
            }

            return BadRequest("No se pudo actualizar el personal. Respuesta SP: " + resultado.respuesta);
        }

        [HttpDelete]
        [Authorize]
        public async Task<IActionResult> EliminarPersonal(int personalID)
        {
            var modelo = new Personal
            {
                Proceso = 3,
                PersonalID = personalID
            };

            var resultado = await _personalRepositorio.EjecutarSpPersonal(modelo);

            if (resultado.respuesta == "OK")
            {
                return Ok("Personal eliminado correctamente");
            }

            return BadRequest("No se pudo eliminar el personal. Respuesta SP: " + resultado.respuesta);
        }
    }
}
