import sqlite3
import re
import os

DB_PATH = 'server/aethrium.db'
SCHEMA_PATH = 'database/schema.sql'
SEEDS = [
    'database/seed/01_accounts_fix.sql',
    'database/seed/03_guilds_fix.sql',
    'database/seed/04_players_final_migration.sql',
    'database/seed/05_towns.sql'
]

def clean_sql_for_sqlite(sql):
    # 1. Basic cleanups
    sql = re.sub(r'ENGINE=InnoDB.*?;', ';', sql, flags=re.IGNORECASE)
    sql = re.sub(r'CHARACTER SET \w+', '', sql, flags=re.IGNORECASE)
    sql = re.sub(r'DEFAULT CHARSET=\w+', '', sql, flags=re.IGNORECASE)
    
    # 2. SQLite PRIMARY KEY AUTOINCREMENT fix
    sql = re.sub(r'`id` int\(\d+\) NOT NULL AUTO_INCREMENT', '`id` INTEGER PRIMARY KEY AUTOINCREMENT', sql, flags=re.IGNORECASE)
    sql = re.sub(r'`id` int NOT NULL AUTO_INCREMENT', '`id` INTEGER PRIMARY KEY AUTOINCREMENT', sql, flags=re.IGNORECASE)
    sql = re.sub(r',?\s*PRIMARY KEY \(`id`\)', '', sql, flags=re.IGNORECASE)
    
    # 3. Type cleanups
    sql = re.sub(r'int\(\d+\)', 'INTEGER', sql, flags=re.IGNORECASE)
    sql = re.sub(r'unsigned', '', sql, flags=re.IGNORECASE)
    sql = re.sub(r'bigint(\(\d+\))?', 'INTEGER', sql, flags=re.IGNORECASE)
    sql = re.sub(r'tinyint(\(\d+\))?', 'INTEGER', sql, flags=re.IGNORECASE)
    sql = re.sub(r'smallint(\(\d+\))?', 'INTEGER', sql, flags=re.IGNORECASE)
    sql = re.sub(r'blob', 'TEXT', sql, flags=re.IGNORECASE)
    
    # 4. Remove MySQL specific Key/Constraint/Trigger syntax
    sql = re.sub(r',?\s*UNIQUE KEY.*?\(.*?\)', '', sql, flags=re.IGNORECASE)
    sql = re.sub(r',?\s*KEY.*?\(.*?\)', '', sql, flags=re.IGNORECASE)
    sql = re.sub(r',?\s*CONSTRAINT.*?FOREIGN KEY.*?REFERENCES.*?\)', '', sql, flags=re.IGNORECASE | re.DOTALL)
    sql = re.sub(r',?\s*FOREIGN KEY.*?REFERENCES.*?\)', '', sql, flags=re.IGNORECASE | re.DOTALL)
    sql = re.sub(r'DELIMITER.*?//', '', sql, flags=re.IGNORECASE | re.DOTALL)
    sql = re.sub(r'//.*?DELIMITER ;', '', sql, flags=re.IGNORECASE | re.DOTALL)
    
    # 5. Global Replace for common seed syntax
    sql = re.sub(r'INSERT INTO', 'INSERT OR REPLACE INTO', sql, flags=re.IGNORECASE)
    
    return sql

SCHEMA_SQLITE_PATH = 'database/schema_sqlite.sql'

def setup_db():
    if os.path.exists(DB_PATH):
        try:
            os.remove(DB_PATH)
            print(f"Removed existing {DB_PATH}")
        except PermissionError:
            print(f"Error: Could not remove {DB_PATH}. Is the server running?")
            return
        
    conn = sqlite3.connect(DB_PATH)
    
    # 1. Load Native SQLite Schema
    print(f"Applying native SQLite schema from {SCHEMA_SQLITE_PATH}...")
    with open(SCHEMA_SQLITE_PATH, 'r', encoding='utf-8') as f:
        schema_sql = f.read()
        try:
            conn.executescript(schema_sql)
        except Exception as e:
            print(f"Error on schema: {e}")
    
    # 2. Apply Seeds
    for seed in SEEDS:
        print(f"Applying seed: {seed}...")
        with open(seed, 'r', encoding='utf-8') as f:
            seed_sql = clean_sql_for_sqlite(f.read())
            try:
                conn.executescript(seed_sql)
            except Exception as e:
                print(f"Error on seed {seed}: {e}")
    
    conn.commit()
    conn.close()
    print("\nDatabase initialization complete! server/aethrium.db is ready.")

if __name__ == "__main__":
    setup_db()
