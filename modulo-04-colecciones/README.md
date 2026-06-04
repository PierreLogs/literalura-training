# Módulo 04: Colecciones, Genéricos y Lambdas

> **Duración estimada:** 3-4 sesiones
> **Objetivo:** Dominar List, ArrayList, LinkedList, HashMap, HashSet, genéricos y lambdas

## 📚 Conceptos a Aprender

| Concepto | Nivel | ¿Lo domino? |
|----------|-------|-------------|
| ArrayList / LinkedList | ⭐⭐ Intermedio | ☐ |
| HashMap / HashSet | ⭐⭐ Intermedio | ☐ |
| for-each vs for-i | ⭐ Básico | ☐ |
| Genéricos <T> | ⭐⭐⭐ Avanzado | ☐ |
| Lambdas (() -> {}) | ⭐⭐⭐ Avanzado | ☐ |
| forEach con lambda | ⭐⭐ Intermedio | ☐ |
| Stream API básico | ⭐⭐⭐ Avanzado | ☐ |
| Optional | ⭐⭐⭐ Avanzado | ☐ |

---

## 🧪 Ejercicio 04-A: ArrayList y genéricos

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos;

import com.aluracursos.model.Libro;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class BibliotecaApp {
    private static List<Libro> libros = new ArrayList<>();
    private static Scanner sc = new Scanner(System.in);

    public static void main(String[] args) {
        // Agregar con método
        agregarLibro(new Libro("Cien años de soledad", "García Márquez", 1967));
        agregarLibro(new Libro("1984", "George Orwell", 1949));
        agregarLibro(new Libro("El principito", "Saint-Exupéry", 1943));

        System.out.println("Total: " + libros.size());
        listarLibros();

        // Buscar con lambda
        System.out.println("\n=== Buscar 'soledad' ===");
        buscarLibro("soledad");
    }

    public static void agregarLibro(Libro libro) {
        libros.add(libro);
        System.out.println("✅ Agregado: " + libro.getTitulo());
    }

    public static void listarLibros() {
        // forEach con lambda
        libros.forEach(l -> System.out.println(
                l.getTitulo() + " — " + l.getAutor()));
    }

    public static void buscarLibro(String termino) {
        // Stream + lambda + filter
        List<Libro> resultados = libros.stream()
                .filter(l -> l.getTitulo().toLowerCase().contains(termino.toLowerCase()))
                .toList(); // Java 16+: .collect(Collectors.toList()) en versiones anteriores

        if (resultados.isEmpty()) {
            System.out.println("❌ No encontrado");
        } else {
            resultados.forEach(System.out::println); // method reference
        }
    }
}
```

**👉 Tu turno — EJERCICIO INTEGRADOR:**

Crea un programa que:
1. Tenga un `ArrayList<Autor>` (usa tu clase Autor del Módulo 02)
2. Método `agregarAutor` que valide que no exista otro con el mismo nombre (usa `stream().anyMatch()`)
3. Método `listarAutores` con `forEach`
4. Método `buscarAutoresPorNacionalidad(String nacionalidad)` que use `stream().filter().toList()`
5. Método `eliminarAutor(String nombre)` que use `removeIf()` con lambda
6. Menú interactivo con switch mejorado

```java
// EJEMPLO de removeIf con lambda:
autores.removeIf(a -> a.getNombre().equalsIgnoreCase(nombre));

// EJEMPLO de anyMatch:
boolean existe = autores.stream()
        .anyMatch(a -> a.getNombre().equalsIgnoreCase(nombre));
```

---

## 🧪 Ejercicio 04-B: HashMap — Contador de Frecuencia

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos;

import java.util.*;

public class ContadorLibros {
    public static void main(String[] args) {
        // HashMap<Género, Cantidad>
        Map<String, Integer> librosPorGenero = new HashMap<>();

        // Agregar datos
        agregarGenero(librosPorGenero, "Ficción");
        agregarGenero(librosPorGenero, "Fantasía");
        agregarGenero(librosPorGenero, "Ficción");
        agregarGenero(librosPorGenero, "Historia");
        agregarGenero(librosPorGenero, "Ficción");
        agregarGenero(librosPorGenero, "Fantasía");

        System.out.println("\n=== LIBROS POR GÉNERO ===");
        // Recorrer Map con forEach(lambda)
        librosPorGenero.forEach((genero, cantidad) ->
                System.out.println(genero + ": " + cantidad + " libros")
        );

        // Obtener un valor
        System.out.println("\nFicción: " +
                librosPorGenero.getOrDefault("Ficción", 0) + " libros");

        System.out.println("Ciencia: " +
                librosPorGenero.getOrDefault("Ciencia", 0) + " libros");
    }

    public static void agregarGenero(Map<String, Integer> mapa, String genero) {
        // Si existe, incrementa; si no, pone 1
        mapa.put(genero, mapa.getOrDefault(genero, 0) + 1);
    }
}
```

