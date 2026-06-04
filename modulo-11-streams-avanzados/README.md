# Módulo 11: Streams Avanzados y Programación Funcional

> **Duración estimada:** 3-4 sesiones
> **Objetivo:** Dominar Stream API, Optional, method references, collectors, estadísticas

## 📚 Conceptos a Aprender

| Concepto | Nivel | ¿Lo domino? |
|----------|-------|-------------|
| Stream API (map, filter, reduce) | ⭐⭐⭐ Avanzado | ☐ |
| Optional / OptionalDouble | ⭐⭐⭐ Avanzado | ☐ |
| Method references (Clase::metodo) | ⭐⭐⭐ Avanzado | ☐ |
| Collectors (toList, groupingBy, partitioningBy) | ⭐⭐⭐ Avanzado | ☐ |
| DoubleSummaryStatistics | ⭐⭐ Intermedio | ☐ |
| flatMap | ⭐⭐⭐ Avanzado | ☐ |
| sorted con Comparator | ⭐⭐ Intermedio | ☐ |

---

## 🧪 Ejercicio 11-A: Streams con la base de datos

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.literalura.service;

import com.aluracursos.literalura.model.Libro;
import com.aluracursos.literalura.repository.LibroRepository;
import org.springframework.stereotype.Service;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class EstadisticaService {
    private final LibroRepository libroRepository;

    public EstadisticaService(LibroRepository libroRepository) {
        this.libroRepository = libroRepository;
    }

    // Obtener TODOS los libros y trabajar con Streams
    public DoubleSummaryStatistics estadisticasDescargas() {
        return libroRepository.findAll().stream()
                .filter(l -> l.getNumeroDescargas() != null)
                .mapToDouble(Libro::getNumeroDescargas)
                .summaryStatistics();
    }

    // Agrupar libros por idioma
    public Map<String, List<Libro>> agruparPorIdioma() {
        return libroRepository.findAll().stream()
                .collect(Collectors.groupingBy(Libro::getIdiomas));
    }

    // Top N libros por descargas
    public List<Libro> topNLibros(int n) {
        return libroRepository.findAll().stream()
                .sorted(Comparator.comparingDouble(Libro::getNumeroDescargas)
                        .reversed())
                .limit(n)
                .toList();
    }

    // Libros con más descargas que el promedio
    public List<Libro> librosSobrePromedio() {
        double promedio = estadisticasDescargas().getAverage();
        return libroRepository.findAll().stream()
                .filter(l -> l.getNumeroDescargas() != null
                        && l.getNumeroDescargas() > promedio)
                .toList();
    }

    // Total de descargas por idioma
    public Map<String, Double> totalDescargasPorIdioma() {
        return libroRepository.findAll().stream()
                .filter(l -> l.getNumeroDescargas() != null)
                .collect(Collectors.groupingBy(
                        Libro::getIdiomas,
                        Collectors.summingDouble(Libro::getNumeroDescargas)
                ));
    }

    // Obtener todos los nombres de autores (sin repetir)
    public List<String> todosLosAutores() {
        return libroRepository.findAll().stream()
                .map(l -> l.getAutor().getNombre())
                .distinct()
                .sorted()
                .toList();
    }
}
```

**👉 Tu turno:**

1. Crea `EstadisticaService` con los métodos del ejemplo
2. Crea un menú que muestre:
   - Opción: "Estadísticas de descargas" (promedio, max, min, count)
   - Opción: "Agrupar por idioma" (mapa con cantidad de libros por idioma)
   - Opción: "Libros sobre el promedio"
   - Opción: "Total descargas por idioma"

---

## 🧪 Ejercicio 11-B: Optional y operaciones funcionales

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.literalura.service;

import com.aluracursos.literalura.model.Libro;
import com.aluracursos.literalura.repository.LibroRepository;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class BusquedaService {
    private final LibroRepository libroRepository;

    public BusquedaService(LibroRepository libroRepository) {
        this.libroRepository = libroRepository;
    }

    // Buscar libro con Optional
    public Optional<Libro> buscarElMasDescargado() {
        return libroRepository.findAll().stream()
                .filter(l -> l.getNumeroDescargas() != null)
                .max(Comparator.comparingDouble(Libro::getNumeroDescargas));
    }

    public Optional<Libro> buscarLibroMasAntiguo() {
        return libroRepository.findAll().stream()
                .min(Comparator.comparing(Libro::getId));
    }

    public long contarLibrosConDescargas() {
        return libroRepository.findAll().stream()
                .filter(l -> l.getNumeroDescargas() != null && l.getNumeroDescargas() > 0)
                .count();
    }

    public boolean existeLibroConTitulo(String titulo) {
        return libroRepository.findAll().stream()
                .anyMatch(l -> l.getTitulo().equalsIgnoreCase(titulo));
    }

    public Optional<String> libroMasLargo() {
        return libroRepository.findAll().stream()
                .map(Libro::getTitulo)
                .max(Comparator.comparingInt(String::length));
    }

    public void mostrarEstadisticasDetalladas() {
        var stats = libroRepository.findAll().stream()
                .filter(l -> l.getNumeroDescargas() != null)
                .mapToDouble(Libro::getNumeroDescargas)
                .summaryStatistics();

        System.out.printf("""
                === ESTADÍSTICAS DETALLADAS ===
                Total libros: %d
                Promedio descargas: %.2f
                Máximo: %.0f
                Mínimo: %.0f
                Suma total: %.0f
                """, stats.getCount(), stats.getAverage(),
                stats.getMax(), stats.getMin(), stats.getSum());
    }
}
```

