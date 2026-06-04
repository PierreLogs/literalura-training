# Módulo 06: Bases de Datos con JDBC

> **Duración estimada:** 4-5 sesiones
> **Objetivo:** Dominar JDBC, conexión a PostgreSQL, CRUD, PreparedStatement, transacciones

## 📚 Conceptos a Aprender

| Concepto | Nivel | ¿Lo domino? |
|----------|-------|-------------|
| SQL básico (SELECT, INSERT, UPDATE, DELETE) | ⭐⭐ Intermedio | ☐ |
| Driver JDBC y Connection | ⭐⭐ Intermedio | ☐ |
| Statement vs PreparedStatement | ⭐⭐ Intermedio | ☐ |
| ResultSet | ⭐⭐ Intermedio | ☐ |
| CRUD completo | ⭐⭐⭐ Avanzado | ☐ |
| Transacciones (commit/rollback) | ⭐⭐⭐ Avanzado | ☐ |
| Pool de conexiones (HikariCP) | ⭐⭐⭐ Avanzado | ☐ |

> **⚠️ Requisito:** Tener PostgreSQL instalado y funcionando (Módulo 00)

---

## 🧪 Ejercicio 06-A: Conexión a PostgreSQL + CRUD básico

```java
// === CÓDIGO EJEMPLO (guía) ===
// 1. AGREGAR DEPENDENCIA AL pom.xml
/*
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>42.7.4</version>
</dependency>
*/
```

```sql
-- 2. CREAR LA TABLA EN PostgreSQL
CREATE TABLE autores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(200) UNIQUE NOT NULL,
    nacionalidad VARCHAR(100),
    anio_nacimiento INTEGER,
    anio_fallecimiento INTEGER
);

CREATE TABLE libros (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(300) UNIQUE NOT NULL,
    autor_id INTEGER REFERENCES autores(id),
    idioma VARCHAR(10),
    numero_descargas DOUBLE PRECISION
);
```

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.database;

import java.sql.*;

