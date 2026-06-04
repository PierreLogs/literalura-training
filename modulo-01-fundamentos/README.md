# Módulo 01: Fundamentos de Java — Lógica y Sintaxis

> **Duración estimada:** 3-4 sesiones
> **Objetivo:** Dominar variables, tipos, operadores, control de flujo, loops, arrays y métodos

## 📚 Conceptos a Aprender

| Concepto | Nivel | ¿Lo domino? |
|----------|-------|-------------|
| Variables y tipos (int, double, String, boolean) | ⭐ Básico | ☐ |
| Operadores (+, -, *, /, %, ==, !=, >, <) | ⭐ Básico | ☐ |
| if / else if / else | ⭐ Básico | ☐ |
| switch (tradicional y mejorado) | ⭐⭐ Intermedio | ☐ |
| for, while, do-while | ⭐ Básico | ☐ |
| Arrays unidimensionales | ⭐ Básico | ☐ |
| Métodos (parámetros, return) | ⭐⭐ Intermedio | ☐ |
| Scanner (entrada del usuario) | ⭐ Básico | ☐ |
| String métodos (length, substring, contains) | ⭐ Básico | ☐ |
| Text Blocks (""" """) | ⭐ Básico | ☐ |

---

## 🧪 Ejercicio 01-A: Calculadora de Descuentos

**Conceptos:** Variables, tipos, operadores, if, Scanner

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos;

import java.util.Scanner;

public class CalculadoraDescuentos {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Ingrese el precio del libro: ");
        double precio = scanner.nextDouble();

        System.out.print("Ingrese el número de unidades: ");
        int unidades = scanner.nextInt();

        double total = precio * unidades;
        double descuento = 0;

        if (unidades >= 10) {
            descuento = total * 0.15;  // 15% de descuento
        } else if (unidades >= 5) {
            descuento = total * 0.10;  // 10% de descuento
        } else if (unidades >= 3) {
            descuento = total * 0.05;  // 5% de descuento
        }

        double totalPagar = total - descuento;

        System.out.println("\n=== RESULTADO ===");
        System.out.println("Precio unitario: $" + precio);
        System.out.println("Unidades: " + unidades);
        System.out.println("Total sin descuento: $" + total);
        System.out.println("Descuento aplicado: $" + descuento);
        System.out.println("Total a pagar: $" + totalPagar);

        scanner.close();
    }
}
```

**👉 Tu turno:** Modifica el programa para que:
1. Pregunte si el cliente es "estudiante" (String)
2. Si es estudiante, aplique 5% ADICIONAL de descuento
3. Muestre el descuento total y el final

---

## 🧪 Ejercicio 01-B: Menú Interactivo con Switch

**Conceptos:** switch mejorado, while, text blocks, Scanner

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos;

import java.util.Scanner;

public class MenuBiblioteca {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int opcion;

        do {
            String menu = """
                    \n=== BIBLIOTECA DIGITAL ===
                    1- Buscar libro
                    2- Listar libros
                    3- Salir
                    Elija una opción:""";
            System.out.print(menu);
            opcion = scanner.nextInt();
            scanner.nextLine(); // limpiar buffer

            switch (opcion) {
                case 1 -> System.out.println("🔍 Buscando libro...");
                case 2 -> System.out.println("📚 Listando libros...");
                case 3 -> System.out.println("👋 ¡Hasta luego!");
                default -> System.out.println("❌ Opción inválida");
            }
        } while (opcion != 3);

        scanner.close();
    }
}
```

**👉 Tu turno:** Agrégale al menú las opciones:
- 4: "Estadísticas" (muestra un mensaje)
- 5: "Ayuda" (muestra un mensaje)
- Validar que el usuario no ingrese letras (try-catch básico)

---

## 🧪 Ejercicio 01-C: Arrays y Métodos

**Conceptos:** Arrays, métodos, for, length

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos;

public class GestorLibros {

    public static void main(String[] args) {
        String[] libros = {
            "Cien años de soledad",
            "Don Quijote",
            "La Odisea",
            "1984",
            "El principito"
        };

        mostrarTitulos(libros);
        System.out.println("\nTotal de libros: " + contarLibros(libros));
        System.out.println("Libro más largo: " + libroMasLargo(libros));
    }

    public static void mostrarTitulos(String[] libros) {
        System.out.println("=== CATÁLOGO ===");
        for (int i = 0; i < libros.length; i++) {
            System.out.println((i + 1) + ". " + libros[i]);
        }
    }

    public static int contarLibros(String[] libros) {
        return libros.length;
    }

    public static String libroMasLargo(String[] libros) {
        String masLargo = libros[0];
        for (String libro : libros) {
            if (libro.length() > masLargo.length()) {
                masLargo = libro;
            }
        }
        return masLargo;
    }
}
```

**👉 Tu turno:** Crea un método `buscarLibro(String[] libros, String termino)` que:
- Recorra el array con un for-each
- Si encuentra un libro que CONTENGA el término (usar `contains`), lo muestre
- Si no encuentra nada, muestre "Libro no encontrado"
- En el main, pide al usuario el término con Scanner

---

## 📝 Bitácora de Errores

Cada vez que tengas un error, documéntalo aquí:

| Fecha | Error | Causa | Solución |
|-------|-------|-------|----------|
| | | | |

---

## ✅ Evaluación Módulo 01

Para aprobar debes:

1. ✅ Ejercicio 01-A funcionando con descuento de estudiante
2. ✅ Ejercicio 01-B con menú extendido y validación
3. ✅ Ejercicio 01-C con método buscarLibro funcionando
4. ✅ Todos los códigos subidos a GitHub
5. ✅ Bitácora con al menos 2 errores documentados

> **Cuando termines los 3 ejercicios, avísame para revisar ✅**
