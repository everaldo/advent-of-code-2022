#!/usr/bin/env ruby
# frozen_string_literal: true

# --- Day 8: Treetop Tree House ---
# The expedition comes across a peculiar patch of tall trees all planted carefully in a grid. The Elves explain that a previous expedition planted these trees as a reforestation effort. Now, they're curious if this would be a good location for a tree house.

# First, determine whether there is enough tree cover here to keep a tree house hidden. To do this, you need to count the number of trees that are visible from outside the grid when looking directly along a row or column.

# The Elves have already launched a quadcopter to generate a map with the height of each tree (your puzzle input). For example:

# 30373
# 25512
# 65332
# 33549
# 35390
# Each tree is represented as a single digit whose value is its height, where 0 is the shortest and 9 is the tallest.

# A tree is visible if all of the other trees between it and an edge of the grid are shorter than it. Only consider trees in the same row or column; that is, only look up, down, left, or right from any given tree.

# All of the trees around the edge of the grid are visible - since they are already on the edge, there are no trees to block the view. In this example, that only leaves the interior nine trees to consider:

# The top-left 5 is visible from the left and top. (It isn't visible from the right or bottom since other trees of height 5 are in the way.)
# The top-middle 5 is visible from the top and right.
# The top-right 1 is not visible from any direction; for it to be visible, there would need to only be trees of height 0 between it and an edge.
# The left-middle 5 is visible, but only from the right.
# The center 3 is not visible from any direction; for it to be visible, there would need to be only trees of at most height 2 between it and an edge.
# The right-middle 3 is visible from the right.
# In the bottom row, the middle 5 is visible, but the 3 and 4 are not.
# With 16 trees visible on the edge and another 5 visible in the interior, a total of 21 trees are visible in this arrangement.

# Consider your map; how many trees are visible from outside the grid?

# Your puzzle answer was 1647.

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