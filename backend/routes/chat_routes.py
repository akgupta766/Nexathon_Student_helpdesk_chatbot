from flask import Blueprint, request, jsonify, current_app
from services.chat_service import ChatService
from services.rasa_service import RasaService
from models.database import mongo
from datetime import datetime

chat_bp = Blueprint('chat', __name__)

@chat_bp.route('/chat', methods=['POST'])
def chat():
    try:
        data = request.get_json()
        user_id = data.get('user_id', 'anonymous')
        message = data.get('message', '')
        
        if not message:
            return jsonify({'error': 'No message provided'}), 400
        
        # Initialize services
        rasa_service = RasaService(current_app.config['RASA_SERVER_URL'])
        chat_service = ChatService(rasa_service)
        
        # Process message
        response = chat_service.process_message(user_id, message)
        
        return jsonify({'response': response})
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@chat_bp.route('/conversations/<user_id>', methods=['GET'])
def get_conversations(user_id):
    try:
        conversations = mongo.db.conversations.find(
            {'user_id': user_id}
        ).sort('updated_at', -1)
        
        result = []
        for conv in conversations:
            result.append({
                'id': str(conv['_id']),
                'messages': conv['messages'],
                'created_at': conv['created_at'],
                'updated_at': conv['updated_at']
            })
        
        return jsonify({'conversations': result})
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@chat_bp.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy', 'timestamp': datetime.now()})