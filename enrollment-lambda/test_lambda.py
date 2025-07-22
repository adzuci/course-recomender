import pytest
import json
from lambda_function import lambda_handler

def test_enrollments_normal():
    event = {'queryStringParameters': {'student_id': '1'}}
    result = lambda_handler(event, None)
    assert result['statusCode'] == 200
    data = json.loads(result['body'])
    enrollments = data['enrollments']
    assert isinstance(enrollments, list)
    assert any(e['course_id'] == 'cs101' for e in enrollments)
    assert any(e['title'] == 'Intro to CS' for e in enrollments)
    assert any('description' in e for e in enrollments)

def test_enrollments_no_student_id():
    event = {'queryStringParameters': {}}
    result = lambda_handler(event, None)
    assert result['statusCode'] == 200
    data = json.loads(result['body'])
    enrollments = data['enrollments']
    assert isinstance(enrollments, list)
    assert any('course_id' in e for e in enrollments) 