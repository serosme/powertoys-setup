import json
import shutil
from pathlib import Path


def main():
    script_dir = Path(__file__).parent
    config_path = script_dir / "backup_config.json"
    backup_folder = script_dir / "backup"

    with config_path.open("r", encoding="utf-8") as f:
        config = json.load(f)

    user_enter = input("Enter 1 to export, 2 to import: ").strip()

    for item in config:
        module = item.get("Module")
        folder = item.get("Folder")
        file = item.get("File")

        source_path = Path(folder) / file
        target_path = backup_folder / module / file

        if user_enter == "1":
            if source_path.exists():
                target_path.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(source_path, target_path)
        elif user_enter == "2":
            if target_path.exists():
                source_path.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(target_path, source_path)


if __name__ == "__main__":
    main()
