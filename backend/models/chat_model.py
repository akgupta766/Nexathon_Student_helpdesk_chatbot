from datetime import datetime
from bson import ObjectId

class Conversation:
    def __init__(self, user_id, messages):
        self.user_id = user_id
        self.messages = messages
        self.created_at = datetime.now()
        self.updated_at = datetime.now()
    
    def to_dict(self):
        return {
            'user_id': self.user_id,
            'messages': self.messages,
            'created_at': self.created_at,
            'updated_at': self.updated_at
        }

class FAQ:
    def __init__(self, category, question, answer, keywords):
        self.category = category
        self.question = question
        self.answer = answer
        self.keywords = keywords
    
    def to_dict(self):
        return {
            'category': self.category,
            'question': self.question,
            'answer': self.answer,
            'keywords': self.keywords
        }