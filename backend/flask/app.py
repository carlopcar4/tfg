from flask import Flask, request, jsonify
import subprocess
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


@app.route('/api/crear_instancia', methods=['POST'])
def crear_instancia():
    id = request.json.get('id')
    r = subprocess.run(['./crear_instancia.sh', str(id)],
    cwd='/app/lib',
    check=True,
    text=True,
    capture_output=True)
    return jsonify({'message': r.stdout})

app.run(host='0.0.0.0', port=4001)