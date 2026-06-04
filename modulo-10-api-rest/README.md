# Módulo 10: Consumo de APIs REST

> **Duración estimada:** 3-4 sesiones
> **Objetivo:** Dominar HttpClient, Jackson, Records, parseo JSON, Gutendex API

## 📚 Conceptos a Aprender

| Concepto | Nivel | ¿Lo domino? |
|----------|-------|-------------|
| java.net.http.HttpClient | ⭐⭐ Intermedio | ☐ |
| HttpRequest / HttpResponse | ⭐⭐ Intermedio | ☐ |
| Jackson ObjectMapper (tools.jackson) | ⭐⭐⭐ Avanzado | ☐ |
| @JsonAlias / @JsonIgnoreProperties | ⭐⭐ Intermedio | ☐ |
| Java Records para DTOs | ⭐⭐ Intermedio | ☐ |
| API Gutendex | ⭐⭐ Intermedio | ☐ |
| Manejo de JSON responses | ⭐⭐⭐ Avanzado | ☐ |

---

## 🧪 Ejercicio 10-A: Consumir API Gutendex

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.literalura.service;

import org.springframework.stereotype.Component;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@Component
public class ConsumoAPI {

    public String obtenerDatos(String url) {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .build();

        try {
            HttpResponse<String> response = client
                    .send(request, HttpResponse.BodyHandlers.ofString());
            return response.body();
        } catch (IOException | InterruptedException e) {
            throw new RuntimeException("Error al conectar con la API: " + e.getMessage(), e);
        }
    }

    public static void main(String[] args) {
        ConsumoAPI api = new ConsumoAPI();
        String json = api.obtenerDatos("https://gutendex.com/books/?search=don+quijote");
        System.out.println(json.substring(0, 500)); // primeros 500 caracteres
    }
}
```

**Records para mapear la API:**

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.literalura.model;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public record DatosLibros(
        @JsonAlias("title") String titulo,
        @JsonAlias("authors") List<DatosAutor> autor,
        @JsonAlias("languages") List<String> idiomas,
        @JsonAlias("download_count") Double numeroDescargas
) {}
```

```java
@JsonIgnoreProperties(ignoreUnknown = true)
public record DatosAutor(
        @JsonAlias("name") String nombre,
        @JsonAlias("birth_year") String fechaNacimiento,
        @JsonAlias("death_year") String fechaFallecimiento
) {}
```

```java
@JsonIgnoreProperties(ignoreUnknown = true)
public record Datos(
        @JsonAlias("results") List<DatosLibros> resultados
) {}
```

**Conversor JSON con Jackson:**

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.literalura.service;

import tools.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;

@Component
public class ConvierteDatos implements IConvierteDatos {
    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public <T> T obtenerDatos(String json, Class<T> clase) {
        try {
            return objectMapper.readValue(json, clase);
        } catch (Exception e) {
            throw new RuntimeException("Error al convertir JSON: " + e.getMessage(), e);
        }
    }
}
```

```java
package com.aluracursos.literalura.service;

public interface IConvierteDatos {
    <T> T obtenerDatos(String json, Class<T> clase);
}
```

**👉 Tu turno:**

1. Crea las clases `ConsumoAPI`, `ConvierteDatos`, `IConvierteDatos` exactamente como arriba
2. Crea los Records `Datos`, `DatosLibros`, `DatosAutor`
3. En un `CommandLineRunner`:
   - Busca "cien años de soledad" en la API
   - Convierte el JSON a `Datos`
   - Muestra el título, autor(es), idioma(s) y descargas del primer resultado

```java
// PISTA: probar en CommandLineRunner
@SpringBootApplication
public class LiteraluraApplication implements CommandLineRunner {
    private final ConsumoAPI consumoAPI;
    private final ConvierteDatos conversor;

    public LiteraluraApplication(ConsumoAPI consumoAPI, ConvierteDatos conversor) {
        this.consumoAPI = consumoAPI;
        this.conversor = conversor;
    }

