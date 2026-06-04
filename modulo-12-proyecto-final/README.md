# Módulo 12: Proyecto Final — LiterAlura

> **Duración estimada:** 5-6 sesiones
> **Objetivo:** Construir el proyecto LiterAlura completo integrando TODOS los conceptos aprendidos

## 📚 Conceptos Integrados

| Módulo | Conceptos en el proyecto final |
|--------|-------------------------------|
| 01 | Scanner, text blocks, switch, while, String methods |
| 02 | Clases Libro, Autor (encapsulamiento, constructores) |
| 03 | Interfaces (IConvierteDatos), composición |
| 04 | List, ArrayList, forEach, lambdas |
| 05 | Excepciones personalizadas, try-catch, finally |
| 06 | JDBC → reemplazado por JPA (conceptual) |
| 07 | JPA: @Entity, relaciones, JPQL |
| 08 | Spring Boot, DI por constructor, CommandLineRunner |
| 09 | Spring Data JPA: repositorios, @Query |
| 10 | HttpClient, Jackson, Records, Gutendex API |
| 11 | Streams, Optional, Statistics, groupingBy |

---

## 🧪 Proyecto Final: LiterAlura Completo

### Estructura del proyecto

```
literalura-final/
├── pom.xml
└── src/
    └── main/
        ├── java/com/aluracursos/literalura/
        │   ├── LiteraluraApplication.java
        │   ├── controller/
        │   │   └── Principal.java
        │   ├── model/
        │   │   ├── Autor.java
        │   │   ├── Datos.java
        │   │   ├── DatosAutor.java
        │   │   ├── DatosLibros.java
        │   │   └── Libro.java
        │   ├── repository/
        │   │   ├── AutorRepository.java
        │   │   └── LibroRepository.java
        │   └── service/
        │       ├── AutorService.java
        │       ├── ConsumoAPI.java
        │       ├── ConvierteDatos.java
        │       ├── IConvierteDatos.java
        │       ├── LibroService.java
        │       └── ReportesService.java
        └── resources/
            └── application.properties
```

### Funcionalidades del menú

```
--- LITERALURA ---
1- Buscar libro por título (API)
2- Mostrar historial de libros buscados
3- Listar autores registrados
4- Listar autores vivos en determinado año
5- Listar libros por idioma
6- Top 10 Libros más descargados
7- Estadísticas de descargas
8- Buscar autor por nombre
9- Reportes avanzados (agrupaciones)
0- Salir
```

---

### 🔧 Ejercicio Final — Paso a Paso

## Paso 1: pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.4.0</version>
        <relativePath/>
    </parent>

    <groupId>com.aluracursos</groupId>
    <artifactId>literalura</artifactId>
    <version>1.0.0</version>
    <description>Literalura - Catálogo de Libros</description>

    <properties>
        <java.version>17</java.version>
    </properties>

    <dependencies>
        <!-- Spring Boot -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>

        <!-- Spring Data JPA -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>

        <!-- PostgreSQL -->
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <scope>runtime</scope>
        </dependency>

        <!-- Jackson para JSON -->
        <dependency>
            <groupId>tools.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
            <version>3.0.4</version>
        </dependency>

        <!-- Test -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

## Paso 2: application.properties

```properties
spring.application.name=literalura
spring.datasource.url=jdbc:postgresql://${DB_HOST:localhost}:5432/${DB_NAME:literalura_db}
spring.datasource.username=${DB_USER:literalura_user}
spring.datasource.password=${DB_PASSWORD:literalura123}
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.format_sql=true
```

## Paso 3: LiteraluraApplication.java

```java
package com.aluracursos.literalura;

import com.aluracursos.literalura.controller.Principal;
import com.aluracursos.literalura.service.*;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class LiteraluraApplication implements CommandLineRunner {

    private final LibroService libroService;
    private final AutorService autorService;
    private final ReportesService reportesService;

    public LiteraluraApplication(LibroService libroService,
                                  AutorService autorService,
                                  ReportesService reportesService) {
        this.libroService = libroService;
        this.autorService = autorService;
        this.reportesService = reportesService;
    }

    public static void main(String[] args) {
        SpringApplication.run(LiteraluraApplication.class, args);
    }

    @Override
    public void run(String... args) {
        Principal principal = new Principal(libroService, autorService, reportesService);
        principal.mostrarMenu();
    }
}
```

