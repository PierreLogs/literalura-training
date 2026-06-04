# Módulo 02: Programación Orientada a Objetos — Básico

> **Duración estimada:** 3-4 sesiones
> **Objetivo:** Dominar clases, objetos, encapsulamiento, constructores y toString

## 📚 Conceptos a Aprender

| Concepto | Nivel | ¿Lo domino? |
|----------|-------|-------------|
| Clases y objetos (new) | ⭐ Básico | ☐ |
| Atributos (private) | ⭐ Básico | ☐ |
| Métodos (public) | ⭐ Básico | ☐ |
| Encapsulamiento (getters/setters) | ⭐⭐ Intermedio | ☐ |
| Constructores (default y parametrizado) | ⭐⭐ Intermedio | ☐ |
| this | ⭐⭐ Intermedio | ☐ |
| toString() | ⭐ Básico | ☐ |
| static | ⭐⭐ Intermedio | ☐ |
| this vs static | ⭐⭐ Intermedio | ☐ |

---

## 🧪 Ejercicio 02-A: Clase Libro

**Conceptos:** Clase, atributos, constructor, getters/setters, toString

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.model;

public class Libro {
    private String titulo;
    private String autor;
    private int anioPublicacion;
    private double precio;
    private int numeroPaginas;

    // Constructor vacío
    public Libro() {}

    // Constructor con parámetros
    public Libro(String titulo, String autor, int anioPublicacion) {
        this.titulo = titulo;
        this.autor = autor;
        this.anioPublicacion = anioPublicacion;
    }

    // Getters y Setters
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getAutor() { return autor; }
    public void setAutor(String autor) { this.autor = autor; }

    public int getAnioPublicacion() { return anioPublicacion; }
    public void setAnioPublicacion(int anioPublicacion) {
        if (anioPublicacion > 0) {
            this.anioPublicacion = anioPublicacion;
        }
    }

    public double getPrecio() { return precio; }
    public void setPrecio(double precio) {
        if (precio >= 0) {
            this.precio = precio;
        }
    }

    public int getNumeroPaginas() { return numeroPaginas; }
    public void setNumeroPaginas(int numeroPaginas) {
        if (numeroPaginas > 0) {
            this.numeroPaginas = numeroPaginas;
        }
    }

    @Override
    public String toString() {
        return String.format("""
                ----- LIBRO -----
                Título: %s
                Autor: %s
                Año: %d
                Precio: $%.2f
                Páginas: %d
                -----------------""",
                titulo, autor, anioPublicacion, precio, numeroPaginas);
    }
}
```

```java
// === CLASE PRINCIPAL PARA PROBAR ===
package com.aluracursos;

import com.aluracursos.model.Libro;

public class Main {
    public static void main(String[] args) {
        Libro libro1 = new Libro("Cien años de soledad", "Gabriel García Márquez", 1967);
        libro1.setPrecio(250.50);
        libro1.setNumeroPaginas(471);

        Libro libro2 = new Libro();
        libro2.setTitulo("1984");
        libro2.setAutor("George Orwell");
        libro2.setAnioPublicacion(1949);
        libro2.setPrecio(180.00);
        libro2.setNumeroPaginas(328);

        System.out.println(libro1);
        System.out.println(libro2);
    }
}
```

**👉 Tu turno:** Crea la clase `Autor` con:
- `id` (int), `nombre` (String), `nacionalidad` (String), `anioNacimiento` (int), `anioFallecimiento` (Integer, puede ser null si vive)
- Constructor con todos los campos
- Getters/Setters con validación (año nacimiento > 0, año fallecimiento > año nacimiento)
- toString() que muestre "Autor: Gabriel García Márquez (1927 - 2014)" y si está vivo "Autor: Isabel Allende (1942 - Presente)"

---

## 🧪 Ejercicio 02-B: Clase Calculadora

**Conceptos:** Métodos estáticos, sobrecarga de métodos

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.util;

public class CalculadoraLibros {

    // Método estático: sin crear instancia
    public static double calcularDescuento(double precio, int unidades) {
        double descuento = 0;
        if (unidades >= 10) descuento = 0.15;
        else if (unidades >= 5) descuento = 0.10;
        else if (unidades >= 3) descuento = 0.05;
        return precio * unidades * (1 - descuento);
    }

    // Sobrecarga: misma firma, diferentes parámetros
    public static double calcularDescuento(double precio, int unidades, boolean esEstudiante) {
        double total = calcularDescuento(precio, unidades);
        if (esEstudiante) {
            total *= 0.95; // 5% extra
        }
        return total;
    }

    // Otra sobrecarga: para precio con IVA incluido
    public static double calcularPrecioConIva(double precio, double ivaPorcentaje) {
        return precio * (1 + ivaPorcentaje / 100);
    }
}
```

