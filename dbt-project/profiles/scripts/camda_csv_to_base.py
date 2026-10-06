#!/usr/bin/env python3
"""Carga camda_clean.csv en base.camda_diagnoses, añadiendo row_id (orden del fichero)."""
import argparse
import os

import psycopg2

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

ap = argparse.ArgumentParser()
ap.add_argument("--csv", default="camda_clean.csv")
args = ap.parse_args()

conn = psycopg2.connect(
    host=os.getenv("POSTGRES_HOST", "localhost"),
    port=os.getenv("POSTGRES_PORT", "5435"),
    user=os.getenv("POSTGRES_USER", "postgres"),
    password=os.getenv("POSTGRES_PASSWORD", "postgres"),
    dbname=os.getenv("POSTGRES_DB", "camda"),
)

with conn, conn.cursor() as cur:
    cur.execute(
        """
        CREATE SCHEMA IF NOT EXISTS base;
        DROP TABLE IF EXISTS base.camda_diagnoses;
        CREATE TABLE base.camda_diagnoses (
            row_id               bigint GENERATED ALWAYS AS IDENTITY,
            paciente_id          integer,
            sexo                 text,
            edad_diagnostico     integer,
            codigo_enfermedad    text,
            nombre_enfermedad    text,
            anios_desde_diabetes numeric
        );
        """
    )
    with open(args.csv, encoding="utf-8", newline="") as f:
        cur.copy_expert(
            "COPY base.camda_diagnoses (paciente_id, sexo, edad_diagnostico, "
            "codigo_enfermedad, nombre_enfermedad, anios_desde_diabetes) "
            "FROM STDIN WITH CSV HEADER",
            f,
        )
    cur.execute("SELECT count(*) FROM base.camda_diagnoses")
    print(f"Cargadas {cur.fetchone()[0]} filas en base.camda_diagnoses")

conn.close()