## Paso 4: Modelos (records y entidades)

**Ya están definidos en módulos anteriores. Asegúrate de tener:**
- `Datos` (record)
- `DatosAutor` (record)
- `DatosLibros` (record)
- `Autor` (entidad JPA)
- `Libro` (entidad JPA con relación @ManyToOne a Autor)

## Paso 5: Servicios

- `ConsumoAPI` — HttpClient para llamar a Gutendex
- `ConvierteDatos` — Jackson para parsear JSON
- `IConvierteDatos` — interfaz
- `LibroService` — CRUD + buscarYGuardarLibro
- `AutorService` — consultas de autores
- `ReportesService` — streams avanzados + estadísticas

## Paso 6: Repositorios

- `AutorRepository` — extends JpaRepository + @Query
- `LibroRepository` — extends JpaRepository + derived queries

## Paso 7: Principal (menú)

**Todas las opciones deben funcionar:**

```java
package com.aluracursos.literalura.controller;

import com.aluracursos.literalura.service.*;
import java.util.Scanner;

public class Principal {
    private final Scanner lectura = new Scanner(System.in);
    private final LibroService libroService;
    private final AutorService autorService;
    private final ReportesService reportesService;

    public Principal(LibroService libroService, AutorService autorService,
                     ReportesService reportesService) {
        this.libroService = libroService;
        this.autorService = autorService;
        this.reportesService = reportesService;
    }

    public void mostrarMenu() {
        var opcion = -1;
        while (opcion != 0) {
            var menu = """
                    \n--- LITERALURA ---
                    1- Buscar libro por título (API)
                    2- Mostrar historial de libros buscados
                    3- Listar autores registrados
                    4- Listar autores vivos en determinado año
                    5- Listar libros por idioma
                    6- Top 10 Libros más descargados
                    7- Estadísticas de descargas
                    8- Buscar autor por nombre
                    9- Reportes avanzados
                    0- Salir
                    Elija una opción:""";
            System.out.print(menu);

            try {
                opcion = Integer.parseInt(lectura.nextLine());
            } catch (NumberFormatException e) {
                System.out.println("Ingrese un número válido");
                continue;
            }

            switch (opcion) {
                case 1 -> buscarLibro();
                case 2 -> mostrarHistorial();
                case 3 -> listarAutores();
                case 4 -> listarAutoresVivos();
                case 5 -> listarPorIdioma();
                case 6 -> mostrarTop10();
                case 7 -> mostrarEstadisticas();
                case 8 -> buscarAutorPorNombre();
                case 9 -> reportesAvanzados();
                case 0 -> System.out.println("Cerrando aplicación...");
                default -> System.out.println("Opción inválida");
            }
        }
    }

    // ====== IMPLEMENTA CADA MÉTODO ======

    private void buscarLibro() {
        System.out.print("Ingrese el título del libro: ");
        var titulo = lectura.nextLine();
        libroService.buscarYGuardarLibro(titulo);
    }

    private void mostrarHistorial() {
        var libros = libroService.obtenerTodosLosLibros();
        if (libros.isEmpty()) {
            System.out.println("No hay libros registrados");
        } else {
            libros.forEach(System.out::println);
        }
    }

    private void listarAutores() {
        var autores = autorService.obtenerAutores();
        if (autores.isEmpty()) {
            System.out.println("No hay autores registrados");
        } else {
            autores.forEach(System.out::println);
        }
    }

    private void listarAutoresVivos() {
        System.out.print("Ingrese el año: ");
        try {
            var anio = Integer.parseInt(lectura.nextLine());
            var vivos = autorService.obtenerAutoresVivosEnAnio(anio);
            if (vivos.isEmpty()) {
                System.out.println("No hay autores vivos en " + anio);
            } else {
                vivos.forEach(System.out::println);
            }
        } catch (NumberFormatException e) {
            System.out.println("Año inválido");
        }
    }

    private void listarPorIdioma() {
        System.out.print("""
                Ingrese el código del idioma:
                es - Español
                en - Inglés
                fr - Francés
                pt - Portugués
                Código:\s""");
        var codigo = lectura.nextLine().toLowerCase();
        var libros = libroService.listarLibrosPorIdioma(codigo);
        if (libros.isEmpty()) {
            System.out.println("No hay libros en " + codigo);
        } else {
            System.out.println("Total: " + libros.size() + " libros en " + codigo);
            libros.forEach(System.out::println);
        }
    }

    private void mostrarTop10() {
        System.out.println("\n--- TOP 10 LIBROS MÁS DESCARGADOS ---");
        var top = libroService.obtenerTop10Libros();
        if (top.isEmpty()) {
            System.out.println("No hay libros registrados");
        } else {
            top.forEach(l -> System.out.printf(
                    "%s — %.0f descargas%n",
                    l.getTitulo(), l.getNumeroDescargas()));
        }
    }

    private void mostrarEstadisticas() {
        var est = libroService.obtenerEstadisticasDescargas();
        System.out.printf("""
                
                --- ESTADÍSTICAS DE DESCARGAS ---
                Promedio: %.2f
                Máximo: %.0f
                Mínimo: %.0f
                Total libros evaluados: %d
                """, est.getAverage(), est.getMax(),
                est.getMin(), est.getCount());
    }

    private void buscarAutorPorNombre() {
        System.out.print("Ingrese el nombre del autor: ");
        var nombre = lectura.nextLine();
        var autores = autorService.buscarPorNombre(nombre);
        if (autores.isEmpty()) {
            System.out.println("Autor no encontrado");
        } else {
            autores.forEach(System.out::println);
        }
    }

    private void reportesAvanzados() {
        System.out.print("""
                
                --- REPORTES AVANZADOS ---
                a- Agrupar libros por idioma
                b- Contar libros por autor
                c- Libros sobre el promedio de descargas
                d- Total descargas por idioma
                Elija una opción:\s""");
        var opc = lectura.nextLine();
        switch (opc.toLowerCase()) {
            case "a" -> reportesService.mostrarAgrupacionPorIdioma();
            case "b" -> reportesService.mostrarConteoPorAutor();
            case "c" -> reportesService.mostrarLibrosSobrePromedio();
            case "d" -> reportesService.mostrarTotalDescargasPorIdioma();
            default -> System.out.println("Opción inválida");
        }
    }
}
```