public class ConexionBD {
    private static final String URL = "jdbc:postgresql://localhost:5432/literalura_db";
    private static final String USER = "literalura_user";
    private static final String PASSWORD = "literalura123";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void main(String[] args) {
        String sql = "SELECT id, nombre, anio_nacimiento, anio_fallecimiento FROM autores";

        // try-with-resources: Connection, Statement, ResultSet
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            System.out.println("✅ Conectado a PostgreSQL");
            System.out.println("\n=== AUTORES ===");

            while (rs.next()) {
                int id = rs.getInt("id");
                String nombre = rs.getString("nombre");
                int nacimiento = rs.getInt("anio_nacimiento");
                int fallecimiento = rs.getInt("anio_fallecimiento");
                // rs.getInt devuelve 0 si es NULL — usamos getObject para Integer

                Integer fallecimientoObj = rs.getObject("anio_fallecimiento", Integer.class);
                String fallecimientoStr = (fallecimientoObj != null)
                        ? String.valueOf(fallecimientoObj) : "Presente";

                System.out.printf("%d. %s (%d - %s)%n", id, nombre, nacimiento, fallecimientoStr);
            }

        } catch (SQLException e) {
            System.err.println("❌ Error de conexión: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
```

**👉 Tu turno:**

Crea la clase `LibroDAO` (Data Access Object) con:
1. Método `insertar(Libro libro)` — usa `PreparedStatement` con `INSERT INTO libros (titulo, autor_id, idioma, numero_descargas) VALUES (?, ?, ?, ?)`
2. Método `buscarPorId(int id)` — devuelve un `Optional<Libro>`
3. Método `listarTodos()` — devuelve `List<Libro>`
4. Método `actualizar(Libro libro)` — UPDATE
5. Método `eliminar(int id)` — DELETE

```java
// PISTA: PreparedStatement
String sql = "INSERT INTO autores (nombre, nacionalidad, anio_nacimiento, anio_fallecimiento) VALUES (?, ?, ?, ?)";
try (Connection conn = ConexionBD.getConnection();
     PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

    pstmt.setString(1, autor.getNombre());
    pstmt.setString(2, autor.getNacionalidad());
    pstmt.setInt(3, autor.getAnioNacimiento());
    if (autor.getAnioFallecimiento() != null) {
        pstmt.setInt(4, autor.getAnioFallecimiento());
    } else {
        pstmt.setNull(4, Types.INTEGER);
    }
    pstmt.executeUpdate();

    // Obtener el ID generado
    ResultSet rs = pstmt.getGeneratedKeys();
    if (rs.next()) {
        autor.setId(rs.getInt(1));
    }
}
```

---

## 🧪 Ejercicio 06-B: Transacciones

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.database;

import java.sql.*;

public class TransaccionEjemplo {

    public void registrarLibroConAutor(String tituloLibro, String nombreAutor,
                                       int anioNacimiento, String idioma,
                                       double descargas) throws SQLException {

        String sqlAutor = "INSERT INTO autores (nombre, anio_nacimiento) VALUES (?, ?)";
        String sqlLibro = "INSERT INTO libros (titulo, autor_id, idioma, numero_descargas) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = ConexionBD.getConnection();
            conn.setAutoCommit(false); // INICIAR TRANSACCIÓN

            // 1. Insertar autor
            int autorId;
            try (PreparedStatement pstmt = conn.prepareStatement(sqlAutor, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setString(1, nombreAutor);
                pstmt.setInt(2, anioNacimiento);
                pstmt.executeUpdate();

                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    autorId = rs.getInt(1);
                } else {
                    throw new SQLException("No se pudo obtener el ID del autor");
                }
            }

            // 2. Insertar libro (con el autor_id obtenido)
            try (PreparedStatement pstmt = conn.prepareStatement(sqlLibro)) {
                pstmt.setString(1, tituloLibro);
                pstmt.setInt(2, autorId);
                pstmt.setString(3, idioma);
                pstmt.setDouble(4, descargas);
                pstmt.executeUpdate();
            }

            conn.commit(); // ✅ CONFIRMAR TRANSACCIÓN
            System.out.println("✅ Libro y autor registrados exitosamente");

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // ❌ REVERTIR CAMBIOS
                    System.out.println("❌ Error. Transacción revertida.");
                } catch (SQLException ex) {
                    System.err.println("Error en rollback: " + ex.getMessage());
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
}
```

**👉 Tu turno:**

1. Crea un método `buscarYGuardarLibroConAutor(String titulo, String nombreAutor, String idioma, double descargas)` que:
   - Primero busque si el autor existe en BD (SELECT por nombre)
   - Si no existe, lo inserte
   - Luego inserte el libro
   - Todo dentro de una transacción con `commit` y `rollback`
2. Prueba forzando un error (ej: libro sin título) y verifica que el autor no se guarde

---

## 🧪 Ejercicio 06-C: Pool de Conexiones con HikariCP

**Agregar al pom.xml:**

```xml
<dependency>
    <groupId>com.zaxxer</groupId>
    <artifactId>HikariCP</artifactId>
    <version>5.1.0</version>
</dependency>
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-simple</artifactId>
    <version>2.0.13</version>
</dependency>
```

```java
// === CÓDIGO EJEMPLO (guía) ===
package com.aluracursos.database;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.*;

public class ConexionPool {
    private static HikariDataSource dataSource;

    static {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:postgresql://localhost:5432/literalura_db");
        config.setUsername("literalura_user");
        config.setPassword("literalura123");
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(600000);

        dataSource = new HikariDataSource(config);
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public static void cerrarPool() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}
```

**👉 Tu turno:**

1. Reemplaza tu `ConexionBD` antigua con `ConexionPool` usando HikariCP
2. Verifica que todo el CRUD sigue funcionando
3. Agrega un método `estadoPool()` que muestre: `Active: 2, Idle: 3, Total: 5, Wait: 0`

---

## ✅ Evaluación Módulo 06

- [ ] Ejercicio 06-A: LibroDAO completo con CRUD y PreparedStatement
- [ ] Ejercicio 06-B: Método con transacción, commit y rollback
- [ ] Ejercicio 06-C: Pool HikariCP configurado y funcionando
- [ ] Todo subido a GitHub

> **Cuando termines, avísame para revisar ✅**
