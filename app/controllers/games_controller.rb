require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    vowels = %w(a e i o u)
    letters = Array.new(7) { ('a'..'z').to_a.sample }
    @letters = (letters + vowels.sample(3)).shuffle
    @letters = @letters.map { |letter| letter.capitalize }
  end

  def score
    @letters = params[:letters]
    @word = params[:word]
    if (check_word_letters(@letters, @word) == true) && (api_get(@word) == true)
      return @score = "Congrats! #{@word} is a valid english word!"
    elsif (check_word_letters(@letters, @word) == true) && (api_get(@word) == false)
      return @score = "Sorry but #{@word} doesn't seem like a valid word."
    else
      return @score = "Sorry but #{@word} can't be built of #{@letters.gsub(" ", ",")}."
    end
  end

  private

  def api_get(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    return word["found"]
  end

  def check_word_letters(letters, word)
    letters_array = letters.gsub(" ", "").chars
    array = word.upcase.chars
    array.all? { |letter| array.count(letter) <= letters_array.count(letter) }
  end
end
