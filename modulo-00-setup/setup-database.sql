# setup-database.sql
# Ejecutar en PostgreSQL: psql -U postgres -f setup-database.sql

-- Crear base de datos
CREATE DATABASE literalura_db;

-- Crear usuario
CREATE USER literalura_user WITH PASSWORD 'literalura123';

-- Otorgar permisos
GRANT ALL PRIVILEGES ON DATABASE literalura_db TO literalura_user;

-- Conectarse a la base de datos
\c literalura_db;

-- Otorgar permisos sobre el esquema public
GRANT ALL ON SCHEMA public TO literalura_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO literalura_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO literalura_user;

-- Las tablas las crea JPA automáticamente con spring.jpa.hibernate.ddl-auto=update
