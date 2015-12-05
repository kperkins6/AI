#!/usr/bin/ruby -w
require "gtk2"
$rows = 10
$columns = 35

def myproc2(x)
  puts "myproc2: " + x
end

def start
  root = Gtk::Window.new(Gtk::Window::TOPLEVEL)

  root.set_title "My Title" #Set the title of the window
  root.border_width = 10
  root.set_size_request(800, 800) # x, y

  $v1 = Gtk::VBox.new true, 0 # creates vertical Box
  $h1 = Gtk::HBox.new true, 0 # creates horizontal Box
  $h2 = Gtk::HBox.new true, 0# creates horizontal Box
  $canvas = Gtk::DrawingArea.new
  $lab1 = Gtk::Label.new("My Phrase")  # Create label

  $button1 = Gtk::Button.new("Button1") #Creates a Button Widget
  $button1.signal_connect("clicked"){myproc2($ent1.text)} # call method with text value

  $button2 = Gtk::Button.new("Quit")#Creates a Button Widget
  $button2.signal_connect("clicked"){Gtk.main_quit}  # Exit upon clicking here

  $ent1 = Gtk::Entry.new #This creates an entry widget

  color = Gdk::Color.parse("red")   # button widget background set to RED
  $button2.modify_bg(Gtk::STATE_NORMAL, color)
  root.add($v1)  # initialize root with veritcal box

  # fill vertical box with 2 HZ boxes stacked vertically
  $v1.pack_start($h1, expand = false, fill = false, padding = 0)
  $v1.pack_start($h2, expand = false, fill = false, padding = 0)

  # fill the first HZ box with the label
  $h1.pack_start($lab1, expand = true, fill = true, padding = 0)

  # fill the second HZ box with the botton and text entry
  $h2.pack_start($button1, expand = false, fill = false, padding = 3)
  $h2.pack_start($button2, expand = false, fill = false, padding = 3)
  $h1.pack_start($ent1, expand = true, fill = true, padding = 0)
  $canvas.signal_connect "destroy" do
    Gtk.main_quit
  end
  $canvas.signal_connect "expose-event" do
    on_expose()
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

    cr = $canvas.window.create_cairo_context
    draw_colors(cr,memory)
    cell_advance(memory)
    #for i in 0..99 do
      cell_advance(memory)
      draw_colors(cr, memory)
    #end

  end
  #####
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
  root.show_all #activate the window on the screen
end

start()
Gtk.main
