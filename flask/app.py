from flask import Flask
from flask_cors import CORS
import subprocess

app = Flask(__name__)
CORS(app)

@app.route('/deploy/<id>', methods=['POST'])
def deploy(id):
    subprocess.call(["/bin/bash", "/home/carlos/TFG/backend/lib/crear_instancia.sh", str(id)])
    return {"status": "ok"}, 200
    

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=4001)