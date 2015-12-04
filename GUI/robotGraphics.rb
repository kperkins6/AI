#!/usr/bin/ruby -w
require "gtk2"

$rows = 35
$columns = 35

class RubyApp < Gtk::Window
	$defectiveCount=0
	def initialize
		super
			set_title "Robot Localization"
			signal_connect "destroy" do
			Gtk.main_quit
		end
		init_ui
		set_default_size 800,800
		set_window_position Gtk::Window::POS_CENTER
		show_all
	end

	def init_ui
		@canvas = Gtk::DrawingArea.new
		@button = Gtk::Button.new("hey")
		@canvas.signal_connect "expose-event" do
			on_expose
		end
		add(@canvas)
	end

	def on_expose
		# n = 35
		srand(15110)
		memory = Array.new
		#for row in 1..(rows-2) do
		#for row in 1..33 do
			#for col in 1..(columns-2) do
			#for col in 1..33 do
		for i in 0..($rows-1) do
		#for i in 0..34 do
			memory[i] = Array.new
			for j in 1..($columns-1) do
			#for j in 1..34 do
				memory[i][j] = rand(4)
				if memory[i][j] == 0
					$defectiveCount +=1
				end
			end
		end
		for i in 0..($rows-1) do
			memory[i][0] = 9
			memory[i][$columns-1] = 9
		end
		for i in 0..($columns-1) do
			memory[0][i] = 9
			memory[$rows-1][i] = 9
		end

		cr = @canvas.window.create_cairo_context
		draw_colors(cr,memory)
		cell_advance(memory)
		#for i in 0..99 do
			cell_advance(memory)
			draw_colors(cr, memory)
		#end

	end
# green is 1
# red is 0
#
# #
# if memory[row][col] == 0 #red
# 	cr.set_source_rgb 0, 0, 0
# elsif memory[row][col] == 1 #light blue new
# 	cr.set_source_rgb 0, 255, 0
# elsif memory[row][col] == 2 #blue normal
# 	cr.set_source_rgb 0, 0, 255
# else #dark blue aged
# 	cr.set_source_rgb 255, 0, 255
# end
#

	def draw_colors(cr,memory)
		for row in 1..($rows) do
		#for row in 1..33 do
			for col in 1..($columns) do
			#for col in 1..33 do

				cr.set_source_rgb 0, 0, 0
				#rectangle: the first two paramters are the x, y corrdinates of the top left corner of the rectangle
				# the last two paramters are the width and the height of the rectange
				cr.rectangle 20*(col + 1), 20*(row + 1), 19, 19

				# fill: fills the inside of the rectangle with the current color
				cr.fill
			end
		end
	end

	def event?(p)
		return (rand(100) < p)
	end

	def cell_advance(memory)
		for i in 1..($rows-2) do
		#for row in 1..33 do
			for j in 1..($columns-2) do
			#for col in 1..33 do
				if memory[i][j] == 0
					memory[i][j] = defective()
				elsif memory[i][j] == 1
					memory[i][j] = new()
				elsif memory[i][j] == 2
					memory[i][j] = normal(memory)
				else #memory[i][j] == 3
					memory[i][j] = aged()
				end
			end
		end
		puts "finished 1 update"
	end

	def defective
		repairChance=$defectiveCount/441 #defective divided by total
		if event?(repairChance)
			$defectiveCount+=1
			updatedValue=1 #new
			return updatedValue
		else
			return 0 #defective
		end
	end

	def new
		lemon=5
		install=40
		if event?(lemon)
			$defectiveCount += 1
			updatedValue=0 #defective
			return updatedValue
		elsif event?(install)
			updatedValue=2 #normal
			return updatedValue
		else
			return 1 #new
		end
	end

	def normal(memory)
		prevention=15
		wearTear=5
		neighbor=20
		if event?(neighbor)
			#if memory
			$defectiveCount += 1
			updatedValue=0 #defective
			return updatedValue
		elsif event?(wearTear)
			updatedValue=3 #aged
			return updatedValue
		elsif event?(prevention)
			updatedValue=1 #new
			return updatedValue
		else
			return 2 #normal
		end
	end

	def aged
		repairChance=$defectiveCount/1089 #defective divided by total
		if event?(repairChance)
			$defectiveCount += 1
			updatedValue=0 #defective
			return updatedValue
		else
			return 3 #aged
		end
	end



end
Gtk.init
window = RubyApp.new
Gtk.main
