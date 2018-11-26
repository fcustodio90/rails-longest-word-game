require 'rest-client'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = [*('A'..'Z')].sample(10)
  end

  def score
    if !match?
      @answer = "Sorry but #{@user_input}
      can't be built out of #{@hidden_field}"
    elsif request_api?
      @answer = "Congratulations! #{@user_input} is a valid English word!"
    elsif !request_api?
      @answer = "Sorry but #{@user_input} does not
      seem to be a valid English Word!"
    end
  end

  private

  def match?
    @user_input = params[:user_game]
    @hidden_field = params[:letters]
    @array_user_input = @user_input.split('')
    included?
  end

  def included?
    @array_user_input.all? do |letter|
      @array_user_input.count(letter) <= @hidden_field.split.count(letter)
    end
  end

  def request_api?
    if match?
      url_api = "https://wagon-dictionary.herokuapp.com/#{@user_input}"
      response = RestClient.get(url_api)
      api_parsed = JSON.parse(response)
      validation = api_parsed['found']
    end
    validation
  end
end
