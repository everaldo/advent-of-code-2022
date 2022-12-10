#!/usr/bin/env ruby
# frozen_string_literal: true

# --- Day 9: Rope Bridge ---
# This rope bridge creaks as you walk along it. You aren't sure how old it is, or whether it can even support your weight.

# It seems to support the Elves just fine, though. The bridge spans a gorge which was carved out by the massive river far below you.

# You step carefully; as you do, the ropes stretch and twist. You decide to distract yourself by modeling rope physics; maybe you can even figure out where not to step.

# Consider a rope with a knot at each end; these knots mark the head and the tail of the rope. If the head moves far enough away from the tail, the tail is pulled toward the head.

# Due to nebulous reasoning involving Planck lengths, you should be able to model the positions of the knots on a two-dimensional grid. Then, by following a hypothetical series of motions (your puzzle input) for the head, you can determine how the tail will move.

# Due to the aforementioned Planck lengths, the rope must be quite short; in fact, the head (H) and tail (T) must always be touching (diagonally adjacent and even overlapping both count as touching):

# ....
# .TH.
# ....

# ....
# .H..
# ..T.
# ....

# ...
# .H. (H covers T)
# ...
# If the head is ever two steps directly up, down, left, or right from the tail, the tail must also move one step in that direction so it remains close enough:

# .....    .....    .....
# .TH.. -> .T.H. -> ..TH.
# .....    .....    .....

# ...    ...    ...
# .T.    .T.    ...
# .H. -> ... -> .T.
# ...    .H.    .H.
# ...    ...    ...
# Otherwise, if the head and tail aren't touching and aren't in the same row or column, the tail always moves one step diagonally to keep up:

# .....    .....    .....
# .....    ..H..    ..H..
# ..H.. -> ..... -> ..T..
# .T...    .T...    .....
# .....    .....    .....

# .....    .....    .....
# .....    .....    .....
# ..H.. -> ...H. -> ..TH.
# .T...    .T...    .....
# .....    .....    .....
# You just need to work out where the tail goes as the head follows a series of motions. Assume the head and the tail both start at the same position, overlapping.

# For example:

# R 4
# U 4
# L 3
# D 1
# R 4
# D 1
# L 5
# R 2
# This series of motions moves the head right four steps, then up four steps, then left three steps, then down one step, and so on. After each step, you'll need to update the position of the tail if the step means the head is no longer adjacent to the tail. Visually, these motions occur as follows (s marks the starting position as a reference point):

# == Initial State ==

# ......
# ......
# ......
# ......
# H.....  (H covers T, s)

# == R 4 ==

# ......
# ......
# ......
# ......
# TH....  (T covers s)

# ......
# ......
# ......
# ......
# sTH...

# ......
# ......
# ......
# ......
# s.TH..

# ......
# ......
# ......
# ......
# s..TH.

# == U 4 ==

# ......
# ......
# ......
# ....H.
# s..T..

# ......
# ......
# ....H.
# ....T.
# s.....

# ......
# ....H.
# ....T.
# ......
# s.....

# ....H.
# ....T.
# ......
# ......
# s.....

# == L 3 ==

# ...H..
# ....T.
# ......
# ......
# s.....

# ..HT..
# ......
# ......
# ......
# s.....

# .HT...
# ......
# ......
# ......
# s.....

# == D 1 ==

# ..T...
# .H....
# ......
# ......
# s.....

# == R 4 ==

# ..T...
# ..H...
# ......
# ......
# s.....

# ..T...
# ...H..
# ......
# ......
# s.....

# ......
# ...TH.
# ......
# ......
# s.....

# ......
# ....TH
# ......
# ......
# s.....

# == D 1 ==

# ......
# ....T.
# .....H
# ......
# s.....

# == L 5 ==

# ......
# ....T.
# ....H.
# ......
# s.....

# ......
# ....T.
# ...H..
# ......
# s.....

# ......
# ......
# ..HT..
# ......
# s.....

# ......
# ......
# .HT...
# ......
# s.....

# ......
# ......
# HT....
# ......
# s.....

# == R 2 ==

# ......
# ......
# .H....  (H covers T)
# ......
# s.....

