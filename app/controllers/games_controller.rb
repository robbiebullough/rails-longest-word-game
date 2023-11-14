require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @answer = params[:answer]
    @letters = params[:letters].gsub(/\s+/, '').chars
    json_hash = URI.open("https://wagon-dictionary.herokuapp.com/#{@answer}").read
    if JSON.parse(json_hash)["found"] == false
      @score = "Sorry, #{@answer} is not a valid word"
    elsif grid_checker(@letters, @answer) == false
      @score = "Sorry, #{@answer.capitalize} contains letters that are not in #{params[:letters]}"
    else
      @score = "Well done! #{@answer.capitalize} is a valid word!"
    end
  end

  def grid_checker(grid, attempt)
    attempt1 = attempt.upcase.chars
    attempt1.each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.find_index(letter))
      else
        return false
      end
    end
    return true
  end

  def score_calculator(attempt, start_time, end_time)
    time = end_time - start_time
    length = attempt.length
    score = (length / time) * 100
    return score
  end

  # def run_game(attempt, grid, start_time, end_time)
  #   hash = {}
  #   if word_checker(attempt)["found"] == false
  #     (hash[:score] = 0) && (hash[:message] = "This is not an English word")
  #   elsif grid_checker(grid, attempt) == false
  #     (hash[:score] = 0) && (hash[:message] = "Your word was not in the grid")
  #   else
  #     (hash[:score] = score_calculator(attempt, start_time, end_time)) && (hash[:message] = "Well done!")
  #   end
  #   (hash[:time] = end_time - start_time)
  #   return hash
  # end

end
