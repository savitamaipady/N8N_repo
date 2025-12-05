import re
import os
from pathlib import Path

def extract_ddls(sql_file_path, output_dir="ddl_objects"):
    """Extract database object DDLs from SQL file and organize by type"""
    
    # Create output directory
    Path(output_dir).mkdir(exist_ok=True)
    
    # Read SQL file
    with open(sql_file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Define object patterns and their output files
    patterns = {
        'users': (r'CREATE USER.*?;', 'users.sql'),
        'sequences': (r'CREATE SEQUENCE.*?;', 'sequences.sql'),
        'tables': (r'CREATE TABLE.*?(?=CREATE|GRANT|ALTER|--|$)', 'tables.sql'),
        'synonyms': (r'CREATE.*?SYNONYM.*?;', 'synonyms.sql'),
        'db_links': (r'CREATE DATABASE LINK.*?;', 'db_links.sql'),
        'grants': (r'GRANT.*?;', 'grants.sql'),
        'alter_user': (r'ALTER USER.*?;', 'alter_user.sql'),
        'plsql_blocks': (r'DECLARE.*?END;\s*/', 'plsql_blocks.sql')
    }
    
    extracted_objects = {}
    
    for obj_type, (pattern, filename) in patterns.items():
        matches = re.findall(pattern, content, re.DOTALL | re.IGNORECASE)
        if matches:
            extracted_objects[obj_type] = matches
            
            # Write to separate file
            output_path = os.path.join(output_dir, filename)
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(f"-- {obj_type.upper()} DDL STATEMENTS\n\n")
                for match in matches:
                    f.write(match.strip() + '\n\n')
            
            print(f"Extracted {len(matches)} {obj_type} to {filename}")
    
    # Create summary file
    summary_path = os.path.join(output_dir, "summary.txt")
    with open(summary_path, 'w') as f:
        f.write("DATABASE OBJECTS SUMMARY\n")
        f.write("=" * 30 + "\n\n")
        for obj_type, objects in extracted_objects.items():
            f.write(f"{obj_type.upper()}: {len(objects)} objects\n")
    
    print(f"\nSummary written to {summary_path}")
    return extracted_objects

if __name__ == "__main__":
    sql_file = r"C:\Users\savmaipa\Downloads\ETL_OWNER_METADAT.sql"
    extract_ddls(sql_file)