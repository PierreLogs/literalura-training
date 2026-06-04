# Módulo 05: Manejo de Excepciones

> **Duración estimada:** 2-3 sesiones
> **Objetivo:** Dominar try-catch, finally, throws, excepciones personalizadas y buenas prácticas

## 📚 Conceptos a Aprender

| Concepto | Nivel | ¿Lo domino? |
|----------|-------|-------------|
| try-catch | ⭐⭐ Intermedio | ☐ |
| Multi-catch (Java 7+) | ⭐⭐ Intermedio | ☐ |
| finally | ⭐⭐ Intermedio | ☐ |
| try-with-resources | ⭐⭐⭐ Avanzado | ☐ |
| throws / throw | ⭐⭐ Intermedio | ☐ |
| Excepciones checked vs unchecked | ⭐⭐ Intermedio | ☐ |
| Excepciones personalizadas | ⭐⭐⭐ Avanzado | ☐ |

---

## 🧪 Ejercicio 05-A: Validaciones con try-catch

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos;

import java.util.InputMismatchException;
import java.util.Scanner;

public class ValidadorLibros {
    private static final Scanner sc = new Scanner(System.in);

    public static void main(String[] args) {
        try {
            System.out.print("Título: ");
            String titulo = sc.nextLine();

            System.out.print("Año de publicación: ");
            int anio = sc.nextInt();
            sc.nextLine();

            System.out.print("Número de páginas: ");
            int paginas = sc.nextInt();

            if (anio < -3000 || anio > 2026) {
                throw new IllegalArgumentException(
                        "Año inválido: " + anio + ". Debe estar entre -3000 y 2026");
            }
            if (paginas <= 0) {
                throw new IllegalArgumentException(
                        "Páginas inválidas: " + paginas + ". Debe ser mayor a 0");
            }

            System.out.println("✅ Libro registrado: " + titulo + " (" + anio + ")");

        } catch (InputMismatchException e) {
            System.out.println("❌ Error: Debes ingresar un número válido");
            sc.next(); // limpiar buffer
        } catch (IllegalArgumentException e) {
            System.out.println("❌ Error de validación: " + e.getMessage());
        } finally {
            System.out.println("--- Fin del registro ---");
        }
    }
}
```

**👉 Tu turno:**

Crea un programa que pida al usuario:
1. Nombre del autor (String, no vacío)
2. Año de nacimiento (int)
3. Año de fallecimiento (int, opcional)

Con validaciones:
- El nombre no puede estar vacío (si está vacío, lanza `IllegalArgumentException`)
- Año de nacimiento debe ser > 0
- Si ingresa año de fallecimiento, debe ser > año de nacimiento
- Usa multi-catch para `InputMismatchException | IllegalArgumentException`
- Usa `finally` para mostrar "Operación finalizada" siempre
- BONUS: Usa un bucle `while` para REPETIR hasta que los datos sean válidos

---

## 🧪 Ejercicio 05-B: Excepción Personalizada

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.exception;

public class LibroNoEncontradoException extends RuntimeException {
    private String tituloBuscado;

    public LibroNoEncontradoException(String tituloBuscado) {
        super("No se encontró el libro: " + tituloBuscado);
        this.tituloBuscado = tituloBuscado;
    }

    public LibroNoEncontradoException(String tituloBuscado, String mensaje) {
        super(mensaje);
        this.tituloBuscado = tituloBuscado;
    }

    public String getTituloBuscado() {
        return tituloBuscado;
    }
}
```

```java
package com.aluracursos.exception;

public class BibliotecaException extends Exception {
    // Esta es CHECKED (hereda de Exception, no de RuntimeException)

    public BibliotecaException(String mensaje) {
        super(mensaje);
    }

    public BibliotecaException(String mensaje, Throwable causa) {
        super(mensaje, causa);
    }
}
```

**👉 Tu turno:**

1. Crea `AutorNoEncontradoException` (extends RuntimeException) con:
   - Constructor que reciba el nombre del autor
   - Mensaje: "Autor no encontrado: [nombre]"
   - Método `getNombreAutor()` para obtener el nombre

2. Crea `ConexionBaseDatosException` (extends Exception, CHECKED) con:
   - Constructor con mensaje
   - Constructor con mensaje y causa (Throwable)

3. Crea una clase `BibliotecaService` que tenga un `ArrayList<Autor>` interno y métodos:
   - `buscarAutor(String nombre)` — lanza `AutorNoEncontradoException` si no existe
   - `conectarBaseDatos()` — lanza `ConexionBaseDatosException` (simula lanzarla con un `throw`)

4. En el main, captura y maneja ambas excepciones

---

## 🧪 Ejercicio 05-C: try-with-resources

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos;

import java.io.*;
import java.nio.file.*;
import java.util.*;

public class ArchivoLibros {

    public static void main(String[] args) {
        String archivo = "libros.txt";

        // Guardar libros en archivo
        guardarLibros(archivo, List.of(
                "Cien años de soledad|Gabriel García Márquez|1967",
                "1984|George Orwell|1949",
                "El principito|Antoine de Saint-Exupéry|1943"
        ));

        // Leer libros del archivo
        List<String> lineas = leerLibros(archivo);
        lineas.forEach(System.out::println);
    }

    public static void guardarLibros(String archivo, List<String> lineas) {
        // try-with-resources: cierra automáticamente el recurso
        try (BufferedWriter writer = Files.newBufferedWriter(
                Path.of(archivo), StandardOpenOption.CREATE)) {
            for (String linea : lineas) {
                writer.write(linea);
                writer.newLine();
            }
            System.out.println("✅ Archivo guardado");
        } catch (IOException e) {
            System.err.println("❌ Error al escribir: " + e.getMessage());
        }
    }

    public static List<String> leerLibros(String archivo) {
        try (BufferedReader reader = Files.newBufferedReader(Path.of(archivo))) {
            return reader.lines().toList();
        } catch (IOException e) {
            System.err.println("❌ Error al leer: " + e.getMessage());
            return List.of();
        }
    }
}
```

**👉 Tu turno:**

Crea una clase `GestorArchivosAutores` que:
1. Método `guardarAutores(List<Autor> autores, String archivo)` que guarde usando `try-with-resources` con `BufferedWriter` en formato CSV: `nombre|nacionalidad|anioNacimiento|anioFallecimiento`
2. Método `cargarAutores(String archivo)` que lea el archivo, convierta cada línea a un objeto `Autor`, y devuelva `List<Autor>`
   - Usa `try-with-resources` con `BufferedReader`
   - Maneja `IOException` y `NumberFormatException`
3. En el main, guarda 3 autores, cierra el programa, vuelve a abrirlo y carga los autores del archivo

---

## ✅ Evaluación Módulo 05

- [ ] Ejercicio 05-A: Validación con multi-catch y bucle de repetición
- [ ] Ejercicio 05-B: AutorNoEncontradoException + ConexionBaseDatosException
- [ ] Ejercicio 05-C: GestorArchivosAutores con try-with-resources
- [ ] Todo subido a GitHub

> **Cuando termines, avísame para revisar ✅**
