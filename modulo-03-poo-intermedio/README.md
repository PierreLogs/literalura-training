# Módulo 03: POO Intermedio — Herencia, Interfaces y Polimorfismo

> **Duración estimada:** 3-4 sesiones
> **Objetivo:** Dominar herencia, interfaces, polimorfismo y composición

## 📚 Conceptos a Aprender

| Concepto | Nivel | ¿Lo domino? |
|----------|-------|-------------|
| Herencia (extends) | ⭐⭐ Intermedio | ☐ |
| super() y super.metodo() | ⭐⭐ Intermedio | ☐ |
| @Override | ⭐⭐ Intermedio | ☐ |
| Clases abstractas (abstract) | ⭐⭐⭐ Avanzado | ☐ |
| Interfaces (implements) | ⭐⭐⭐ Avanzado | ☐ |
| Polimorfismo | ⭐⭐⭐ Avanzado | ☐ |
| Composición (tiene-un) | ⭐⭐ Intermedio | ☐ |
| Object como superclase | ⭐ Básico | ☐ |

---

## 🧪 Ejercicio 03-A: Herencia — Sistema de Usuarios

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.model;

import java.time.LocalDate;
import java.time.Period;

public class Usuario {
    protected int id;
    protected String nombre;
    protected String email;
    protected LocalDate fechaRegistro;

    public Usuario(int id, String nombre, String email) {
        this.id = id;
        this.nombre = nombre;
        this.email = email;
        this.fechaRegistro = LocalDate.now();
    }

    public int getId() { return id; }
    public String getNombre() { return nombre; }
    public String getEmail() { return email; }

    public int getDiasRegistrado() {
        return Period.between(fechaRegistro, LocalDate.now()).getDays();
    }

    // Método que las subclases pueden sobrescribir
    public String getRol() {
        return "Usuario";
    }

    @Override
    public String toString() {
        return String.format("%s (ID: %d, Email: %s) — %d días registrado",
                nombre, id, email, getDiasRegistrado());
    }
}
```

```java
package com.aluracursos.model;

public class UsuarioPremium extends Usuario {
    private String nivelSuscripcion; // "mensual", "anual", "vitalicio"
    private double descuentoEspecial;

    public UsuarioPremium(int id, String nombre, String email,
                          String nivelSuscripcion, double descuentoEspecial) {
        super(id, nombre, email); // llama al constructor de Usuario
        this.nivelSuscripcion = nivelSuscripcion;
        this.descuentoEspecial = descuentoEspecial;
    }

    public String getNivelSuscripcion() { return nivelSuscripcion; }

    @Override
    public String getRol() {
        return "Usuario Premium (" + nivelSuscripcion + ")";
    }

    public double aplicarDescuento(double precio) {
        return precio * (1 - descuentoEspecial / 100);
    }

    @Override
    public String toString() {
        return super.toString() + " | Rol: " + getRol() +
                " | Descuento: " + descuentoEspecial + "%";
    }
}
```

```java
// Clase para probar
package com.aluracursos;

import com.aluracursos.model.Usuario;
import com.aluracursos.model.UsuarioPremium;

public class Main {
    public static void main(String[] args) {
        Usuario normal = new Usuario(1, "Carlos López", "carlos@email.com");
        UsuarioPremium premium = new UsuarioPremium(2, "Ana García",
                "ana@email.com", "anual", 15);

        // POLIMORFISMO: misma referencia Usuario
        Usuario[] usuarios = { normal, premium };
        for (Usuario u : usuarios) {
            System.out.println(u);           // toString polimórfico
            System.out.println("Rol: " + u.getRol());  // getRol polimórfico
            System.out.println("---");
        }
    }
}
```

**👉 Tu turno:**
1. Crea la clase `UsuarioBibliotecario` que herede de `Usuario`
   - Atributo extra: `String biblioteca` (nombre de la biblioteca donde trabaja)
   - Atributo: `int anosExperiencia`
   - Sobrescribe `getRol()` para que devuelva "Bibliotecario en [biblioteca]"
   - Método extra: `boolean puedeGestionarCatalogos()` → true si anosExperiencia >= 2
2. En el main, crea un array de Usuario con los 3 tipos y muestra toString() y getRol() de cada uno

---

## 🧪 Ejercicio 03-B: Interfaces — Contrato de Servicios

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.service;

public interface IGestionCatalogos {
    void agregarLibro(String titulo, String autor, int anio);
    void listarLibros();
    String buscarLibro(String titulo);
    boolean eliminarLibro(int indice);
    int getCantidadLibros();
}
```

