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
