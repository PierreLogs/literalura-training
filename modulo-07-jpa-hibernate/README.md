# Módulo 07: JPA e Hibernate

> **Duración estimada:** 4-5 sesiones
> **Objetivo:** Dominar JPA, entidades, anotaciones, relaciones, JPQL, EntityManager

## 📚 Conceptos a Aprender

| Concepto | Nivel | ¿Lo domino? |
|----------|-------|-------------|
| @Entity, @Table, @Id, @GeneratedValue | ⭐⭐ Intermedio | ☐ |
| @Column, @Transient | ⭐⭐ Intermedio | ☐ |
| EntityManager, persist, find, remove | ⭐⭐⭐ Avanzado | ☐ |
| @ManyToOne, @OneToMany | ⭐⭐⭐ Avanzado | ☐ |
| @JoinColumn, mappedBy | ⭐⭐⭐ Avanzado | ☐ |
| CascadeType, FetchType | ⭐⭐⭐ Avanzado | ☐ |
| JPQL (Java Persistence Query Language) | ⭐⭐⭐ Avanzado | ☐ |
| Named Queries (@NamedQuery) | ⭐⭐⭐ Avanzado | ☐ |

---

## 🧪 Ejercicio 07-A: Configurar JPA con Hibernate

**pom.xml:**

```xml
<dependency>
    <groupId>org.hibernate.orm</groupId>
    <artifactId>hibernate-core</artifactId>
    <version>6.4.0.Final</version>
</dependency>
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>42.7.4</version>
</dependency>
<dependency>
    <groupId>jakarta.persistence</groupId>
    <artifactId>jakarta.persistence-api</artifactId>
    <version>3.1.0</version>
</dependency>
```

**resources/META-INF/persistence.xml:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence xmlns="https://jakarta.ee/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="https://jakarta.ee/xml/ns/persistence
             https://jakarta.ee/xml/ns/persistence/persistence_3_0.xsd"
             version="3.0">
    <persistence-unit name="literalura">
        <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
        <class>com.aluracursos.model.Autor</class>
        <class>com.aluracursos.model.Libro</class>
        <properties>
            <property name="jakarta.persistence.jdbc.url"
                      value="jdbc:postgresql://localhost:5432/literalura_db"/>
            <property name="jakarta.persistence.jdbc.user"
                      value="literalura_user"/>
            <property name="jakarta.persistence.jdbc.password"
                      value="literalura123"/>
            <property name="jakarta.persistence.jdbc.driver"
                      value="org.postgresql.Driver"/>
            <property name="hibernate.hbm2ddl.auto" value="update"/>
            <property name="hibernate.show_sql" value="true"/>
            <property name="hibernate.format_sql" value="true"/>
        </properties>
    </persistence-unit>
</persistence>
```

**Entidad Autor con JPA:**

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "autores")
public class Autor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String nombre;

    @Column(name = "anio_nacimiento")
    private Integer anioNacimiento;

    @Column(name = "anio_fallecimiento")
    private Integer anioFallecimiento;

    @OneToMany(mappedBy = "autor", cascade = CascadeType.ALL,
               fetch = FetchType.LAZY)
    private List<Libro> libros = List.of();

    public Autor() {}

    public Autor(String nombre, Integer anioNacimiento) {
        this.nombre = nombre;
        this.anioNacimiento = anioNacimiento;
    }

    // Getters y Setters...

    @Override
    public String toString() {
        return String.format("Autor: %s (%s - %s)", nombre,
                anioNacimiento != null ? anioNacimiento : "?",
                anioFallecimiento != null ? anioFallecimiento : "Presente");
    }
}
```

**Entidad Libro con JPA:**

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.model;

import jakarta.persistence.*;

@Entity
@Table(name = "libros")
public class Libro {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String titulo;

    private String idiomas;

    @Column(name = "numero_descargas")
    private Double numeroDescargas;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "autor_id")
    private Autor autor;

    public Libro() {}

    public Libro(String titulo, Autor autor) {
        this.titulo = titulo;
        this.autor = autor;
    }

    // Getters y Setters...

    @Override
    public String toString() {
        return String.format("""
                ----- LIBRO -----
                Título: %s
                Autor: %s
                -----------------""", titulo,
                autor != null ? autor.getNombre() : "Anónimo");
    }
}
```

**👉 Tu turno:**

1. Configura el `persistence.xml` en `src/main/resources/META-INF/`
2. Crea las entidades `Autor` y `Libro` exactamente como arriba
3. Crea la clase `Main` que:
   - Use `EntityManagerFactory` y `EntityManager`
   - Persista 2 autores con 2 libros cada uno
   - Use transacciones (`em.getTransaction().begin()`, `.commit()`)

```java
// PISTA: EntityManager básico
EntityManagerFactory emf = Persistence.createEntityManagerFactory("literalura");
EntityManager em = emf.createEntityManager();

