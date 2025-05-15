from flask import Flask
import subprocess

app = Flask(__name__)

@app.route('/deploy/<id>', methods=['POST'])
def deploy(id):
    command = f"require '/app/lib/deploy_instance.rb'; DeployInstance.create({id})"
    docker = ['docker', 'exec', 'tfg_decidim_1', 'rails', 'runner', command]
    try:
        result = subprocess.run(docker, capture_output=True, text=True, check=True)
        return f"Despliegue ejecutado: {result.stdout}", 200
    except subprocess.CalledProcessError as e:
        return f"Error en el despliegue: {e.stderr}", 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=4001)