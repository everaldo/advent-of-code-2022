#!/usr/bin/env ruby
# frozen_string_literal: true
require 'byebug'

def read_input
  input = File.read('./input.txt')
  map = []
  input.split("\n").each_with_index do |line, line_number|
    map[line_number] = []
    line.split("").each { |tree_height| map[line_number] << tree_height.to_i }
  end
  map
end

def is_border?(row_index, column_index, num_rows)
  row_index == 0 || row_index == num_rows - 1 || column_index == 0 || column_index == num_rows - 1
end

def is_visible_from_top?(map, row_index, column_index)
  tree_height = map[row_index][column_index]

  (0..row_index).all? do |row|
    map[row][column_index] < tree_height || row_index == row
  end
end

def is_visible_from_bottom?(map, row_index, column_index)
  tree_height = map[row_index][column_index]
  map_size = map.length

  (row_index...map_size).all? do |row|
    map[row][column_index] < tree_height || row_index == row
  end
end

def is_visible_from_left?(map, row_index, column_index)
  tree_height = map[row_index][column_index]

  (0..column_index).all? do |column|
    map[row_index][column] < tree_height || column_index == column
  end
end

def is_visible_from_right?(map, row_index, column_index)
  tree_height = map[row_index][column_index]
  map_size = map.length

  (column_index...map_size).all? do |column|
    map[row_index][column] < tree_height || column_index == column
  end
end


def is_visible?(map, row_index, column_index)
  is_visible_from_top?(map, row_index, column_index) ||
  is_visible_from_left?(map, row_index, column_index) ||
  is_visible_from_right?(map, row_index, column_index) ||
  is_visible_from_bottom?(map, row_index, column_index)
end

def calculate_visibility(map)
  visible_trees = 0
  num_rows = map.length
  map.each_with_index do |tree_line, row_index|
    tree_line.each_with_index do |tree_height, column_index|
      visible_trees += 1 and next if is_border?(row_index, column_index, num_rows)
      visible_trees += 1 if is_visible?(map, row_index, column_index)  
    end
  end
  visible_trees
end


map = read_input

puts calculate_visibility(map)