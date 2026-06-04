# Script de configuración rápida para el entrenamiento LiterAlura

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  🚀 LITERALURA TRAINING - SETUP" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# 1. Verificar Java
Write-Host "[1/4] Verificando Java..." -ForegroundColor Yellow
$javaVersion = java --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✅ Java instalado:" -ForegroundColor Green
    $javaVersion | Select-Object -First 1
} else {
    Write-Host "  ❌ Java no encontrado. Instala JDK 17+" -ForegroundColor Red
    Write-Host "     Descarga: https://adoptium.net/"
}

# 2. Verificar Git
Write-Host "[2/4] Verificando Git..." -ForegroundColor Yellow
$gitVersion = git --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✅ $gitVersion" -ForegroundColor Green
} else {
    Write-Host "  ❌ Git no encontrado. Descarga: https://git-scm.com/" -ForegroundColor Red
}

# 3. Verificar Maven
Write-Host "[3/4] Verificando Maven..." -ForegroundColor Yellow
$mvnVersion = mvn --version 2>&1
if ($LASTEXITCODE -eq 0) {
    $mvnVersion | Select-Object -First 1
    Write-Host "  ✅ Maven instalado" -ForegroundColor Green
} else {
    Write-Host "  ❌ Maven no encontrado. Verifica que está en PATH" -ForegroundColor Red
    Write-Host "     Descarga: https://maven.apache.org/download.cgi"
}

# 4. Verificar PostgreSQL
Write-Host "[4/4] Verificando PostgreSQL..." -ForegroundColor Yellow
$psqlVersion = psql --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✅ $psqlVersion" -ForegroundColor Green
} else {
    Write-Host "  ❌ PostgreSQL no encontrado" -ForegroundColor Red
    Write-Host "     Descarga: https://www.postgresql.org/download/"
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  📚 ESTRUCTURA DEL REPOSITORIO" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

$modules = @(
    "00 - Setup del Entorno",
    "01 - Fundamentos de Java",
    "02 - POO Básico",
    "03 - POO Intermedio",
    "04 - Colecciones y Lambdas",
    "05 - Manejo de Excepciones",
    "06 - JDBC y PostgreSQL",
    "07 - JPA e Hibernate",
    "08 - Spring Boot y DI",
    "09 - Spring Data JPA",
    "10 - Consumo de APIs REST",
    "11 - Streams Avanzados",
    "12 - Proyecto Final"
)

for ($i = 0; $i -lt $modules.Length; $i++) {
    $num = $i.ToString("00")
    Write-Host "  📖 Módulo $num : $($modules[$i])"
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  🎯 SIGUIENTE PASO:" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  1. Abre IntelliJ IDEA"
Write-Host "  2. File → Open → literalura-training"
Write-Host "  3. Lee modulo-00-setup/README.md"
Write-Host "  4. ¡Empieza tu entrenamiento!"
Write-Host ""
Write-Host "  ¿Dudas? Pregúntame cuando quieras." -ForegroundColor Magenta
