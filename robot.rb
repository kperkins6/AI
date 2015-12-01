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
    ret_array.push(("%04b" % val))
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

def get_initial_trans_for(_world)
  # create new trans matrix
  trans_array = Array.new(_world.size).map!{Array.new(_world.size,0)}
  # iterate over each square in the world and update trans matrix appropriately
  _world.rooms.each_with_index do |e, row, col|
    # cell represents the current cell we are analyzing in the world
    cell = row*_world.width+col
    # prob is default of 0
    prob = 0
    # determine probability of moving to adjacent squares
    unless e.count("0") == 0 then prob = (1.0/e.count("0")).to_f end
    #stillwinningloc
    # nav is now holding an array to access each direction by index
    e = e.to_s.split("").map(&:to_i)
    # initialize t matrix for given possible navigation directions
    if e[0]==0 then trans_array[cell-_world.width][cell] = prob end
    if e[1]==0 then trans_array[cell+_world.width][cell] = prob end
    if e[2]==0 then trans_array[cell-1][cell] = prob end
    if e[3]==0 then trans_array[cell+1][cell] = prob end
  end
  # turn that bitch into a Matrix.
  return Matrix.rows(trans_array)
end

def get_initial_joint_prediction_matrix_for(_world)
  # initialize prediction matrix array
  pred_array = Array.new(_world.size).map {Array.new(1,0)}
  # initialize probability that will be assigned to all eligible rooms
  prob = 1.0/(_world.size-_world.rooms.each.count("1111"))
  # for each room in the world see if it's eligible and set it
  _world.rooms.each_with_index do |e, row, col|
    unless e == "1111" then pred_array[(row*_world.width)+col] = [prob] end
  end
  # turn it into a Matrix! fckyea
  return Matrix.rows(pred_array)
end

def get_initial_observation_probability_matrix(world, observation)

end

# class to hold common properties of a world
class World
  # rooms contain binary representation of unobscured directions of movement
  def rooms
    @rooms
  end
  def size
    @size
  end
  def width
    @width
  end
  def height
    @height
  end
  def initialize(_world)
    @rooms = _world
    @width = @rooms.column_count()
    @height = @rooms.row_count()
    @size = @width*@height
  end
end

def main
  # read observations from input file
  observations = get_observations
  # generate a new world given the input file
  world = World.new(get_world)
  # generate error table
  error = get_error
  # initialize transitivity matrix for problem given a world
  trans_matrix = get_initial_trans_for(world)
  # initialize joint prediction matrix given a world
  joint_prediction_matrix = get_initial_joint_prediction_matrix_for(world)

  # initialize joint transitivity matrix for first iteration
  joint_trans_matrix = trans_matrix*joint_prediction_matrix
  # Initialize Observation Probability Matrix
  obs_prob_matrix = Matrix.build(world.size, world.size) {0}
  # Initialize Y
  y = Matrix.zero(0)
  # update matricies for each observation
  observations.each do |observation|
    # print current iteration for debugging
    puts "observation: #{observation}\n"
    # for each room: update the observation probability matrix
    world.rooms.each_with_index do |room, row, col|
      # must copy matrix into an array in order to change single components
      tmp_array = obs_prob_matrix.to_a
      # adjust the array accordingly to the xor between observation and rooms
      tmp_array[(row*world.width)+col][(row*world.width)+col] = error[("%04b" % (room.to_i(2)^observation.to_i(2))).count("1")]
      # rebuild the matrix using the new values
      obs_prob_matrix = Matrix.rows(tmp_array)
    end
    # update Y
    y = obs_prob_matrix*joint_trans_matrix
    # update joint transitivity matrix
    joint_trans_matrix = trans_matrix*y
  end
  # after final iteration, calculate most likely room
  # sum components of y and calculate E
  sum = 0
  y.each {|i| sum += i }
  e = (1.0/sum) * y
  e = e.column(0).to_a
  # find the highest probability in E
  max = e.max
  # initialize an array
  a = Array.new()
  # push the room index of the most likely rooms
  e.each_with_index {|e, i| if e == max then a.push(i) end}
  # debugging
  puts a
end

main