## ✅ Evaluación Proyecto Final

Para aprobar el módulo final, el proyecto debe:

- [ ] **Compilar y ejecutar** sin errores
- [ ] **Opción 1**: Buscar libro en API Gutendex y guardar en BD
- [ ] **Opción 2**: Mostrar todos los libros de la BD
- [ ] **Opción 3**: Listar todos los autores
- [ ] **Opción 4**: Listar autores vivos en un año específico (JPQL)
- [ ] **Opción 5**: Filtrar libros por idioma
- [ ] **Opción 6**: Top 10 libros más descargados
- [ ] **Opción 7**: Estadísticas de descargas (DoubleSummaryStatistics)
- [ ] **Opción 8**: Buscar autor por nombre
- [ ] **Opción 9**: Reportes avanzados con streams
- [ ] **Opción 0**: Salir del programa
- [ ] **Manejo de excepciones** en todas las entradas de usuario
- [ ] **No duplicar** libros ni autores en la BD
- [ ] **Código limpio**: inyección por constructor, sin @Autowired en campos

> ## 🎉 ¡FELICIDADES!
>
> Si llegaste hasta aquí y todo funciona, has dominado:
>
> - ✅ Java 17+ (POO, colecciones, streams, excepciones)
> - ✅ Spring Boot (DI, CommandLineRunner, configuración)
> - ✅ JPA / Hibernate (entidades, relaciones, JPQL)
> - ✅ Spring Data JPA (repositorios, derived queries, @Query)
> - ✅ PostgreSQL (persistencia, consultas)
> - ✅ Consumo de APIs REST (HttpClient, Jackson, JSON)
> - ✅ Programación funcional (Streams, Optional, lambdas)
> - ✅ Git / GitHub (control de versiones)
>
> **Ahora estás listo para crear cualquier proyecto Java con Spring Boot. 🚀**
