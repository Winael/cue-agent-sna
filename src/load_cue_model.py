import subprocess
import json

def load_model():
    """Exports the CUE model to JSON and returns it as a Python dictionary."""
    result = subprocess.run(
        ["cue", "export", "./cue/model.cue", "--out", "json"],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        print("Error exporting CUE model:")
        print(result.stderr)
        return None

    return json.loads(result.stdout)

if __name__ == "__main__":
    model = load_model()
    if model:
        print(json.dumps(model, indent=2))
