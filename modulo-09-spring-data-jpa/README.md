# Módulo 09: Spring Data JPA

> **Duración estimada:** 4-5 sesiones
> **Objetivo:** Dominar Spring Data JPA, repositorios, derived queries, @Query, Specifications

## 📚 Conceptos a Aprender

| Concepto | Nivel | ¿Lo domino? |
|----------|-------|-------------|
| spring-boot-starter-data-jpa | ⭐⭐ Intermedio | ☐ |
| JpaRepository<T, ID> | ⭐⭐ Intermedio | ☐ |
| Derived query methods | ⭐⭐ Intermedio | ☐ |
| @Query (JPQL y native) | ⭐⭐⭐ Avanzado | ☐ |
| @Modifying + @Transactional | ⭐⭐⭐ Avanzado | ☐ |
| Pageable / Sort | ⭐⭐⭐ Avanzado | ☐ |
| @EntityGraph (evitar N+1) | ⭐⭐⭐ Avanzado | ☐ |

---

## 🧪 Ejercicio 09-A: Spring Data JPA + Repositorios

**pom.xml (agregar):**

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

**application.properties:**

```properties
spring.application.name=literalura
spring.datasource.url=jdbc:postgresql://localhost:5432/literalura_db
spring.datasource.username=literalura_user
spring.datasource.password=literalura123
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
```

**Entidades (con anotaciones JPA):**

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.literalura.model;

import jakarta.persistence.*;

@Entity
@Table(name = "autores")
public class Autor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String nombre;

    private Integer anioNacimiento;
    private Integer anioFallecimiento;

    @OneToMany(mappedBy = "autor", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private java.util.List<Libro> libros = new java.util.ArrayList<>();

    public Autor() {}
    public Autor(String nombre, Integer anioNacimiento) {
        this.nombre = nombre;
        this.anioNacimiento = anioNacimiento;
    }

    // Getters y Setters...
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public Integer getAnioNacimiento() { return anioNacimiento; }
    public void setAnioNacimiento(Integer anioNacimiento) { this.anioNacimiento = anioNacimiento; }
    public Integer getAnioFallecimiento() { return anioFallecimiento; }
    public void setAnioFallecimiento(Integer anioFallecimiento) { this.anioFallecimiento = anioFallecimiento; }
    public java.util.List<Libro> getLibros() { return libros; }
    public void setLibros(java.util.List<Libro> libros) { this.libros = libros; }

    @Override
    public String toString() {
        return String.format("Autor: %s (%s - %s)", nombre,
                anioNacimiento != null ? anioNacimiento : "?",
                anioFallecimiento != null ? anioFallecimiento : "Presente");
    }
}
```

```java
package com.aluracursos.literalura.model;

import jakarta.persistence.*;

@Entity
@Table(name = "libros")
public class Libro {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private String titulo;

    private String idiomas;
    private Double numeroDescargas;

    @ManyToOne
    @JoinColumn(name = "autor_id")
    private Autor autor;

    public Libro() {}
    public Libro(String titulo, Autor autor) {
        this.titulo = titulo;
        this.autor = autor;
    }

    // Getters y Setters...
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    public String getIdiomas() { return idiomas; }
    public void setIdiomas(String idiomas) { this.idiomas = idiomas; }
    public Double getNumeroDescargas() { return numeroDescargas; }
    public void setNumeroDescargas(Double numeroDescargas) { this.numeroDescargas = numeroDescargas; }
    public Autor getAutor() { return autor; }
    public void setAutor(Autor autor) { this.autor = autor; }

    @Override
    public String toString() {
        return String.format("""
                ----- LIBRO -----
                Título: %s
                Autor: %s
                Idioma: %s
                Descargas: %.0f
                -----------------""",
                titulo, autor != null ? autor.getNombre() : "Anónimo",
                idiomas, numeroDescargas);
    }
}
```

**Repositorios:**

```java
package com.aluracursos.literalura.repository;

import com.aluracursos.literalura.model.Autor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface AutorRepository extends JpaRepository<Autor, Long> {

    // Derived query methods
    List<Autor> findByNombreContainsIgnoreCase(String nombre);

    @Query("SELECT a FROM Autor a WHERE a.anioNacimiento <= :anio AND " +
           "(a.anioFallecimiento IS NULL OR a.anioFallecimiento >= :anio)")
    List<Autor> findAutoresVivosEnDeterminadoAnio(int anio);

    List<Autor> findAllByOrderByNombreAsc();
}
```

```java
package com.aluracursos.literalura.repository;

