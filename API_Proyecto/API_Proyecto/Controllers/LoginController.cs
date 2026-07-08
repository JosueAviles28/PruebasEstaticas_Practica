using API_Proyecto.Modelos;
using API_Proyecto.Repositorios;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.Data;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace API_Proyecto.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        public readonly LoginRepositorio _loginRepositorio;
        public string ClaveSecreta;

        public  LoginController (LoginRepositorio loginRepositorio, IConfiguration configuration )
        {
            _loginRepositorio = loginRepositorio;
            ClaveSecreta = configuration.GetSection("ApiSettings:Secreta").Value;
        }


        [HttpPost]
        public async Task<IActionResult> Login([FromBody] LoginUsuario usuario)

        {  
            var resultado = await _loginRepositorio.EjecutarLogin(usuario);

            //Verificar si el resultado es nulo, lo que indicaria credenciales invalidas
            if (resultado == null)
            {
                return Unauthorized(new { mensaje = "Credenciales inválidas" });
            }

            var usuarioInfo = resultado.Tables[0].AsEnumerable().Select(
                row => new
                {
                    UsuarioId = row["UsuarioID"].ToString(),
                    Nombre = row["NombreUsuario"].ToString(),
                    Correo = row["CorreoElectronico"].ToString(),
                    Rol = row["Rol"].ToString()
                }
                ).ToList();

            //Construir el token
            //Instanciar la clase JWTService y generar el token

            var manejadorJwt = new JwtSecurityTokenHandler();
            
            //Convertir la clave secreta a bytes
            var key = Encoding.ASCII.GetBytes(ClaveSecreta);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[]
                    {
                        new Claim(ClaimTypes.NameIdentifier, usuarioInfo[0].UsuarioId),
                        new Claim(ClaimTypes.Name, usuarioInfo[0].Nombre),
                        new Claim(ClaimTypes.Email, usuarioInfo[0].Correo),
                        new Claim(ClaimTypes.Role, usuarioInfo[0].Rol),
                    }
                ),
                Expires = DateTime.UtcNow.AddMinutes(5),
                SigningCredentials = new SigningCredentials(
                        new SymmetricSecurityKey(key),
                        SecurityAlgorithms.HmacSha256Signature
                    )
            };

            //Generar el token utilizando el manejador de JWT
            var token = manejadorJwt.CreateToken(tokenDescriptor);

            //Devolver el token al cliente
            var respuestaToken = new
            {
                token = manejadorJwt.WriteToken(token),
                Usuario = usuarioInfo
            };

            //Devolver el token y la informacion del usuario al cliente
            return Ok(respuestaToken);



        }
    }
}
