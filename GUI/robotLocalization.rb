#!/usr/bin/ruby -w
require "gtk2"
$rows = 10
$columns = 35
def start
  graphics = Gtk::Window.new(Gtk::Window::TOPLEVEL)
  graphics.set_title "Robot Localization"
  graphics.border_width = 10
  graphics.set_size_request(600,600)
  graphics.window_position = :center
  $v1 = Gtk::VBox.new true, 0
  $h1 = Gtk::HBox.new true, 0
  $h2 = Gtk::HBox.new true, 0
  @canvas = Gtk::DrawingArea.new

  #Buttons
  $button1 = Gtk::Button.new("Previous")#Creates a Button Widget
  $button1.signal_connect("clicked"){on_expose}  # previous state
  $button2 = Gtk::Button.new("Next")#Creates a Button Widget
  $button2.signal_connect("clicked"){on_expose}  # Next state calculate
  $button3 = Gtk::Button.new("Quit")#Creates a Button Widget
  $button3.signal_connect("clicked"){Gtk.main_quit}  # Exit upon clicking here

  #Initialize graphics
  graphics.add($v1)

  #fill vertical box with 2 vertical stacks
  $v1.pack_start($h1, expand = true, fill = true, padding = 0)
  $v1.pack_start($h3, expand = false, fill = true, padding = 0)

  #fill horizontal box with button and text
  $h2.pack_start($button1, expand = false, fill = false, padding = 3)
  $h2.pack_start($button2, expand = false, fill = false, padding = 3)
  $h1.pack_start($canvas, expand = true, fill = true, padding = 0)
  graphics.signal_connect "destroy" do
    Gtk.main_quit
  end
  graphics.signal_connect "expose-event" do
    on_expose
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
				#	$defectiveCount +=1
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
  def draw_colors(cr,memory)
		for row in 0..($rows-1) do
		#for row in 1..33 do
			for col in 0..($columns-1) do
			#for col in 1..33 do
			if memory[row][col] == 0 #red
				cr.set_source_rgb 0, 0, 0
			elsif memory[row][col] == 1 #light blue new
				cr.set_source_rgb 0, 255, 0
			elsif memory[row][col] == 2 #blue normal
				cr.set_source_rgb 0, 0, 255
			else #dark blue aged
				cr.set_source_rgb 255, 0, 255
			end
				#cr.set_source_rgb 0, 0, 0
				#rectangle: the first two paramters are the x, y corrdinates of the top left corner of the rectangle
				# the last two paramters are the width and the height of the rectange
				cr.rectangle 20*(col + 1), 20*(row + 1), 19, 19

				# fill: fills the inside of the rectangle with the current color
				cr.fill
			end
		end
	end
  graphics.show_all
end
start()
Gtk.main
