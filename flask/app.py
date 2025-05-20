from flask import Flask
from flask_cors import CORS
import subprocess

app = Flask(__name__)
CORS(app)

@app.route('/deploy/<id>', methods=['POST'])
def deploy(id):
    command = f"require '/app/lib/deploy_instance.rb'; DeployInstance.create({id})"
    docker = ['docker', 'exec', 'tfg_decidim_1', 'rails', 'runner', command]
    try:
        result = subprocess.run(docker, capture_output=True, text=True, check=True)
        return f"Despliegue ejecutado: {result.stdout}", 200
    except subprocess.CalledProcessError as e:
        print("==== ERROR RUBY STDOUT ====")
        print(e.stdout)
        print("==== ERROR RUBY STDERR ====")
        print(e.stderr)
        return f"Error en el despliegue:\nSTDOUT:\n{e.stdout}\nSTDERR:\n{e.stderr}", 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=4001)