import com.aluracursos.literalura.model.Libro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface LibroRepository extends JpaRepository<Libro, Long> {

    // Derived queries
    List<Libro> findByIdiomas(String idioma);

    List<Libro> findTop10ByOrderByNumeroDescargasDesc();

    List<Libro> findByAutorNombreContainsIgnoreCase(String nombreAutor);
}
```

**👉 Tu turno:**

1. Configura el pom.xml con `spring-boot-starter-data-jpa` y `postgresql`
2. Configura `application.properties` con tus credenciales
3. Crea las entidades `Autor` y `Libro` con todas las anotaciones JPA
4. Crea `AutorRepository` y `LibroRepository`
5. Crea un `CommandLineRunner` que:
   - Inyecte ambos repositorios por constructor
   - Guarde 2 autores y 3 libros
   - Liste todos los libros con `findAll()`
   - Busque libros por idioma

---

## 🧪 Ejercicio 09-B: Servicios con Spring Data JPA

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.literalura.service;

import com.aluracursos.literalura.model.Libro;
import com.aluracursos.literalura.repository.LibroRepository;
import org.springframework.stereotype.Service;
import java.util.DoubleSummaryStatistics;
import java.util.List;

@Service
public class LibroService {
    private final LibroRepository libroRepository;

    public LibroService(LibroRepository libroRepository) {
        this.libroRepository = libroRepository;
    }

    public List<Libro> obtenerTodosLosLibros() {
        return libroRepository.findAll();
    }

    public List<Libro> listarLibrosPorIdioma(String idioma) {
        return libroRepository.findByIdiomas(idioma);
    }

    public List<Libro> obtenerTop10Libros() {
        return libroRepository.findTop10ByOrderByNumeroDescargasDesc();
    }

    public DoubleSummaryStatistics obtenerEstadisticasDescargas() {
        return libroRepository.findAll().stream()
                .filter(l -> l.getNumeroDescargas() != null && l.getNumeroDescargas() > 0)
                .mapToDouble(Libro::getNumeroDescargas)
                .summaryStatistics();
    }

    public long contarLibros() {
        return libroRepository.count();
    }
}
```

**👉 Tu turno:**

1. Crea `AutorService` con métodos:
   - `obtenerAutores()` → findAll
   - `obtenerAutoresVivosEnAnio(int anio)` → query @Query
   - `buscarPorNombre(String nombre)` → derived query
   - `contarAutores()` → count
2. Crea una clase `Principal` (sin anotación, plain Java) que reciba `LibroService` y `AutorService` por constructor
   - Con un método `mostrarMenu()` con while y switch
   - Opciones: 1. Listar libros, 2. Listar autores, 3. Autores vivos en año, 4. Top 10, 5. Estadísticas, 0. Salir
3. En el `CommandLineRunner`, crea `Principal` e inicia el menú

---

## 🧪 Ejercicio 09-C: Consultas avanzadas con @Query

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.literalura.repository;

import com.aluracursos.literalura.model.Libro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface LibroRepository extends JpaRepository<Libro, Long> {

    // Derived queries (ya existen)
    List<Libro> findByIdiomas(String idioma);
    List<Libro> findTop10ByOrderByNumeroDescargasDesc();

    // JPQL query
    @Query("SELECT l FROM Libro l WHERE LOWER(l.titulo) LIKE LOWER(CONCAT('%', :termino, '%'))")
    List<Libro> buscarPorTitulo(@Param("termino") String termino);

    // Native query (SQL puro)
    @Query(value = "SELECT * FROM libros l JOIN autores a ON l.autor_id = a.id " +
                   "WHERE a.nombre ILIKE CONCAT('%', :nombre, '%')",
           nativeQuery = true)
    List<Libro> buscarPorNombreAutor(@Param("nombre") String nombre);

    // Estadísticas con JPQL
    @Query("SELECT AVG(l.numeroDescargas), MAX(l.numeroDescargas), " +
           "MIN(l.numeroDescargas), COUNT(l) FROM Libro l")
    Object[] obtenerEstadisticasDescargas();
}
```

**👉 Tu turno:**

1. Agrega estos métodos al `LibroRepository`:
   - `@Query("SELECT l FROM Libro l ORDER BY l.numeroDescargas DESC")` — `listarTodosOrdenados()`
   - `@Query("SELECT l FROM Libro l WHERE l.idiomas = :idioma ORDER BY l.numeroDescargas DESC")` — `topPorIdioma(@Param("idioma") String idioma)`
2. Agrega al `AutorRepository`:
   - `@Query("SELECT a FROM Autor a LEFT JOIN FETCH a.libros")` — `listarAutoresConLibros()` (evita N+1)
   - `@Query("SELECT a FROM Autor a WHERE a.anioFallecimiento IS NULL")` — `autoresVivos()`
3. Prueba todas las consultas desde el menú principal

---

## ✅ Evaluación Módulo 09

- [ ] Ejercicio 09-A: Entidades + repositorios + persistencia inicial en CommandLineRunner
- [ ] Ejercicio 09-B: LibroService + AutorService + Principal con menú funcionando
- [ ] Ejercicio 09-C: @Query avanzadas (búsqueda, estadísticas, FETCH JOIN)
- [ ] Todo subido a GitHub

> **Cuando termines, avísame para revisar ✅**