**👉 Tu turno:**

1. Crea los métodos del ejemplo en `BusquedaService`
2. Integra en el menú del Principal:
   - Opción: "Libro más descargado" con `ifPresentOrElse`
   - Opción: "Contar libros con descargas"
   - Opción: "Verificar si existe libro por título"

---

## 🧪 Ejercicio 11-C: flatMap, partitioningBy y reducers avanzados

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.literalura.service;

import com.aluracursos.literalura.model.*;
import com.aluracursos.literalura.repository.*;
import org.springframework.stereotype.Service;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ReportesAvanzadosService {
    private final LibroRepository libroRepository;
    private final AutorRepository autorRepository;

    public ReportesAvanzadosService(LibroRepository libroRepository,
                                    AutorRepository autorRepository) {
        this.libroRepository = libroRepository;
        this.autorRepository = autorRepository;
    }

    // flatMap: obtener todos los títulos de un autor (desde Autor -> libros)
    public List<String> titulosPorAutor(String nombreAutor) {
        return autorRepository.findByNombreContainsIgnoreCase(nombreAutor)
                .stream()
                .flatMap(autor -> autor.getLibros().stream())
                .map(Libro::getTitulo)
                .toList();
    }

    // partitioningBy: dividir libros en "muchas descargas" / "pocas descargas"
    public Map<Boolean, List<Libro>> partitioningPorDescargas(double umbral) {
        return libroRepository.findAll().stream()
                .collect(Collectors.partitioningBy(
                        l -> l.getNumeroDescargas() != null
                                && l.getNumeroDescargas() > umbral
                ));
    }

    // Map<String, Long>: contar libros por autor
    public Map<String, Long> contarLibrosPorAutor() {
        return libroRepository.findAll().stream()
                .collect(Collectors.groupingBy(
                        l -> l.getAutor().getNombre(),
                        Collectors.counting()
                ));
    }

    // Libro con más descargas de cada idioma
    public Map<String, Optional<Libro>> topPorIdioma() {
        return libroRepository.findAll().stream()
                .collect(Collectors.groupingBy(
                        Libro::getIdiomas,
                        Collectors.maxBy(
                                Comparator.comparingDouble(Libro::getNumeroDescargas)
                        )
                ));
    }

    // joining: lista de títulos formateada
    public String listarTitulosFormateados() {
        return libroRepository.findAll().stream()
                .map(Libro::getTitulo)
                .collect(Collectors.joining("\n  • ", "📚 Catálogo:\n  • ", ""));
    }
}
```

**👉 Tu turno:**

1. Crea `ReportesAvanzadosService` con todos los métodos del ejemplo
2. Agrega al menú:
   - "Títulos por autor" (usa flatMap)
   - "Libros con muchas vs pocas descargas" (partitioningBy)
   - "Contar libros por autor" (groupingBy + counting)
   - "Top por idioma" (groupingBy + maxBy)
   - "Catálogo formateado" (joining)

---

## ✅ Evaluación Módulo 11

- [ ] Ejercicio 11-A: EstadisticaService con groupingBy, sorting, summaryStatistics
- [ ] Ejercicio 11-B: BusquedaService con Optional, ifPresentOrElse, anyMatch
- [ ] Ejercicio 11-C: ReportesAvanzadosService con flatMap, partitioningBy, joining
- [ ] Todo subido a GitHub

> **Cuando termines, avísame para revisar ✅**
