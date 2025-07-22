import pytest
import json
from lambda_function import lambda_handler

def test_recommendations_normal():
    event = {'queryStringParameters': {'student_id': '1'}}
    result = lambda_handler(event, None)
    assert result['statusCode'] == 200
    data = json.loads(result['body'])
    recs = data['recommendations']
    assert isinstance(recs, list)
    assert any(r['course_id'] == 'ai301' for r in recs)
    assert any(r['title'] == 'AI for Beginners' for r in recs)
    assert any('description' in r for r in recs)

def test_recommendations_no_student_id():
    event = {'queryStringParameters': {}}
    result = lambda_handler(event, None)
    assert result['statusCode'] == 200
    data = json.loads(result['body'])
    recs = data['recommendations']
    assert isinstance(recs, list)
    assert any('course_id' in r for r in recs) 