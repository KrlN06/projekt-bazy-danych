Baza danych dla bliźniaków cyfrowych

Opis projektu

Projekt zakłada stworzenie relacyjnej bazy danych PostgreSQL wspierającej system bliźniaków cyfrowych. Baza będzie przechowywać metadane, informacje o modelach, historię ich wersji oraz odwołania do plików z danymi pomiarowymi.

Technologie

* PostgreSQL 18
* Docker i Docker Compose
* DataGrip
* Git i GitHub

Wymagania

* Docker Desktop
* Git
* DataGrip lub inny klient PostgreSQL

Uruchomienie projektu

1. Sklonuj repozytorium.
2. Skopiuj .env.example do .env.
3. Ustaw własne hasło w pliku .env.
4. Uruchom bazę:

docker compose up -d

5. Sprawdź status kontenera:

docker compose ps

Połączenie z PostgreSQL

Parametr	Wartość
Host	127.0.0.1
Port	5433
Database	digital_twins
User	app_user

Hasło należy ustawić lokalnie w pliku .env.

Struktura projektu

* compose.yaml — konfiguracja kontenera PostgreSQL.
* .env.example — wzór konfiguracji zmiennych środowiskowych.
* sql/ — skrypty SQL.
* docs/ — dokumentacja projektu.

Bezpieczeństwo

Plik .env zawierający lokalne hasło nie powinien być przesyłany do repozytorium Git.