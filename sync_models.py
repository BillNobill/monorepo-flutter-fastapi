"""
Pydantic to Dart Model Sync Utility
-----------------------------------
This script automates the generation of Dart classes from Pydantic models (v2).
It scans 'backend/app/schemas/', inspects 'BaseModel' classes, and writes 
equivalent Dart files with JSON serialization (fromJson/toJson) to 
'apps/mobile_app/lib/core/models/'.

Usage:
    python sync_models.py
"""

import os
import sys
import importlib.util
from typing import Type, get_args, get_origin, Union
from pydantic import BaseModel

# Configuration
SCHEMAS_DIR = "backend/app/schemas"
OUTPUT_DIR = "apps/mobile_app/lib/core/models"

# Ensure output directory exists
os.makedirs(OUTPUT_DIR, exist_ok=True)

# Add backend to sys.path to allow imports
sys.path.append(os.path.join(os.getcwd(), "backend"))

TYPE_MAPPING = {
    "str": "String",
    "int": "int",
    "float": "double",
    "bool": "bool",
    "EmailStr": "String",
    "datetime": "DateTime",
}

def map_python_type_to_dart(type_hint) -> str:
    origin = get_origin(type_hint)
    args = get_args(type_hint)

    if origin is list:
        inner_type = map_python_type_to_dart(args[0])
        return f"List<{inner_type}>"
    
    if origin is Union:
        # Check for Optional (Union[T, None])
        if type(None) in args:
            real_type = [arg for arg in args if arg is not type(None)][0]
            return f"{map_python_type_to_dart(real_type)}?"
    
    type_name = getattr(type_hint, "__name__", str(type_hint))
    return TYPE_MAPPING.get(type_name, "dynamic")

def inspect_model(model_class: Type[BaseModel]):
    fields = []
    for field_name, field_info in model_class.model_fields.items():
        dart_type = map_python_type_to_dart(field_info.annotation)
        fields.append({
            "name": field_name,
            "type": dart_type,
            "required": field_info.is_required()
        })
    return fields

def discover_schemas():
    schemas = []
    for root, _, files in os.walk(SCHEMAS_DIR):
        for file in files:
            if file.endswith(".py") and file != "__init__.py":
                rel_path = os.path.relpath(os.path.join(root, file), SCHEMAS_DIR)
                module_name = rel_path.replace(os.sep, ".").replace(".py", "")
                schemas.append(module_name)
    return schemas

def generate_dart_class(class_name: str, fields: list) -> str:
    # Field declarations
    dart_fields = "\n".join([f"  final {f['type']} {f['name']};" for f in fields])
    
    # Constructor
    constructor_fields = ", ".join([
        f"{'required ' if f['required'] else ''}this.{f['name']}" for f in fields
    ])
    
    # fromJson
    from_json_fields = ",\n".join([
        f"      {f['name']}: json['{f['name']}'] as {f['type']}" for f in fields
    ])
    
    # toJson
    to_json_fields = ",\n".join([
        f"    '{f['name']}': {f['name']}" for f in fields
    ])

    return f"""class {class_name} {{
{dart_fields}

  {class_name}({{
    {constructor_fields},
  }});

  factory {class_name}.fromJson(Map<String, dynamic> json) {{
    return {class_name}(
{from_json_fields},
    );
  }}

  Map<String, dynamic> toJson() => {{
{to_json_fields},
  }};
}}
"""

def run_sync():
    schemas = discover_schemas()
    for schema_module in schemas:
        try:
            # Import module
            spec = importlib.util.spec_from_file_location(
                schema_module, 
                os.path.join(SCHEMAS_DIR, f"{schema_module.replace('.', '/')}.py")
            )
            module = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(module)
            
            for attr_name in dir(module):
                attr = getattr(module, attr_name)
                if isinstance(attr, type) and issubclass(attr, BaseModel) and attr is not BaseModel:
                    print(f"Syncing {attr_name}...")
                    fields = inspect_model(attr)
                    dart_code = generate_dart_class(attr_name, fields)
                    
                    output_file = os.path.join(OUTPUT_DIR, f"{attr_name.lower()}.dart")
                    with open(output_file, "w") as f:
                        f.write(dart_code)
        except Exception as e:
            print(f"Error syncing {schema_module}: {e}")

if __name__ == "__main__":
    run_sync()