em.getTransaction().begin();
Autor autor = new Autor("Gabriel García Márquez", 1927);
em.persist(autor);  // INSERT
em.getTransaction().commit();

em.close();
emf.close();
```

---

## 🧪 Ejercicio 07-B: Operaciones CRUD con EntityManager

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.database;

import com.aluracursos.model.*;
import jakarta.persistence.*;
import java.util.List;

public class AutorJPARepository {
    private EntityManagerFactory emf;
    private EntityManager em;

    public AutorJPARepository() {
        emf = Persistence.createEntityManagerFactory("literalura");
        em = emf.createEntityManager();
    }

    public void guardar(Autor autor) {
        em.getTransaction().begin();
        em.persist(autor);
        em.getTransaction().commit();
    }

    public Autor buscarPorId(Long id) {
        return em.find(Autor.class, id);
    }

    public List<Autor> listarTodos() {
        return em.createQuery("SELECT a FROM Autor a", Autor.class)
                 .getResultList();
    }

    public List<Autor> buscarPorNombre(String nombre) {
        return em.createQuery(
                "SELECT a FROM Autor a WHERE LOWER(a.nombre) LIKE LOWER(:nombre)",
                Autor.class)
                .setParameter("nombre", "%" + nombre + "%")
                .getResultList();
    }

    public void actualizar(Autor autor) {
        em.getTransaction().begin();
        em.merge(autor);
        em.getTransaction().commit();
    }

    public void eliminar(Long id) {
        em.getTransaction().begin();
        Autor autor = em.find(Autor.class, id);
        if (autor != null) {
            em.remove(autor);
        }
        em.getTransaction().commit();
    }

    public void cerrar() {
        em.close();
        emf.close();
    }
}
```

**👉 Tu turno:**

1. Crea `LibroJPARepository` similar con:
   - `guardar(Libro libro)`
   - `buscarPorTitulo(String titulo)` — JPQL
   - `listarTodos()`
   - `listarPorIdioma(String idioma)` — JPQL
   - `eliminar(Long id)`
2. Crea una clase `Main` que pruebe todas las operaciones

---

## 🧪 Ejercicio 07-C: JPQL Avanzado

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.database;

import com.aluracursos.model.*;
import jakarta.persistence.*;
import java.util.List;

public class ConsultasAvanzadas {

    public List<Autor> findAutoresVivosEnAnio(int anio) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("literalura");
        EntityManager em = emf.createEntityManager();

        String jpql = """
                SELECT a FROM Autor a
                WHERE a.anioNacimiento <= :anio
                AND (a.anioFallecimiento IS NULL OR a.anioFallecimiento >= :anio)
                """;

        List<Autor> autores = em.createQuery(jpql, Autor.class)
                .setParameter("anio", anio)
                .getResultList();

        em.close();
        emf.close();
        return autores;
    }

    public List<Object[]> contarLibrosPorAutor() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("literalura");
        EntityManager em = emf.createEntityManager();

        String jpql = """
                SELECT a.nombre, COUNT(l.id)
                FROM Autor a
                LEFT JOIN a.libros l
                GROUP BY a.nombre
                ORDER BY COUNT(l.id) DESC
                """;

        List<Object[]> resultados = em.createQuery(jpql, Object[].class)
                .getResultList();

        em.close();
        emf.close();
        return resultados;
    }

    public List<Libro> findTop10ByDescargas() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("literalura");
        EntityManager em = emf.createEntityManager();

        List<Libro> libros = em.createQuery(
                "SELECT l FROM Libro l ORDER BY l.numeroDescargas DESC",
                Libro.class)
                .setMaxResults(10)
                .getResultList();

        em.close();
        emf.close();
        return libros;
    }
}
```

**👉 Tu turno:**

1. Crea las 3 consultas del ejemplo en una clase `ReportesService`
2. Agrega una consulta que devuelva `DoubleSummaryStatistics` con estadísticas de descargas:
   - Pista: `SELECT AVG(l.numeroDescargas), MAX(l.numeroDescargas), MIN(l.numeroDescargas), COUNT(l) FROM Libro l`
   - Devuelve `Object[]` con los valores
3. Muestra resultados formateados en consola

---

## ✅ Evaluación Módulo 07

- [ ] Ejercicio 07-A: persistence.xml + entidades + persistencia básica
- [ ] Ejercicio 07-B: LibroJPARepository con CRUD completo
- [ ] Ejercicio 07-C: Consultas JPQL avanzadas (vivos, top 10, estadísticas)
- [ ] Todo subido a GitHub

> **Cuando termines, avísame para revisar ✅**
