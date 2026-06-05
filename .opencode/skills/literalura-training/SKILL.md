---
name: literalura-training
description: "Use ONLY when the user says 'literalura', 'entrenamiento literalura', 'retomar entrenamiento', 'sesion-literalura', or asks to continue their Java/Spring Boot training. This skill manages the progressive LiterAlura training plan from Java fundamentals to Spring Boot + JPA + APIs."
---

# LiterAlura Training — Skill de Entrenamiento

## Contexto del Estudiante
- **Nombre:** PierreLogs (GitHub: https://github.com/PierreLogs/literalura-training)
- **Repositorio:** `C:\Users\USER\IdeaProjects\literalura-training\`
- **Progreso guardado en:** `C:\Users\USER\Documentos\sesion-literalura.txt`
- **Proyecto final:** LiterAlura — Catálogo de libros con Spring Boot + PostgreSQL + Gutendex API

## Metodología
1. El estudiante lee la teoría del módulo
2. Recibe un ejercicio con código ejemplo
3. Escribe su solución en IntelliJ
4. El tutor revisa y aprueba el código
5. Solo avanza al siguiente módulo si el actual está aprobado

## Plan de Módulos (12 en total)

| # | Módulo | Conceptos |
|---|--------|-----------|
| 00 | Setup | Java, Git, IntelliJ, PostgreSQL, Maven, Hola Mundo |
| 01 | Fundamentos Java | Variables, if/else, switch, for/while, arrays, métodos, Scanner |
| 02 | POO Básico | Clases, objetos, encapsulamiento, constructores, toString, static |
| 03 | POO Intermedio | Herencia, interfaces, abstract, polimorfismo, @Override, super |
| 04 | Colecciones | ArrayList, HashMap, genéricos <T>, lambdas, Stream API básico |
| 05 | Excepciones | try-catch, multi-catch, finally, try-with-resources, excepciones personalizadas |
| 06 | JDBC + PostgreSQL | Connection, PreparedStatement, CRUD, transacciones, HikariCP |
| 07 | JPA/Hibernate | @Entity, @Table, @ManyToOne, @OneToMany, EntityManager, JPQL |
| 08 | Spring Boot | @SpringBootApplication, DI, @Autowired, CommandLineRunner, @Bean |
| 09 | Spring Data JPA | JpaRepository, derived queries, @Query, @Modifying, Pageable |
| 10 | APIs REST | HttpClient, Jackson, @JsonAlias, Records, Gutendex API |
| 11 | Streams Avanzados | Optional, groupingBy, flatMap, partitioningBy, statistics, method references |
| 12 | Proyecto Final | LiterAlura completo con menú de 9 opciones + BD + API |

## Estados de Ejercicios
- `pendiente` — No iniciado
- `en_progreso` — El estudiante está trabajando en él
- `aprobado` — Tutor revisó y aprobó el código

## Instrucciones para el Tutor
- Cuando el estudiante diga "retomar", leer `sesion-literalura.txt` para saber dónde quedó
- Cada ejercicio debe tener código ejemplo que el estudiante modifique
- Evaluar: lógica correcta, sintaxis, buenas prácticas, manejo de errores
- No aprobar si hay errores graves; dar pistas antes que la solución
- Usar el método socrático: guiar con preguntas antes de dar respuestas
- Celebrar los aciertos y documentar los errores en la bitácora
