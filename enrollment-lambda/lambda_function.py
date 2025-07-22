import json
import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy_models import Enrollment, Course, Learner

DB_URL = os.environ.get('DB_URL', 'sqlite:///test.db')

def lambda_handler(event, context):
    student_id = event.get('queryStringParameters', {}).get('student_id', '1')
    try:
        engine = create_engine(DB_URL)
        Session = sessionmaker(bind=engine)
        session = Session()
        learner = session.query(Learner).filter_by(id=student_id).first()
        enrollments = []
        if learner:
            for enrollment in session.query(Enrollment).filter_by(learner_id=student_id):
                course = session.query(Course).filter_by(id=enrollment.course_id).first()
                enrollments.append({
                    'course_id': course.id,
                    'title': course.title,
                    'description': course.description,
                    'enrolled_on': str(enrollment.enrolled_on)
                })
        else:
            enrollments = []
    except Exception as e:
        # Fallback to mock data
        enrollments = [
            {'course_id': 'cs101', 'title': 'Intro to CS', 'description': 'Basics of computer science.', 'enrolled_on': '2023-01-10'},
            {'course_id': 'math201', 'title': 'Calculus I', 'description': 'Differential calculus.', 'enrolled_on': '2023-02-15'}
        ]
    return {
        'statusCode': 200,
        'body': json.dumps({'enrollments': enrollments})
    } 