```java
package com.aluracursos.service;

import com.aluracursos.model.Libro;
import java.util.ArrayList;
import java.util.List;

public class CatalogoService implements IGestionCatalogos {
    private List<Libro> libros = new ArrayList<>();

    @Override
    public void agregarLibro(String titulo, String autor, int anio) {
        libros.add(new Libro(titulo, autor, anio));
    }

    @Override
    public void listarLibros() {
        if (libros.isEmpty()) {
            System.out.println("No hay libros");
            return;
        }
        for (int i = 0; i < libros.size(); i++) {
            System.out.println(i + ". " + libros.get(i).getTitulo());
        }
    }

    @Override
    public String buscarLibro(String titulo) {
        for (Libro l : libros) {
            if (l.getTitulo().equalsIgnoreCase(titulo)) {
                return l.toString();
            }
        }
        return "No encontrado";
    }

    @Override
    public boolean eliminarLibro(int indice) {
        if (indice >= 0 && indice < libros.size()) {
            libros.remove(indice);
            return true;
        }
        return false;
    }

    @Override
    public int getCantidadLibros() {
        return libros.size();
    }
}
```

**👉 Tu turno:**
1. Crea la interfaz `IGestionAutores` con métodos:
   - `void agregarAutor(String nombre, String nacionalidad, int anioNacimiento)`
   - `void listarAutores()`
   - `String buscarAutor(String nombre)`
   - `int getCantidadAutores()`
2. Crea la clase `AutorService` que implemente `IGestionAutores`
   - Usa `List<Autor>` internamente (usa la clase Autor que creaste en Módulo 02)
3. Crea un `Main` que instancie `CatalogoService` y `AutorService` y pruebe todas las operaciones

---

## 🧪 Ejercicio 03-C: Clase Abstracta — Publicación

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.model;

public abstract class Publicacion {
    protected String titulo;
    protected int anioPublicacion;
    protected String editorial;

    public Publicacion(String titulo, int anioPublicacion, String editorial) {
        this.titulo = titulo;
        this.anioPublicacion = anioPublicacion;
        this.editorial = editorial;
    }

    // Método abstracto: LAS SUBCLASES DEBEN IMPLEMENTARLO
    public abstract String getTipoPublicacion();

    // Método concreto: todas heredan
    public int getAntiguedad() {
        return java.time.LocalDate.now().getYear() - anioPublicacion;
    }

    public String getTitulo() { return titulo; }

    @Override
    public String toString() {
        return String.format("%s [%s, %d] — %d años de antigüedad",
                titulo, getTipoPublicacion(), anioPublicacion, getAntiguedad());
    }
}
```

```java
package com.aluracursos.model;

public class LibroFisico extends Publicacion {
    private int numeroPaginas;
    private double pesoGramos;

    public LibroFisico(String titulo, int anio, String editorial,
                       int paginas, double peso) {
        super(titulo, anio, editorial);
        this.numeroPaginas = paginas;
        this.pesoGramos = peso;
    }

    @Override
    public String getTipoPublicacion() {
        return "Libro Físico";
    }
}
```

```java
package com.aluracursos.model;

public class Audiolibro extends Publicacion {
    private double duracionMinutos;
    private String narrador;

    public Audiolibro(String titulo, int anio, String editorial,
                      double duracion, String narrador) {
        super(titulo, anio, editorial);
        this.duracionMinutos = duracion;
        this.narrador = narrador;
    }

    @Override
    public String getTipoPublicacion() {
        return "Audiolibro";
    }
}
```

**👉 Tu turno:**
1. Crea la clase `Revista` que herede de `Publicacion`
   - Atributos: `int numeroEdicion`, `String periodicidad` ("mensual", "trimestral", "anual")
   - Implementa `getTipoPublicacion()` → "Revista"
2. En el main, crea un `ArrayList<Publicacion>` con un libro, un audiolibro y una revista
3. Recorre la lista con un for-each mostrando toString() de cada uno

---

## ✅ Evaluación Módulo 03

- [ ] Ejercicio 03-A: UsuarioBibliotecario con herencia, super, polimorfismo
- [ ] Ejercicio 03-B: IGestionAutores + AutorService implementando interfaz
- [ ] Ejercicio 03-C: Revista + ArrayList de Publicacion con polimorfismo
- [ ] Todo subido a GitHub

> **Cuando termines, avísame para revisar ✅**
