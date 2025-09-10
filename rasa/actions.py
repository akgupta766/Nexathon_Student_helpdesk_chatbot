from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.events import SlotSet

class ActionProvideAdmissionInfo(Action):
    def name(self) -> Text:
        return "action_provide_admission_info"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        dispatcher.utter_message(text="The admission process involves submitting an online application, academic transcripts, and a statement of purpose. Application deadlines vary by program.")
        
        return []

class ActionProvideExamInfo(Action):
    def name(self) -> Text:
        return "action_provide_exam_info"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        dispatcher.utter_message(text="Exams are scheduled at the end of each semester. The exact dates are published on the student portal. You'll need your student ID to access the exam schedule.")
        
        return []

class ActionProvideFeeInfo(Action):
    def name(self) -> Text:
        return "action_provide_fee_info"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        dispatcher.utter_message(text="Tuition fees vary by program. You can find the detailed fee structure on our website. We accept online payments through credit/debit cards and bank transfers.")
        
        return []

class ActionProvideCourseInfo(Action):
    def name(self) -> Text:
        return "action_provide_course_info"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        dispatcher.utter_message(text="We offer a variety of programs in Engineering, Business, Arts, and Sciences. Popular courses include Computer Science, Business Administration, and Electrical Engineering.")
        
        return []

class ActionProvideCampusInfo(Action):
    def name(self) -> Text:
        return "action_provide_campus_info"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        dispatcher.utter_message(text="Our campus is located at 123 Education Street. We have excellent facilities including libraries, labs, sports complexes, and student centers. The campus is accessible by public transportation.")
        
        return []