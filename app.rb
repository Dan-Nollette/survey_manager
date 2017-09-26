require('sinatra')
require('sinatra/reloader')
require('sinatra/activerecord')
also_reload('lib/**/*.rb')
require('./lib/survey')
require('./lib/answer')
require('./lib/question')
require('pg')
require "pry"

get('/') do
  @surveys = Survey.all()
  erb(:index)
end

post('/') do
  Survey.create({title: params['title'], counter: 0})
  @surveys = Survey.all()
  erb(:index)
end

get('/surveys/:id') do
  @survey = Survey.find(params['id'])
  erb(:survey)
end

post('/surveys/:id') do
  survey_id = params['id']
  Question.create({text: params['text'], survey_id: survey_id})
  @survey = Survey.find(survey_id)
  erb(:survey)
end

get('/questions/:id') do
  @question = Question.find(params['id'])
  erb(:question)
end

post('/questions/:id') do
  question_id = params['id']
  Answer.create({text: params['text'], question_id: question_id, counter: 0})
  @question = Question.find(question_id)
  erb(:question)
end

delete('/surveys/:id') do
  @survey = Survey.find(params['id'])
  @survey.destroy
  redirect "/"
end

delete('/questions/:id') do
  @question = Question.find(params['id'])
  survey_id = @question.survey_id
  @question.destroy
  redirect "/surveys/#{survey_id.to_i}"
end

get('/answers/:id') do
  @answer = Answer.find(params['id'])
  question = Question.find(@answer.question_id.to_i)
  @survey = Survey.find(question.survey_id.to_i)
  erb(:answer)
end

delete('/answers/:id') do
  @answer = Answer.find(params['id'])
  question_id = @answer.question_id
  @answer.destroy
  redirect "/questions/#{question_id.to_i}"
end

patch('/surveys/:id') do
  title = params['update_survey']
  @survey = Survey.find(params['id'])
  @survey.update(:title => title)
  erb(:survey)
end

patch('/questions/:id') do
  text = params['update_question']
  @question = Question.find(params['id'])
  @question.update(text: text)
  erb(:question)
end

patch('/answers/:id') do
  text = params['update_answer']
  @answer = Answer.find(params['id'])
  @answer.update(text: text)
  redirect("/answers/#{@answer.id.to_s}")
end

get('/survey_questionnaires') do
  @message = ''
  @surveys = Survey.all
  erb(:survey_questionnaires)
end

get('/survey_questionnaires/:id') do
  @survey = Survey.find(params['id'])
  erb(:survey_display)
end

post ("/survey_display/:id") do
  @survey = Survey.find(params['id'])
  count = @survey.counter + 1
  @survey.update(counter: count)
  params.keys.each do |key|
    if (key != 'id' && key != 'button' && key != 'captures')
      answer = Answer.find(params[key].to_i)
      answer_count = answer.counter + 1
      answer.update(counter: count)
    end
  end
  erb(:thanks)
end

# 10
# 8
# button
# captures
# id
