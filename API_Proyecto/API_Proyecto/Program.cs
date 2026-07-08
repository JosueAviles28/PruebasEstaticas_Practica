using API_Proyecto.Data;
using API_Proyecto.Repositorios;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddDbContext<ApplicationsDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("ConexionSQL")));

// Aquí se obtiene la clave secreta para la autenticación JWT desde la configuración de la aplicación
var key = builder.Configuration.GetSection("ApiSettings:Secreta").Value;

builder.Services.AddScoped<ClientesRepositorio>(); // Agrega el repositorio de clientes al contenedor de servicios con un alcance de solicitud (Scoped)
builder.Services.AddScoped<LoginRepositorio>(); // Agrega el repositorio de login al contenedor de servicios con un alcance de solicitud (Scoped)
builder.Services.AddScoped<PersonalRepositorio>(); //Agrega el repositorio de Personal al contenedor de servicios con un alcance de solicitud (Scoped)


//Aquí se configura la Autenticación JSON Web Token - Primera parte
builder.Services.AddAuthentication(x =>
{
    // Establece el esquema de autenticación por defecto para la autenticación
    // basada en JWT como el esquema de autenticación por defecto.
    x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;

    // Establece el esquema de desafío por defecto para la autenticación
    // basada en JWT como el esquema de desafío por defecto.
    x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;

    // Agrega la autenticación JWT Bearer al servicio de autenticación.
}).AddJwtBearer(x =>
{
    // Indica si se debe validar el origen HTTPS del token.
    x.RequireHttpsMetadata = false;
    // Indica si el token recibido debe ser almacenado.
    x.SaveToken = true;

    // Especifica los parámetros para la validación del token.
    x.TokenValidationParameters = new TokenValidationParameters
    {
        // Indica si se debe validar la clave de firma del emisor del token.
        ValidateIssuerSigningKey = true,
        // Establece la clave de firma usada para validar los tokens recibidos.
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(key)),
        // Indica si se debe validar el emisor del token.
        ValidateIssuer = false,
        // Indica si se debe validar el destinatario del token.
        ValidateAudience = false
    };
});



builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();



//Aquí se configura la autenticación y autorización - segunda parte
builder.Services.AddSwaggerGen(options =>
{
    // Agrega una definición de seguridad para el esquema Bearer
    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        // Descripción del esquema de seguridad Bearer
        Description =
        "Autenticación JWT usando el esquema Bearer. \r\n\r\n " +
        "Ingresa la palabra 'Bearer' seguida de un [espacio] y despues su token en el campo de abajo \r\n\r\n" +
        "Ejemplo: \"Bearer tkdknkdllskd\"",
        // Nombre del esquema de seguridad en la solicitud de autorización
        Name = "Authorization",
        // Ubicación del token en la solicitud (en el encabezado)
        In = ParameterLocation.Header,
        // Tipo de esquema de seguridad (Bearer)
        Scheme = "Bearer"
    });
    // Agrega un requerimiento de seguridad para el esquema Bearer
    options.AddSecurityRequirement(new OpenApiSecurityRequirement()
    {
        {
			// Especifica el esquema de seguridad que se debe cumplir
			new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                            {
								// Tipo de referencia (esquema de seguridad)
								Type = ReferenceType.SecurityScheme,
								// Identificador del esquema de seguridad (Bearer)
								Id = "Bearer"
                            },
				// Especifica el tipo de esquema de seguridad (oauth2)
				Scheme = "oauth2",
				// Nombre del esquema de seguridad en la solicitud de autorización
				Name = "Bearer",
				 // Ubicación del token en la solicitud (en el encabezado)
				In = ParameterLocation.Header
            },
            new List<string>()
        }
    });
});


// Configuración de CORS para permitir solicitudes desde cualquier origen, con cualquier método y cualquier encabezado
builder.Services.AddCors(p => p.AddPolicy("PolicyCors", build =>
        {
            build.WithOrigins("*").AllowAnyMethod().AllowAnyHeader();
        }
     )
);


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("PolicyCors"); // Habilita la politica de CORS definida anteriormente

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();