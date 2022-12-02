#!/usr/bin/env ruby

input = File.read('./input.txt')

calories = 0
most_calories = 0

input.split("\n").each do |line|
  if line == ""
    calories = 0
    next
  end

  calories += line.to_i
  if calories > most_calories
    most_calories = calories
  end
end

puts most_calories
