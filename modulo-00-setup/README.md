# Módulo 00: Configuración del Entorno

> **Duración estimada:** 1-2 horas
> **Objetivo:** Tener todo listo para programar

## 📋 Lista de Verificación

- [ ] Instalar Java 17+ (JDK)
- [ ] Instalar IntelliJ IDEA
- [ ] Instalar Git
- [ ] Instalar PostgreSQL
- [ ] Configurar Maven
- [ ] Crear cuenta GitHub
- [ ] Clonar este repositorio
- [ ] Crear base de datos `literalura_db`

---

## 🔧 Paso 1: Java 17+

**Verificar instalación:**

```bash
java --version
```

Debes ver algo como: `openjdk 17.0.x ...`

## 🔧 Paso 2: IntelliJ IDEA

- Descargar IntelliJ IDEA Community o Ultimate
- Configurar JDK 17 en File → Project Structure → SDK

## 🔧 Paso 3: Git y GitHub

```bash
git --version
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
```

## 🔧 Paso 4: PostgreSQL

```bash
psql --version
```

**Crear la base de datos:**

```sql
CREATE DATABASE literalura_db;
CREATE USER literalura_user WITH PASSWORD 'literalura123';
GRANT ALL PRIVILEGES ON DATABASE literalura_db TO literalura_user;
```

## 🔧 Paso 5: Probar con un proyecto Maven mínimo

Crear archivo `pom.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.aluracursos</groupId>
    <artifactId>hola-mundo</artifactId>
    <version>1.0-SNAPSHOT</version>
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
    </properties>
</project>
```

Crear `src/main/java/com/aluracursos/Main.java`:

```java
package com.aluracursos;

public class Main {
    public static void main(String[] args) {
        System.out.println("¡Hola, LiterAlura!");
        System.out.println("Java version: " + System.getProperty("java.version"));
    }
}
```

## ✅ Evaluación Módulo 00

Para aprobar este módulo debes:

1. Ejecutar `java --version` y mostrar el resultado
2. Ejecutar `git --version` y mostrar el resultado
3. Ejecutar `psql --version` y mostrar el resultado
4. Crear un proyecto Maven "hola-mundo" en IntelliJ
5. Ejecutar la clase Main y ver "¡Hola, LiterAlura!" en consola
6. Hacer commit y push a tu fork del repositorio

> **Cuando completes todo, avísame para revisar y aprobar ✅**