**👉 Tu turno:**

Crea un `HashMap<String, List<Libro>>` llamado `librosPorGenero` donde:
1. La clave es el género (String)
2. El valor es una lista de libros de ese género
3. Método `agregarLibroAGenero(String genero, Libro libro)`:
   - Si el género no existe en el mapa, crea una nueva lista y agrega el libro
   - Si existe, solo agrega el libro a la lista existente
   - Usa `computeIfAbsent`
4. Método `listarPorGenero(String genero)` que muestre todos los libros de ese género
5. Método `estadisticas()` que muestre cuántos géneros hay y cuántos libros en total

```java
// PISTA: computeIfAbsent
mapa.computeIfAbsent(genero, k -> new ArrayList<>()).add(libro);
```

---

## 🧪 Ejercicio 04-C: Genéricos — Clase Repositorio Genérico

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.function.Predicate;

public class RepositorioGenerico<T> {
    private List<T> elementos = new ArrayList<>();

    public void guardar(T elemento) {
        elementos.add(elemento);
    }

    public List<T> listarTodos() {
        return new ArrayList<>(elementos); // copia defensiva
    }

    public Optional<T> buscar(Predicate<T> condicion) {
        return elementos.stream()
                .filter(condicion)
                .findFirst();
    }

    public List<T> filtrar(Predicate<T> condicion) {
        return elementos.stream()
                .filter(condicion)
                .toList();
    }

    public boolean eliminar(T elemento) {
        return elementos.remove(elemento);
    }

    public int contar() {
        return elementos.size();
    }
}
```

```java
// MAIN de prueba
package com.aluracursos;

import com.aluracursos.model.*;
import com.aluracursos.repository.RepositorioGenerico;

public class Main {
    public static void main(String[] args) {
        // Repositorio de Libros con genérico
        RepositorioGenerico<Libro> repoLibros = new RepositorioGenerico<>();
        repoLibros.guardar(new Libro("1984", "Orwell", 1949));
        repoLibros.guardar(new Libro("Dune", "Herbert", 1965));

        // Buscar con lambda (Predicate)
        repoLibros.buscar(l -> l.getTitulo().contains("1984"))
                .ifPresentOrElse(
                        l -> System.out.println("Encontrado: " + l),
                        () -> System.out.println("No encontrado")
                );

        // Repositorio de Autores
        RepositorioGenerico<Autor> repoAutores = new RepositorioGenerico<>();
        repoAutores.guardar(new Autor("Gabriel García Márquez",
                "Colombiana", 1927, 2014));
    }
}
```

**👉 Tu turno:**

1. Agrega un método `actualizar(Predicate<T> condicion, T nuevoElemento)` que:
   - Busque el primer elemento que cumpla la condición
   - Si existe, lo reemplaza con `nuevoElemento` y devuelve `true`
   - Si no, devuelve `false`
2. Agrega un método `listarOrdenado(Comparator<T>)` que devuelva la lista ordenada
   - Pista: `elementos.stream().sorted(comparador).toList()`
3. Prueba en el main:
   - Crea un `RepositorioGenerico<Libro>` con 5 libros
   - Filtra libros de un autor específico
   - Ordena por año de publicación
   - Actualiza el precio de un libro

---

## ✅ Evaluación Módulo 04

- [ ] Ejercicio 04-A: ArrayList de Autor con stream, anyMatch, removeIf
- [ ] Ejercicio 04-B: HashMap<String, List<Libro>> con computeIfAbsent
- [ ] Ejercicio 04-C: RepositorioGenerico<T> con actualizar y listarOrdenado
- [ ] Todo subido a GitHub

> **Cuando termines, avísame para revisar ✅**