# ......
# ......
# .TH...
# ......
# s.....
# After simulating the rope, you can count up all of the positions the tail visited at least once. In this diagram, s again marks the starting position (which the tail also visited) and # marks other positions the tail visited:

# ..##..
# ...##.
# .####.
# ....#.
# s###..
# So, there are 13 positions the tail visited at least once.

# Simulate your complete hypothetical series of motions. How many positions does the tail of the rope visit at least once?

@max_step = 0
@grid_size = 10000

@start_position = {row: @grid_size / 2, column: @grid_size / 2}

def get_motions
  motions = []
  input = File.read('./input.txt')
  input.split("\n").each do |line|
    direction, steps = line.split(' ')
    steps = steps.to_i
    @max_step = steps if steps > @max_step
    motions << (direction * steps).split('')
  end
  motions.flatten
end

def make_grid
  grid = []
  @grid_size.times do |i|
    grid[i] = ('.' * @grid_size).split('')
  end
  grid[@start_position[:row]][@start_position[:column]] = 'H'
  grid
end

def make_visited_grid
  visited_grid = []
  @grid_size.times do |i|
    visited_grid[i] = []
    @grid_size.times do |j|
      visited_grid[i][j] = false
    end
  end
  visited_grid[@start_position[:row]][@start_position[:column]] = true
  visited_grid
end

def print_grid(grid)
  grid.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      if i == @start_position[:row] && j == @start_position[:column] && grid[i][j] != 'H' && grid[i][j] != 'T'
        if @tail[:row] == i && @tail[:column] == j
          print 'T'
        else
          print 's'
        end
      else
        print cell
      end
    end
    puts
  end
  puts
end

def print_visited_grid(grid)
  grid.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      if i == @start_position[:row] && j == @start_position[:column]
        print 's'
      elsif cell
        print '#'
      else
        print '.'
      end
    end
    puts
  end
end

def move_head(motion)
  @grid[@head[:row]][@head[:column]] = '.'
  case motion
  when 'U'
    @head[:row] = @head[:row] - 1
  when 'R'
    @head[:column] = @head[:column] + 1
  when 'L'
    @head[:column] = @head[:column] - 1
  when 'D'
    @head[:row] = @head[:row] + 1
  end
  @grid[@head[:row]][@head[:column]] = 'H'
end


def move_tail_same_row
  if @head[:column] - @tail[:column] > 1
    @tail[:column] += 1
  elsif @head[:column] - @tail[:column] < - 1
    @tail[:column] -= 1
  end
end

def move_tail_same_column
  if @head[:row] - @tail[:row] > 1
    @tail[:row] += 1
  elsif @head[:row] - @tail[:row] < - 1
    @tail[:row] -= 1
  end
end

def move_tail(motion)
  return if @head[:row] == @tail[:row] && @head[:column] == @tail[:column]

  old_tail = @tail.dup

  if @head[:row] == @tail[:row]
    move_tail_same_row
  elsif @head[:column] == @tail[:column]
    move_tail_same_column
  elsif @head[:column] - @tail[:column] > 1
    @tail[:column] += 1
    @tail[:row] = @head[:row]
  elsif @head[:column] - @tail[:column] < -1
    @tail[:column] -= 1
    @tail[:row] = @head[:row]
  elsif @head[:row] - @tail[:row] > 1
    @tail[:row] += 1
    @tail[:column] = @head[:column]
  elsif @head[:row] - @tail[:row] < -1
    @tail[:row] -= 1
    @tail[:column] = @head[:column]
  end

  if @head != @tail
    @grid[@tail[:row]][@tail[:column]] = 'T'
    if old_tail != @tail
      @grid[old_tail[:row]][old_tail[:column]] = '.'
    end
  end
  @visited_grid[@tail[:row]][@tail[:column]] = true
end


def count_visited_cells(grid)
  visited = 0
  grid.each do |row|
    row.each do |cell|
      visited += 1 if cell
    end
  end
  visited
end

@motions = get_motions
@grid = make_grid
@visited_grid = make_visited_grid

@head = {row:  @start_position[:row], column: @start_position[:column]}
@tail = {row: @start_position[:row], column: @start_position[:column]}

@motions.each do |motion|
  move_head(motion)
  move_tail(motion)
end

puts count_visited_cells(@visited_grid)
