from sqlalchemy import Column, Integer, String, Date, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship

Base = declarative_base()

class Learner(Base):
    __tablename__ = 'learners'
    id = Column(Integer, primary_key=True)
    name = Column(String)
    enrollments = relationship('Enrollment', back_populates='learner')

class Course(Base):
    __tablename__ = 'courses'
    id = Column(String, primary_key=True)
    title = Column(String)
    description = Column(String)
    enrollments = relationship('Enrollment', back_populates='course')

class Enrollment(Base):
    __tablename__ = 'enrollments'
    id = Column(Integer, primary_key=True)
    learner_id = Column(Integer, ForeignKey('learners.id'))
    course_id = Column(String, ForeignKey('courses.id'))
    enrolled_on = Column(Date)
    learner = relationship('Learner', back_populates='enrollments')
    course = relationship('Course', back_populates='enrollments') 