**👉 Tu turno:**
1. Crea la clase `UtilidadesLibros` con estos métodos estáticos:
   - `esLibroLargo(int paginas)` → true si > 400
   - `esLibroAntiguo(int anio)` → true si < 1950
   - `recomendarLibro(String genero)` → devuelve un String con recomendación según género ("ficción", "fantasía", "historia", etc.) usando switch mejorado
2. En el main, prueba todos los métodos

---

## 🧪 Ejercicio 02-C: Catálogo de Libros (POO + Arrays)

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos;

import com.aluracursos.model.Libro;
import java.util.Scanner;

public class CatalogoApp {
    private static final Scanner scanner = new Scanner(System.in);
    private static Libro[] catalogo = new Libro[10];
    private static int contador = 0;

    public static void main(String[] args) {
        int opcion;
        do {
            System.out.print("""
                    \n=== CATÁLOGO DE LIBROS ===
                    1- Agregar libro
                    2- Listar libros
                    3- Buscar por título
                    4- Salir
                    Opción:\s""");
            opcion = scanner.nextInt();
            scanner.nextLine();

            switch (opcion) {
                case 1 -> agregarLibro();
                case 2 -> listarLibros();
                case 3 -> buscarPorTitulo();
                case 4 -> System.out.println("👋 Hasta luego!");
                default -> System.out.println("❌ Opción inválida");
            }
        } while (opcion != 4);
    }

    public static void agregarLibro() {
        if (contador >= catalogo.length) {
            System.out.println("❌ Catálogo lleno");
            return;
        }
        System.out.print("Título: ");
        String titulo = scanner.nextLine();
        System.out.print("Autor: ");
        String autor = scanner.nextLine();
        System.out.print("Año: ");
        int anio = scanner.nextInt();
        scanner.nextLine();

        catalogo[contador] = new Libro(titulo, autor, anio);
        contador++;
        System.out.println("✅ Libro agregado");
    }

    public static void listarLibros() {
        if (contador == 0) {
            System.out.println("📭 No hay libros");
            return;
        }
        for (int i = 0; i < contador; i++) {
            System.out.println((i + 1) + ". " + catalogo[i].getTitulo() +
                    " - " + catalogo[i].getAutor());
        }
    }

    public static void buscarPorTitulo() {
        System.out.print("Buscar: ");
        String termino = scanner.nextLine().toLowerCase();
        boolean encontrado = false;
        for (int i = 0; i < contador; i++) {
            if (catalogo[i].getTitulo().toLowerCase().contains(termino)) {
                System.out.println(catalogo[i]);
                encontrado = true;
            }
        }
        if (!encontrado) System.out.println("❌ No encontrado");
    }
}
```

**👉 Tu turno:** Modifica el programa para:
1. Agregar libres: en vez de array fijo, usa `ArrayList<Libro>` (solo importa java.util.ArrayList)
2. Agregar opción "Eliminar libro" (busca por índice y elimina)
3. Agregar opción "Libros por autor"

---

## ✅ Evaluación Módulo 02

- [ ] Ejercicio 02-A: Clase Autor completa con validaciones
- [ ] Ejercicio 02-B: UtilidadesLibros con métodos estáticos
- [ ] Ejercicio 02-C: Catálogo con ArrayList y opción eliminar
- [ ] Todo subido a GitHub

> **Cuando termines, avísame para revisar ✅**
