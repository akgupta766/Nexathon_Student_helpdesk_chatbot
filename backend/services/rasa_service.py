import requests
import json

class RasaService:
    def __init__(self, rasa_server_url):
        self.rasa_server_url = rasa_server_url
    
    def parse_message(self, message, sender_id="default"):
        """Send message to RASA for intent classification and entity extraction"""
        try:
            response = requests.post(
                f"{self.rasa_server_url}/model/parse",
                json={"text": message, "sender_id": sender_id}
            )
            return response.json()
        except Exception as e:
            print(f"Error connecting to RASA: {e}")
            return None
    
    def get_response(self, message, sender_id="default"):
        """Get response from RASA dialogue management"""
        try:
            response = requests.post(
                f"{self.rasa_server_url}/webhooks/rest/webhook",
                json={"sender": sender_id, "message": message}
            )
            return response.json()
        except Exception as e:
            print(f"Error getting response from RASA: {e}")
            return None