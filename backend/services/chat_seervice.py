from models.database import mongo
from services.rasa_service import RasaService
from datetime import datetime
import re

class ChatService:
    def __init__(self, rasa_service):
        self.rasa_service = rasa_service
    
    def process_message(self, user_id, message):
        # First, try to get a response from RASA
        rasa_response = self.rasa_service.get_response(message, user_id)
        
        if rasa_response and len(rasa_response) > 0:
            # RASA provided a response
            bot_response = rasa_response[0].get('text', 'Sorry, I didn\'t understand that.')
            intent = "rasa_response"
        else:
            # Fallback to FAQ matching
            bot_response, intent = self._match_faq(message)
        
        # Save conversation to database
        self._save_conversation(user_id, message, bot_response, intent)
        
        return bot_response
    
    def _match_faq(self, message):
        """Match user message against FAQ database"""
        message_lower = message.lower()
        
        # Search for matching FAQs
        faqs = mongo.db.faqs.find()
        
        for faq in faqs:
            # Check keywords
            for keyword in faq.get('keywords', []):
                if re.search(r'\b' + re.escape(keyword) + r'\b', message_lower):
                    return faq['answer'], "faq_match"
        
        # Default response if no match found
        return "I'm sorry, I don't have information about that. Please contact the student helpdesk at helpdesk@example.com or call 123-456-7890 during office hours.", "no_match"
    
    def _save_conversation(self, user_id, user_message, bot_response, intent):
        """Save conversation to MongoDB"""
        conversation_data = {
            'user_id': user_id,
            'messages': [
                {
                    'text': user_message,
                    'is_user': True,
                    'timestamp': datetime.now()
                },
                {
                    'text': bot_response,
                    'is_user': False,
                    'timestamp': datetime.now(),
                    'intent': intent
                }
            ],
            'created_at': datetime.now(),
            'updated_at': datetime.now()
        }
        
        mongo.db.conversations.insert_one(conversation_data)