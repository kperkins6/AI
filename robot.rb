#!env/bin/ruby
require 'matrix'

def get_observations
  ret_array = Array.new()
  # split line into array.. 2ez... #WinningLOC
  File.open('in').readline.split(' ').each do |observation|
    val = 0
    if observation.include? "N" then val += 8 end
    if observation.include? "S" then val += 4 end
    if observation.include? "W" then val += 2 end
    if observation.include? "E" then val += 1 end
    ret_array.push(val)
  end
  return ret_array
end

def get_world
  # instanciate world
  array_world = Array.new()
  # open our input file
  File.readlines('world').each do |line|
    # add the correct squares to 'world'
    array_world.push(line.split(" ").map {|x| "%04b" % x})
  end
  # Matrix dat hoe
  return Matrix.rows(array_world)
end

def get_error
  # error probability is read from command line
  e = ARGV[0].to_f
  # populate array and return it
  # P(E)**d * (1-P(E))**4-d
  # rounded for ease. May be changed for more accuracy!
  return Array.new(5){|index| (e**index * (1-e)**(4-index)).round(6)}
end

def get_initial_transitivity_for(_world)
  # determine the width of the world
  world_width = _world.column_vectors().size
  world_height = _world.row_vectors().size
  world_size = world_width*world_height
  # create new trans matrix
  trans_array = Array.new(world_size).map!{Array.new(world_size,0)}
  print trans_array, "\n"
  # iterate over each square in the world and update trans matrix appropriately
  _world.each_with_index do |e, row, col|
    # cell represents the current cell we are analyzing in the world
    cell = row*world_width+col
    # prob is default of 0
    prob = 0
    # determine probability of moving to adjacent squares
    unless e.count("0") == 0 then prob = (1.0/e.count("0")).to_f end
    #stillwinningloc
    # nav is now holding an array to access each direction by index
    e = e.to_s.split("").map(&:to_i)
    # initialize t matrix for given possible navigation directions
    if e[0]==0 then trans_array[cell-world_width][cell] = prob end
    if e[1]==0 then trans_array[cell+world_width][cell] = prob end
    if e[2]==0 then trans_array[cell-1][cell] = prob end
    if e[3]==0 then trans_array[cell+1][cell] = prob end
  end
  # turn that bitch into a Matrix.
  return Matrix.rows(trans_array)
end

def get_initial_joint_prediction_matrix_for(_world)
  # determine the width of the world
  world_width = _world.column_vectors().size
  world_height = _world.row_vectors().size
  world_size = world_width*world_height
  # initialize prediction matrix array
  pred_array = Array.new(world_size).map {Array.new(1,0)}
  # initialize probability that will be assigned to all eligible rooms
  prob = 1.0/(world_size-_world.each.count("1111"))
  # for each room in the world see if it's eligible and set it
  _world.each_with_index do |e, row, col|
    unless e == "1111" then pred_array[(row*world_width)+col] = [prob] end
  end
  # turn it into a Matrix! fckyea
  return Matrix.rows(pred_array)
end





observations = get_observations
world = get_world
error = get_error
transitivity_matrix = get_initial_transitivity_for(world)
joint_prediction_matrix = get_initial_joint_prediction_matrix_for(world)

# need to create iteration


puts
puts
puts "LOGGING..."
print "observations:\t#{observations}\n"
print "world:\t\t#{world}\n"
print "error:\t\t#{error}\n"
print "t:\t\t#{transitivity_matrix}\n"
print "joint p:\t#{joint_prediction_matrix}\n"
