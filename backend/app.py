from flask import Flask
from flask_cors import CORS
from routes.chat_routes import chat_bp
from models.database import init_db
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def create_app():
    app = Flask(__name__)
    
    # Load configuration from environment variables
    app.config['MONGO_URI'] = os.getenv('MONGO_URI', 'mongodb://localhost:27017/student_helpdesk')
    app.config['RASA_SERVER_URL'] = os.getenv('RASA_SERVER_URL', 'http://localhost:5005')
    
    # Initialize extensions
    CORS(app)
    init_db(app)
    
    # Register blueprints
    app.register_blueprint(chat_bp, url_prefix='/api')
    
    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True, host='0.0.0.0', port=5000)