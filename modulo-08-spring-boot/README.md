# Módulo 08: Spring Boot e Inyección de Dependencias

> **Duración estimada:** 4-5 sesiones
> **Objetivo:** Dominar Spring Boot, DI, @Autowired, @Component, @Service, CommandLineRunner

## 📚 Conceptos a Aprender

| Concepto | Nivel | ¿Lo domino? |
|----------|-------|-------------|
| Spring Boot Initializr | ⭐⭐ Intermedio | ☐ |
| @SpringBootApplication | ⭐⭐ Intermedio | ☐ |
| Inversión de Control (IoC) | ⭐⭐⭐ Avanzado | ☐ |
| Inyección de Dependencias (DI) | ⭐⭐⭐ Avanzado | ☐ |
| @Component, @Service, @Repository | ⭐⭐ Intermedio | ☐ |
| @Autowired (campo, constructor, setter) | ⭐⭐⭐ Avanzado | ☐ |
| CommandLineRunner | ⭐⭐ Intermedio | ☐ |
| application.properties | ⭐ Básico | ☐ |
| Perfiles (@Profile) | ⭐⭐⭐ Avanzado | ☐ |

---

## 🧪 Ejercicio 08-A: Primer proyecto Spring Boot

**Spring Initializr (configuración manual en pom.xml):**

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
    <artifactId>literalura-spring</artifactId>
    <version>1.0.0</version>
    <description>Literalura con Spring Boot</description>

    <properties>
        <java.version>17</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
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

**Clase principal:**

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.literalura;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class LiteraluraApplication implements CommandLineRunner {

    public static void main(String[] args) {
        SpringApplication.run(LiteraluraApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        System.out.println("""
                \n==================================
                📚 LITERALURA - Catálogo de Libros
                ==================================
                Spring Boot funcionando correctamente.
                Versión Java: """ + System.getProperty("java.version"));
    }
}
```

**application.properties:**

```properties
spring.application.name=literalura
```

**👉 Tu turno:**

1. Crea un proyecto Maven con el pom.xml de arriba
2. Crea la clase `LiteraluraApplication` con `@SpringBootApplication` y `CommandLineRunner`
3. Haz que `run()` imprima la fecha actual, el nombre de la aplicación y "Sistema listo!"
4. Ejecuta la aplicación — debe verse algo como:

```
📚 LITERALURA - Catálogo de Libros
App: literalura
Fecha: 2026-06-04
Sistema listo!
```

---

## 🧪 Ejercicio 08-B: Inyección de Dependencias

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.literalura.service;

import org.springframework.stereotype.Component;

@Component
public class ConsumoAPI {
    public String obtenerDatos(String url) {
        return "Simulando llamada a: " + url;
    }
}
```

```java
package com.aluracursos.literalura.service;

import org.springframework.stereotype.Component;

@Component
public class ConversorDatos {
    public String convertir(String json) {
        return "Datos convertidos desde JSON";
    }
}
```

```java
// INYECCIÓN POR CONSTRUCTOR (RECOMENDADA)
package com.aluracursos.literalura.service;

import org.springframework.stereotype.Service;

@Service
public class LibroService {
    private final ConsumoAPI consumoAPI;
    private final ConversorDatos conversor;

    // Spring inyecta automáticamente las dependencias
    public LibroService(ConsumoAPI consumoAPI, ConversorDatos conversor) {
        this.consumoAPI = consumoAPI;
        this.conversor = conversor;
    }

    public void buscarLibro(String titulo) {
        String url = "https://gutendex.com/books/?search=" + titulo;
        String json = consumoAPI.obtenerDatos(url);
        String datos = conversor.convertir(json);
        System.out.println(datos);
    }
}
```

```java
package com.aluracursos.literalura;

import com.aluracursos.literalura.service.LibroService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class LiteraluraApplication implements CommandLineRunner {

    // Inyección por constructor también funciona aquí
    private final LibroService libroService;

    public LiteraluraApplication(LibroService libroService) {
        this.libroService = libroService;
    }

    public static void main(String[] args) {
        SpringApplication.run(LiteraluraApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        System.out.println("📚 Sistema listo!");
        libroService.buscarLibro("cien años de soledad");
    }
}
```

**👉 Tu turno:**

1. Crea `SaludoService` con `@Service` y un método `saludar(String nombre)` que devuelva "Hola [nombre], bienvenido a LiterAlura!"
2. Crea `MenuService` con `@Service` que tenga un método `mostrarOpciones()` que imprima un menú con 3 opciones
3. Inyecta AMBOS servicios en la clase principal (`CommandLineRunner`) por constructor
4. En `run()`, llama a `saludoService.saludar("Estudiante")` y después a `menuService.mostrarOpciones()`

---

## 🧪 Ejercicio 08-C: Inyección por @Autowired vs Constructor

```java
// === FORMA INCORRECTA (evitar) ===
@Service
public class MalEjemplo {
    @Autowired
    private ConsumoAPI consumoAPI;  // ❌ Inyección por campo

    @Autowired
    private ConversorDatos conversor; // ❌ Difícil de testear
}

// === FORMA RECOMENDADA (siempre) ===
@Service
public class BuenEjemplo {
    private final ConsumoAPI consumoAPI;   // final = inmutable
    private final ConversorDatos conversor;

    public BuenEjemplo(ConsumoAPI consumoAPI, ConversorDatos conversor) {
        this.consumoAPI = consumoAPI;
        this.conversor = conversor;
    }
}
```

```java
// === FORMA CON @Autowired EN CONSTRUCTOR (Java 4+) ===
@Service
public class OtroEjemplo {
    private ConsumoAPI consumoAPI;
    private ConversorDatos conversor;

    @Autowired  // Opcional desde Spring 4.3+
    public OtroEjemplo(ConsumoAPI consumoAPI, ConversorDatos conversor) {
        this.consumoAPI = consumoAPI;
        this.conversor = conversor;
    }
}
```

**👉 Tu turno:**

1. Refactoriza tu código del ejercicio anterior para usar siempre **inyección por constructor** con campos `private final`
2. Crea un `@Configuration` que defina un `@Bean` de tipo `Scanner` (para usar en toda la app):

```java
// PISTA: @Bean para Scanner
package com.aluracursos.literalura.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import java.util.Scanner;

@Configuration
public class AppConfig {
    @Bean
    public Scanner scanner() {
        return new Scanner(System.in);
    }
}
```

3. Usa el `Scanner` bean en un servicio para leer entrada del usuario

---

## ✅ Evaluación Módulo 08

- [ ] Ejercicio 08-A: @SpringBootApplication + CommandLineRunner funcionando
- [ ] Ejercicio 08-B: Inyección por constructor con 2 servicios
- [ ] Ejercicio 08-C: @Configuration con Scanner bean + refactor a inyección por constructor
- [ ] Todo subido a GitHub

> **Cuando termines, avísame para revisar ✅**
