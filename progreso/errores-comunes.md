# 🐛 Bitácora de Errores

> Anota aquí cada error que encuentres para aprender de él.

## Formato

```
## [YYYY-MM-DD] Error: [Título breve]
- **Módulo:** [N/A si no aplica]
- **Código donde ocurrió:**
  ```java
  // Código con error
  ```
- **Mensaje de error:**
  ```
  Exception in thread "main" java.lang.NullPointerException...
  ```
- **Causa:**
  [Qué lo provocó]
- **Solución:**
  [Cómo lo solucionaste]
- **Aprendizaje:**
  [Qué aprendiste para no repetirlo]
```

---

<!-- EJEMPLO:
## [2026-06-04] Error: NullPointerException al llamar a getNombre()
- **Módulo:** 02-poo-basico
- **Código donde ocurrió:**
  ```java
  System.out.println(libro.getAutor().getNombre());
  ```
- **Mensaje de error:**
  ```
  Exception in thread "main" java.lang.NullPointerException
  ```
- **Causa:**
  El libro no tenía un autor asignado (null), y llamé a getNombre() sobre null.
- **Solución:**
  Validar con if (libro.getAutor() != null) antes de llamar a getNombre().
- **Aprendizaje:**
  Siempre verificar que los objetos no sean null antes de acceder a sus métodos.
-->