    @Override
    public void run(String... args) {
        var json = consumoAPI.obtenerDatos("https://gutendex.com/books/?search=cien+a%C3%B1os+de+soledad");
        var datos = conversor.obtenerDatos(json, Datos.class);
        var libro = datos.resultados().get(0);
        System.out.println("Título: " + libro.titulo());
        System.out.println("Autor: " + libro.autor().get(0).nombre());
        System.out.println("Idioma: " + libro.idiomas());
        System.out.println("Descargas: " + libro.numeroDescargas());
    }
}
```

---

## 🧪 Ejercicio 10-B: Integrar API con Base de Datos

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.literalura.service;

import com.aluracursos.literalura.model.*;
import com.aluracursos.literalura.repository.*;
import org.springframework.stereotype.Service;

@Service
public class LibroService {
    private final ConsumoAPI consumoAPI;
    private final ConvierteDatos conversor;
    private final LibroRepository libroRepository;
    private final AutorRepository autorRepository;
    private final String URL_BASE = "https://gutendex.com/books/";

    public LibroService(ConsumoAPI consumoAPI, ConvierteDatos conversor,
                        LibroRepository libroRepository, AutorRepository autorRepository) {
        this.consumoAPI = consumoAPI;
        this.conversor = conversor;
        this.libroRepository = libroRepository;
        this.autorRepository = autorRepository;
    }

    public void buscarYGuardarLibro(String titulo) {
        // 1. Llamar a la API
        var url = URL_BASE + "?search=" + titulo.replace(" ", "%20");
        var json = consumoAPI.obtenerDatos(url);
        var datos = conversor.obtenerDatos(json, Datos.class);

        // 2. Verificar si hay resultados
        if (datos.resultados() == null || datos.resultados().isEmpty()) {
            System.out.println("❌ Libro no encontrado en la API");
            return;
        }

        // 3. Tomar el primer resultado
        DatosLibros primerLibro = datos.resultados().get(0);

        // 4. Buscar o crear el autor
        String nombreAutor = primerLibro.autor().get(0).nombre();
        var autoresEncontrados = autorRepository.findByNombreContainsIgnoreCase(nombreAutor);

        Autor autor;
        if (!autoresEncontrados.isEmpty()) {
            autor = autoresEncontrados.get(0);
        } else {
            DatosAutor datosAutor = primerLibro.autor().get(0);
            autor = new Autor(datosAutor);
            autor = autorRepository.save(autor);
        }

        // 5. Verificar si el libro ya existe
        var librosExistentes = libroRepository.findByTituloContainsIgnoreCase(primerLibro.titulo());
        if (!librosExistentes.isEmpty()) {
            System.out.println("⚠️ El libro ya está registrado en la BD");
            return;
        }

        // 6. Guardar el libro
        Libro libro = new Libro(primerLibro, autor);
        libroRepository.save(libro);
        System.out.println("✅ Libro guardado: " + libro.getTitulo());
    }
}
```

**👉 Tu turno:**

1. Agrega al `Autor` un constructor que reciba `DatosAutor`:

```java
public Autor(DatosAutor datosAutor) {
    this.nombre = datosAutor.nombre();
    try {
        this.anioNacimiento = Integer.valueOf(datosAutor.fechaNacimiento());
    } catch (NumberFormatException e) {
        this.anioNacimiento = null;
    }
    try {
        this.anioFallecimiento = Integer.valueOf(datosAutor.fechaFallecimiento());
    } catch (NumberFormatException e) {
        this.anioFallecimiento = null;
    }
}
```

2. Agrega al `Libro` un constructor que reciba `DatosLibros` + `Autor`:

```java
public Libro(DatosLibros datosLibros, Autor autor) {
    this.titulo = datosLibros.titulo();
    this.idiomas = datosLibros.idiomas().get(0);
    this.numeroDescargas = datosLibros.numeroDescargas();
    this.autor = autor;
}
```

3. Agrega al `LibroRepository`:

```java
List<Libro> findByTituloContainsIgnoreCase(String titulo);
```

4. Integra `buscarYGuardarLibro` en el menú del `Principal`

---

## 🧪 Ejercicio 10-C: Múltiples APIs y manejo de errores

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.literalura.service;

import org.springframework.stereotype.Component;
import java.net.URI;
import java.net.http.*;
import java.time.Duration;

@Component
public class ConsumoAPI {
    private final HttpClient client;

    public ConsumoAPI() {
        this.client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))  // timeout de conexión
                .followRedirects(HttpClient.Redirect.NORMAL)  // seguir redirecciones
                .build();
    }

    public String obtenerDatos(String url) {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(Duration.ofSeconds(30))  // timeout de lectura
                .header("Accept", "application/json")
                .build();

        try {
            HttpResponse<String> response = client
                    .send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                throw new RuntimeException("Error HTTP: " + response.statusCode());
            }
            return response.body();

        } catch (HttpTimeoutException e) {
            throw new RuntimeException("⚠️ Tiempo de espera agotado", e);
        } catch (IOException | InterruptedException e) {
            throw new RuntimeException("⚠️ Error de red: " + e.getMessage(), e);
        }
    }
}
```

**👉 Tu turno:**

1. Mejora `ConsumoAPI` con timeout y manejo de códigos HTTP
2. Crea un método `buscarLibroPorId(int idGutendex)` que busque un libro específico por ID en la API: `https://gutendex.com/books/{id}`
3. Si el libro no existe en la API (404), lanza una excepción personalizada `LibroNoEncontradoException`
4. Integra esta nueva funcionalidad en el menú

---

## ✅ Evaluación Módulo 10

- [ ] Ejercicio 10-A: ConsumoAPI + Records + Jackson parseando Gutendex
- [ ] Ejercicio 10-B: buscarYGuardarLibro integrando API + BD
- [ ] Ejercicio 10-C: Timeout, manejo de errores, búsqueda por ID
- [ ] Todo subido a GitHub

> **Cuando termines, avísame para revisar ✅**
