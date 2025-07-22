import json

def lambda_handler(event, context):
    student_id = event.get('queryStringParameters', {}).get('student_id', '1')
    # Mock: fetch student history from LMS (would be a DB/API call)
    student_courses = [
        {'course_id': 'cs101', 'title': 'Intro to CS', 'description': 'Basics of computer science.'},
        {'course_id': 'math201', 'title': 'Calculus I', 'description': 'Differential calculus.'}
    ]
    # Mock: fetch recommendations from Algolia (would be a search call)
    recommendations = [
        {
            'course_id': 'ai301',
            'title': 'AI for Beginners',
            'description': 'Learn the basics of AI.',
            'score': 0.95,
            'explanation': 'Based on your interest in CS and Math.'
        },
        {
            'course_id': 'ds101',
            'title': 'Data Science Fundamentals',
            'description': 'Intro to data science concepts.',
            'score': 0.89,
            'explanation': 'Popular among students with similar backgrounds.'
        }
    ]
    return {
        'statusCode': 200,
        'body': json.dumps({'recommendations': recommendations})
    } 