#!/bin/bash
set -e

# --- Assign pipeline variables passed as arguments ---
# If you prefer, you can also export them from SSH task, but passing as args is safer.
PGPASSWORD="$1"   # DB password
DB_USER="$2"     # e.g., odoo17
DB_NAME="$3"     # e.g., odoo
SQL_FILE="$4"    # e.g., odoo.sql

echo "Using DB_USER=$DB_USER, DB_NAME=$DB_NAME, SQL_FILE=$SQL_FILE"

cd "$(dirname "$SQL_FILE")"

echo "Dropping database if exists..."
psql -U "$DB_USER" -d postgres -c "DROP DATABASE IF EXISTS $DB_NAME;"

echo "Creating database..."
psql -U "$DB_USER" -d postgres -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;"

echo "Restoring database from SQL..."
psql -U "$DB_USER" -d "$DB_NAME" -f "$(basename "$SQL_FILE")"

echo "Database restore completed!"
