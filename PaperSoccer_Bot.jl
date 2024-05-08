### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ ef51ba50-f663-11ee-0491-35648200404a
begin
    import Pkg
	io = IOBuffer()
    Pkg.activate(io = io)
	deps = [pair.second for pair in Pkg.dependencies()]
	direct_deps = filter(p -> p.is_direct_dep, deps)
    pkgs = [x.name for x in direct_deps]
	if "NativeSVG" ∉ pkgs
		Pkg.add(url="https://github.com/BenLauwens/NativeSVG.jl.git")
	elseif "PlutoUI" ∉ pkgs
		Pkg.add(url="https://github.com/JuliaPluto/PlutoUI.jl")
	elseif "HypertextLiteral" ∉ pkgs
		Pkg.add(url="https://github.com/JuliaPluto/HypertextLiteral.jl")
	elseif "AbstractPlutoDingetjes" ∉ pkgs
		Pkg.add(url="https://github.com/JuliaPluto/AbstractPlutoDingetjes.jl")
	elseif "Distributions" ∉ pkgs
		Pkg.add(url="https://github.com/JuliaStats/Distributions.jl")
	end
	
	using NativeSVG 						# For the Turtle (drawing of the field)
	using PlutoUI 							# For the arrows and the settings
	
	using HypertextLiteral 					# For the HTML/Javascript code from dVdV
	using AbstractPlutoDingetjes.Bonds 		# For the HTML/Javascript code from dVdV
	using Random							# For the HTML/Javascript code from dVdV

	using Distributions 					# For the bot
end

# ╔═╡ 9675811b-e9c4-46c0-a8d3-307835670bbb
md"""
# Project Julia - ES123
First programming project at the Royal Military Academy (Belgium)

For the final exam of the ES123 (Computer Algorithms and Programming Project) course taught by Ben Lauwens, each student had to choose a game from a provided list and create it using Pluto.jl

There are two versions of the game:

- The multiplayer version called _PaperSoccer.jl_
- The player vs. Bot version called _PaperSoccer-Bot.jl_

Here, you are currently on the _PaperSoccer-Bot.jl_ version. You can find the other version on my GitHub page:
"""

# ╔═╡ a3867900-d5e1-4b4d-85ce-20a157fab8b3
# https://github.com/aurelienhbts/PlutoPaperSoccer.jl

# ╔═╡ 7bc85cb3-3f65-4da3-99f2-bf4e7db30924
md"""
## Graphics
Here is the code for the graphic part of the project.
"""

# ╔═╡ f3795a18-c6bd-4d4d-9f2b-3f6bc7b8e85d
md"""
##### To draw the field
"""

# ╔═╡ 23763acb-0991-4108-b16f-b0647f4ce42d
md"""
##### To draw the ball and the line(s)
"""

# ╔═╡ f048b29c-1f89-4097-ab59-1aa3c046d281


# ╔═╡ 43b124e2-e02a-447c-be3c-2efb21978577
md"""
## Data-structures
Here is the code for the computing part of the project.

- Grid (initialize + update used positions)
- Vectors (initialize + update used directions/vectors)
- DataDraw (store directions to draw the Turtle)

Explaination of the status of a position/vector: 
- '0' means that it is not used.
- '1' means that it is used.
- '2' means that it cannot ever be used (outside of the limits).
"""

# ╔═╡ 62dc5827-2a39-43e3-8208-38fa05864ba9
md"""
##### The mutable structure (GameState → gamestate)
"""

# ╔═╡ f0a5adce-758d-4a66-bac0-841638c0acc8
mutable struct GameState
    coords # To store the actual coords
	grid # To update the status of the different positions
	vectors # To update the status of different directions
	datadraw # To draw all the lines (add one at the time)
	player # To know which player has to play → for the color of the Turtle()
	color # To set the color of the lines
end

# ╔═╡ d81398d0-627e-4c04-ab05-d29cef5a0ba3
md"""
##### The system of coordinates and the grid
"""

# ╔═╡ aeca3167-0647-44cd-89a3-66ee1cc86ffd
function new_coords(coords, direction)
		(x, y) = coords # Initial position of the ball
		if direction == 0
			newcoords = (x,y+1)
		elseif direction == 1
			newcoords = (x+1,y+1)
		elseif direction == 2
			newcoords = (x+1,y)
		elseif direction == 3
			newcoords = (x+1, y-1)
		elseif direction == 4
			newcoords = (x,y-1)
		elseif direction == 5
			newcoords = (x-1, y-1)
		elseif direction == 6
			newcoords = (x-1,y)
		elseif direction == 7
			newcoords = (x-1,y+1)
		end
		return newcoords # New position of the ball
	end

# ╔═╡ d1936a54-1c93-495d-b3fa-7bcace3b11cf
md"""
##### The vectors/directions
"""

# ╔═╡ cecba161-e3a6-42c8-928c-a787e54ae085
function update_vectors(vectors, coords, newcoords)
	
	vector = (coords, newcoords)
	
	if haskey(vectors, vector) # Check if the vector exist in the dictionary
			
		if values(vectors[coords,newcoords]) == 0 # Change value from 0 to 1
			vectors[coords,newcoords] = 1 # Both directions needs to be changed
			vectors[newcoords,coords] = 1
		end
		
	end
	return vectors
end

# ╔═╡ 2176ab9f-3185-438b-bc81-784d856eac0b
function direction_selected(select_direction)
	
	if select_direction == "Grid(0,0)"
		selected = "#"
	elseif select_direction == "Grid(0,1)"
		selected = 0
	elseif select_direction == "Grid(1,1)"
		selected = 1
	elseif select_direction == "Grid(1,0)"
		selected = 2
	elseif select_direction == "Grid(1,-1)"
		selected = 3
	elseif select_direction == "Grid(0,-1)"
		selected = 4
	elseif select_direction == "Grid(-1,-1)"
		selected = 5
	elseif select_direction == "Grid(-1,0)"
		selected = 6
	elseif select_direction == "Grid(-1,1)"
		selected = 7
	end
	
	return selected
end

# ╔═╡ 2e8f6b24-5138-4421-8eb3-d28fe0f1436b
md"""
##### The storage of Turtle data
"""

# ╔═╡ 8b3e1b1d-da4f-463d-8827-21ee87b6c04b
function initialize_datadraw()
	data = Dict{Int, Tuple{Symbol, Int}}() 
	# To store the color and direction of each line drawn
	return data
end

# ╔═╡ f351781f-d303-437d-86f7-e1e5b4830963
function update_datadraw(data, color, direction)
	lengthdata = length(data) + 1
	data[lengthdata] = (color, direction) # To add a set of values in the datadraw
	return data
end

# ╔═╡ cdfd9aeb-1038-44e5-8ceb-449b3bed1a3c
md"""
##### The change of player/color
"""

# ╔═╡ bd5b2e32-91fb-4322-bdc6-18971e34be26
md"""
##### The functions to play the game
"""

# ╔═╡ 72db2593-9a7c-47aa-9e82-a5da4780d75b
md"""
##### The functions for the bot
"""

# ╔═╡ b71743da-e8b7-4abb-b04c-81b992278d97
begin
	mutable struct Bot
		attempts :: Int # To avoid StackOverFlow errors
		randomness :: Float64 # The temperature for the bot moves
	end
		
	bot = Bot(0,1) # Initialize the structure
end

# ╔═╡ 3a0c3943-22c4-405e-a9c4-9c9c9ccace78
function probabilities(directions)
	
    probabilities = Float64[] # Array where all the probabilities will go
	T = bot.randomness # The temperature given by the user

    for dir in directions
        if dir == 0 # Up
            push!(probabilities, exp(1/T)) # Weight of 1
        elseif dir == 1 # Right + Up
            push!(probabilities, exp(1/T)) # Weight of 1
        elseif dir == 2 # Right
            push!(probabilities, exp(2/T)) # Weight of 2
        elseif dir == 3 # Right + Down
            push!(probabilities, exp(3/T)) # Weight of 3
        elseif dir == 4 # Down
            push!(probabilities, exp(4/T)) # Weight of 4
        elseif dir == 5 # Left + Down
            push!(probabilities, exp(3/T)) # Weight of 3
        elseif dir == 6 # Left
            push!(probabilities, exp(2/T)) # Weight of 2
        elseif dir == 7 # Left + Up
            push!(probabilities, exp(1/T)) # Weight of 1
        end
    end

	# To transform the probabilities in order that the sum is equal to 1
	probabilities /= sum(probabilities)
	
    return probabilities
end

# ╔═╡ 7042cbe7-1116-4e76-a230-78ccbeb6bfe8


# ╔═╡ b18bbeab-0521-4cbe-9788-616dd5df2c64
md"""
## The constants (defined in Settings section)
These constants define almost everything in the game.
"""

# ╔═╡ 20bf3a92-2e94-467c-848f-965d77ed1596
# I should probably add the constants to the mutable structure but it will take too much time to change everything... so it will stay that way.

# ╔═╡ 7c9a9780-155d-49e6-839f-9ffa21e35d87
const NAME_2 = "The bot"

# ╔═╡ fb115c66-014d-4426-8164-c4bb1641038f


# ╔═╡ 5212cd5a-ced4-4664-8e24-de8946387150
md"""
## Settings
The values displayed here (by default) are the settings of the "real" game. \
Feel free to change them to make the game easier or harder.
"""

# ╔═╡ 7fd2447d-db67-4247-aa3c-beafe03fbdbd
md"""
**Small explaination about the last setting**\
It influences the probability associated with the directions that the bot can choose.\


It is commonly refered as "the temperature" when discusing GPTs (_Generative Pretrained Transfomers_).\
Here, when the temperature is low, the probabilities tend to go to the most weighted direction (heading towards the player's goal). And when the temperature is high, all the directions have nearly equal probability (resulting in the bot playing randomly).
"""

# ╔═╡ 7980d97e-ff7f-4cef-92ae-9af386c513a9


# ╔═╡ 334ea312-b0d6-4337-aa14-8fef1ee50302
md"""
## The Game: "Paper Soccer" 
"""

# ╔═╡ 4d7aaf09-d62f-4c91-b699-b4d5c87d83d3


# ╔═╡ 2ce24faf-89c4-404e-a2fe-470a76f86bb2
md"""
## HTML → Boutons
Thanks to _de Villenfagne de Vogelsanck_ who helped a bit with this part.
"""

# ╔═╡ ab098fd2-ebdc-403c-a2a2-079b3981fe93
md"""
##### Grid structure (to create the svg at the right place)
"""

# ╔═╡ 339b155f-acec-4376-a372-8201b46ba892
struct Grid
	col
	row
end

# ╔═╡ d933e888-3cc5-4282-8b7e-21be82b5c3f9
function select_interface()
	
	grids=[]
	
	for grid in [Grid(a,b) for a in -1:1, b in reverse(collect(-1:1))]
		push!(grids,grid)
	end

	output = String[]
	
	for grid in grids
		push!(output,"Grid($(grid.col),$(grid.row))")
	end
	
	return output
end

# ╔═╡ ac022121-7ebd-4bf8-8900-10731bc071aa
md"""
##### Design of the arrows/ball
"""

# ╔═╡ 03692153-4523-4ac1-b2d4-4b0f226c46e6
function Angle(grid1,grid2) # To get the right orientation for the arrows

	dx = grid2.col - grid1.col
	dy = grid2.row - grid1.row
	
	localgrid = Grid(dx,dy)
	
	return -rad2deg(angle(localgrid.col + localgrid.row*im)) + 90
end

# ╔═╡ f16837d7-5965-4964-b11b-c44924de18af
function draw_arrows(grid,action)
	
	if action == "begin" && grid.col == -1
		return @htl("""<div>""")
	end
	
	if action =="svg"
			
		if grid.col==0 && grid.row==0 # Draw a ball in the middle
				
			return  @htl("""<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" fill="black" stroke="black" stroke-width="1"/></svg>""")
				
		else # To draw all the arrows around the ball
				
			return  @htl("""<svg viewBox="0 0 24 24" transform="rotate($(Angle(Grid(0,0),grid)) 0 0)"><path d="M14,20 H10 V11 L6.5,14.5 L4.08,12.08 L12,4.16 L19.92,12.08 L17.5,14.5 L14,11 V20" /></svg>""")
			
		end
	end

	if action == "end" && grid.col == 1
		return @htl("""</div>""")
	end
end

# ╔═╡ 85a6ed33-a693-4b4e-a88a-d31579c24c9e
begin
	begin
		local result = begin

			struct Radio
			    options
			    default
			end
		end
		
	Radio(options; default=nothing) = Radio([o => o for o in options], default)
	Radio(options::AbstractVector{<:Pair{<:AbstractString,<:Any}}; default=nothing) = Radio(options, default)
	
	function Base.show(io::IO, m::MIME"text/html", radio::Radio)
		
	    groupname = randstring('a':'z')
		
		 h = @htl("""
        <form class="direction">$(
        map(radio.options) do o
			
        @htl("""
                 $(draw_arrows(eval(Meta.parse(o.first)),"begin"))
                     <label for=$(groupname * o.first)>
                     <input $((
                                 type="radio",
                                 id=(groupname * o.first),
                                name=groupname,
                                value=o.first,
                                checked=(radio.default === o.first)
                            ))>
                    $(draw_arrows(eval(Meta.parse(o.first)),"svg"))                        </label>
                $(draw_arrows(eval(Meta.parse(o.first)),"end"))
            """)
        end)
    	
        <script>
			const form = currentScript.parentElement
	        const selected_radio = form.querySelector('input[checked]')
		
			let val = selected_radio?.value 	// "?" avoid errors if no value
			Object.defineProperty(form, "value", {
				get: () => val,
				set: (newval) => {
					val = newval
					const i = document.getElementById($groupname + newval)
					if(i != null){ 
						i.checked = true 		// Change the "state" of the checkbox
					}
				},
			})
	        form.oninput = (e) => {
	            val = e.target.value 			// Return the value on click
	        }
		</script>


		<style>
			form {
				text-align: center; 			// Put the arrows in the center
			}
		 
			input[type="radio"] {
				position: absolute;
				opacity: 0; 					// Make the checkbox invisible
			}

			input[type="radio"] + svg {
		 		height: 2rem; 					// Size icons (2 * size root element)
			}
		 
			input[type="radio"] + svg {
		 		fill: rgb(242, 242, 242); 		// 1st color of the arrows (lightgrey)
		 	}
			
			input[type="radio"]:hover + svg{ 
				fill: rgb(0, 204, 204);			// 2nd color of the arrows (blue)
			}

		 	input[type="radio"]:checked + svg{ 
				fill: rgb(0, 204, 79);		   	// 3rd color of the arrows (green)
			}
		</style>
		
			""")
		
		show(io, m, h) 
	end
	
	Base.get(radio) = radio.default
	
		
		Bonds.initial_value(select) = select.default
		Bonds.possible_values(select) = first.(select.options)
		
		function Bonds.validate_value(select, val)
			val ∈ (first(p) for p in select.options)
		end
		
		result
	end
	
	md"""Code for the arrows (modified version from PlutoUI)"""
end

# ╔═╡ 1c7a809f-62d6-488b-aded-5d8e34d74868
md"""
Choose the number of **rows** you want: 
$(@bind choose_rows NumberField(8:2:20, default=10))
"""

# ╔═╡ ca6b306f-a979-40b0-bbe5-d1b04fe0f4e0
const ROWS = choose_rows + 2 # Number of rows (+2)

# ╔═╡ c4c55706-9e9c-451f-8c60-aac569f9b8ff
function update_grid(grid, coords)
			if haskey(grid, coords) # To check if the coordinate is in the grid
				if grid[coords] == 0 # Check the state of the position
	        		grid[coords] = 1 # Assign 1 to "Used" coordinates
				elseif grid[coords] == 1
					println("Please replay")
				end
			end
	
			if coords == (0,ROWS/2) || coords == (0,-ROWS/2)
	    		println("GOAL!")
	    	end
	    return grid
	end

# ╔═╡ a377a8c4-f56e-4941-ae82-bb734b6b6680
md"""
Choose the number of **columns** you want:
$(@bind choose_cols NumberField(6:2:18, default=8))
"""

# ╔═╡ 48cd35f8-e01f-48b8-ac98-8f28a150250b
const COLS = choose_cols + 2 # Number of columns (+2)

# ╔═╡ 9c63e661-e583-44c8-ae9d-28a5df3eed45
function initialize_grid()
	grid = Dict{Tuple{Int, Int}, Int}() # Create a Dict with coord => state
	for row in -(ROWS/2):(ROWS/2) # Create the y's
	for col in -(COLS/2):(COLS/2) # Create the x's
		
	    if abs(row) == ((ROWS-2)/2) || abs(col) == ((COLS-2)/2)
            grid[(col, row)] = 1 # Set field contour positions to 1
        else
            grid[(col, row)] = 0 # Set field inner positions to 0
        end
	end
    end
	
	# Specific cases:
	grid[(0,(ROWS-2)/2)] = 0; grid[(0,-(ROWS-2)/2)] = 0; grid[(0,0)] = 1
	grid[(0,ROWS/2)] = 0; grid[(0,-ROWS/2)] = 0
	return grid
end

# ╔═╡ 05342582-120d-4deb-b11c-558eb5372929
function initialize_vectors()
	
	vectors = Dict{Tuple{Tuple{Int, Int}, Tuple{Int, Int}}, Int}() # Create dict
	
    grid = initialize_grid()
    keysgrid = collect(keys(grid)) # To get all the different coordinates (array)
	
	for co in 1:length(keysgrid) # To call all the coordinates
			
	coords = keysgrid[co] # 1st coordinate (x1,y1)

		for dir in [0,1,2,3,4,5,6,7] # All directions
			newcoords = new_coords(coords, dir) # 2nd coordinate (x2,y2)
		    vectors[(coords, newcoords)] = 0
		end
		
		if coords[2] == (ROWS-2)/2 # If y1 = upper line
			for a in [6,7,0,1,2] # Forbidden directions from upper line (only 3,4,5)
				nocoords_up = new_coords(coords, a)
				vectors[(coords, nocoords_up)] = 2
			end
				
		elseif coords[2] == -(ROWS-2)/2 # If y1 = lower line
			for b in [2,3,4,5,6] # Forbidden directions from lower line (only 7,0,1)
				nocoords_down = new_coords(coords, b)
				vectors[(coords, nocoords_down)] = 2
			end
			
		elseif coords[1] == -(COLS-2)/2 # If x1 = left line
			for c in [4,5,6,7,0] # Forbidden directions from left line (only 1,2,3)
				nocoords_left = new_coords(coords, c)
				vectors[(coords, nocoords_left)] = 2
			end
		
		elseif coords[1] == (COLS-2)/2 # If x1 = right line
			for d in [0,1,2,3,4] # Forbidden directions from right line (only 5,6,7)
				nocoords_right = new_coords(coords, d)
				vectors[(coords, nocoords_right)] = 2
			end
		end

		# To deal with the corners 
		if coords == ((COLS-2)/2,-(ROWS-2)/2)
			for e in [0,1,2,3,4,5,6] # Only 7 is allowed from SE corner
				nocoordsSE = new_coords(coords, e)
				vectors[(coords, nocoordsSE)] = 2
			end

		elseif coords == (-(COLS-2)/2,-(ROWS-2)/2)
			for f in [0,2,3,4,5,6,7] # Only 1 is allowed from SW corner
				nocoordsSW = new_coords(coords, f)
				vectors[(coords, nocoordsSW)] = 2
			end

		elseif coords == (-(COLS-2)/2,(ROWS-2)/2)
			for g in [0,1,2,4,5,6,7] # Only 3 is allowed from NW corner
				nocoordsNW = new_coords(coords, g)
				vectors[(coords, nocoordsNW)] = 2
			end

		elseif coords == ((COLS-2)/2,(ROWS-2)/2)
			for h in [0,1,2,3,4,6,7] # Only 5 is allowed from NE corner
				nocoordsNE = new_coords(coords, h)
				vectors[(coords, nocoordsNE)] = 2
			end
		end

		# Specific cases:
		vectors[(-1,(ROWS-2)/2),(0,ROWS/2)] = 0 # Diagonal goal up
		vectors[(-1,-(ROWS-2)/2),(0,-ROWS/2)] = 0 # Diagonal goal down
		vectors[(0,(ROWS-2)/2),(0,ROWS/2)] = 0 # Straight line goal up
		vectors[(0,-(ROWS-2)/2),(0,-ROWS/2)] = 0 # Straight line goal down
		vectors[(1,(ROWS-2)/2),(0,ROWS/2)] = 0 # Diagonal goal up
		vectors[(1,-(ROWS-2)/2),(0,-ROWS/2)] = 0 # Diagonal goal down
			
		vectors[(0,(ROWS-2)/2),(1,(ROWS-2)/2)] = 0 # In front of goal up
		vectors[(1,(ROWS-2)/2),(0,(ROWS-2)/2)] = 0
		vectors[(0,(ROWS-2)/2),(-1,(ROWS-2)/2)] = 0 # In front of goal up
		vectors[(-1,(ROWS-2)/2),(0,(ROWS-2)/2)] = 0
		vectors[(0,-(ROWS-2)/2),(1,-(ROWS-2)/2)] = 0 # In front of goal down
		vectors[(1,-(ROWS-2)/2),(0,-(ROWS-2)/2)] = 0
		vectors[(0,-(ROWS-2)/2),(-1,-(ROWS-2)/2)] = 0 # In front of goal down
		vectors[(-1,-(ROWS-2)/2),(0,-(ROWS-2)/2)] = 0
	end
    return vectors
end

# ╔═╡ 95275f8a-55e8-4ff8-93f4-bb74363e6609
md"""
Choose the **size of the squares** you want: 
$(@bind choose_size NumberField(20:100, default=80))
"""

# ╔═╡ 0e34f0d4-29bc-4ccf-ba97-8d6cb27228dc
const SIZE = choose_size # Size of the squares

# ╔═╡ 123699c9-f286-4cb7-aafe-2220d15dcf53
function draw_grid(t)
		# Go to the S-W of the window
		penup(t)
		forward(t, -((COLS*SIZE)/2))
		turn(t, -90)
		forward(t, -((ROWS*SIZE)/2))
		pendown(t)
		# Beginning of the drawing
		pencolor(t, :lightgrey)
		for col in 1:COLS
        for row in 1:ROWS
			# Create a square
            for side in 1:4
                forward(t, SIZE)
                turn(t, 90)
            end
            penup(t)
            forward(t, SIZE)
            pendown(t)
        end
		# Go back to the start of the row
        penup(t)
        forward(t, -(SIZE * ROWS))
        turn(t, 90)
        forward(t, SIZE)
        turn(t, -90)
        pendown(t)
    	end
		# Go to the S-W of the window
		penup(t)
		turn(t, 90)
		forward(t, -(SIZE*COLS))
		turn(t, 180)
		pendown(t)
	end

# ╔═╡ 2644f9f1-d1f1-4229-9f98-e8d1388297e1
function draw_field(t)
		# Go to the right place to draw
		penup(t)
		forward(t, -SIZE)
		turn(t, 90)
		forward(t, SIZE)
		pendown(t)
	
		# Start Drawing the field (A OPTIMISER)
		pencolor(t, :black)
		forward(t, SIZE*(ROWS-2))
		turn(t, 90)
		forward(t, SIZE*((COLS-2)/2 - 1))
		turn(t, -90)
		forward(t, SIZE)
		turn(t, 90)
		forward(t, SIZE*2)
		turn(t, 90)
		forward(t, SIZE)
		turn(t, -90)
		forward(t, SIZE*((COLS-2)/2 - 1))
		turn(t, 90)
		forward(t, SIZE*(ROWS-2))
		turn(t, 90)
		forward(t, SIZE*((COLS-2)/2 - 1))
		turn(t, -90)
		forward(t, SIZE)
		turn(t, 90)
		forward(t, SIZE*2)
		turn(t, 90)
		forward(t, SIZE)
		turn(t, -90)
		forward(t, SIZE*((COLS-2)/2 - 1))
	end

# ╔═╡ 74b99252-d3bf-4a5d-874d-80a97e5ed93a
function draw_start(t)
	draw_grid(t) # Draw the background grid
	draw_field(t) # Draw the limits of the field

	# Set Position in the center
	penup(t)
	turn(t, 90)
	forward(t, (SIZE*(ROWS-2))/2)
	turn(t, 90)
	forward(t, (SIZE*(COLS-2))/2)
	pendown(t)
	turn(t, -90)
end

# ╔═╡ 38556268-1dcd-4314-8273-de78d9cad8ef
function add_line(t, color, n) # To move the ball (graphically)
	pencolor(t, color) # Change the color of the pen (color::Symbol)		
	turn(t, n*45)
	if mod(n, 2) != 0
		forward(t, sqrt(2)*SIZE) # Diagonal movement
	else
		forward(t, SIZE) # Straight movement
	end
	turn(t, -n*45) # Set the pen looking to the 0-position
end

# ╔═╡ 306f6167-076e-4287-95dd-866f17e959a1
md"""
Choose the **radius of the ball**: 
$(@bind choose_radius NumberField(1:20, default=5))
"""

# ╔═╡ e4ed4dd0-4d07-4b13-ab47-bf82bfcae7a9
const RADIUS_BALL = choose_radius # Radius of the ball

# ╔═╡ 29a527be-8b10-4b0f-abe7-e9fbaa7c59fe
function draw_ball(t)
	
		# Set the position of the Turtle to create the circle
		penup(t)
		turn(t, 90)
		forward(t, RADIUS_BALL)
		turn(t, -90)
		pendown(t)
	
		# Draw the circle
		l = (2π * RADIUS_BALL) / 360
		for k in 1:360
        	forward(t, l)
        	turn(t, -1)
    	end
	
		# Back to initial position
		penup(t)
		turn(t, -90)
		forward(t, RADIUS_BALL)
		pendown(t)
	end

# ╔═╡ fd26c617-1f96-4510-a703-8cf1bd4d636c
md"""
Choose the **name of the player**:
$(@bind name_player_1 TextField(default="Player"))
"""

# ╔═╡ 0551c5c9-8b1a-477c-b70c-4e7a05b33b07
const NAME_1 = name_player_1

# ╔═╡ 5feedf68-ba7a-40df-8892-e72f6c59a83c
md"""
Choose the **color of the player**:
$(@bind color_1 Select(["blue", "red", "green", "violet", "orange"], default="blue"))
"""

# ╔═╡ 170f58d7-c567-4f33-a6c0-c336ef6e3f88
const COLOR_1 = Symbol(color_1) # To set the color and String to Symbol

# ╔═╡ 65397e56-b8b3-4fbf-8055-2ce58bfcc240
md"""
Choose the **color of the bot**: 
$(@bind color_2 Select(["blue", "red", "green", "violet", "orange"], default="red"))
"""

# ╔═╡ 79c33fc3-0892-4d42-a4eb-7a71a3b25daa
const COLOR_2 = Symbol(color_2) # To set the color and String to Symbol

# ╔═╡ c047cb7c-7f9d-4b4f-a906-3fd1e95b0c56
md"""
Choose the **randomness of the bot**:
$(@bind randomness Slider(0.05:0.01:2))
Level of difficulty ?
"""

# ╔═╡ f1f115b2-b217-473c-bf1f-991b56fa6ca1
bot.randomness = randomness

# ╔═╡ bbeb6053-aec5-4533-a983-cb9e91c69373
md"""Click on the black ball then here to reset the game: $(@bind resetbutton Button("Reset Game"))"""

# ╔═╡ 4862da43-a86a-4c85-afd5-5c4058dbb887
begin
	resetbutton # Runs when pressing "Reset Game" (the rest of the cell runs too)
	
	resetgame = GameState((0,0), initialize_grid(), initialize_vectors(), initialize_datadraw(),NAME_1, Symbol(COLOR_1)) # Initialize gamestate
	
	const gamestate = resetgame

	md"""Here is the code that runs when pressing "Reset Game" button:"""
end

# ╔═╡ 71c7233f-b2f3-459b-b0fa-787c79bc534a
function loosing_conditions()
	
	test = 0
	
	coords = gamestate.coords

# To try from any other coordinate in the grid
	for dir in [0,1,2,3,4,5,6,7] # All directions
		newcoords = new_coords(coords, dir)
		if values(gamestate.vectors[coords,newcoords]) == 0
			test += 1 # Add 1 if the vector is free
		end
	end

	if test == 0
		println("The game is over, you cannot move.")
	end
end

# ╔═╡ 7f92691e-87b9-46cb-9d26-b9c2edf557ad
function draw_datadraw(t)
	for key in 1:length(gamestate.datadraw) # To get the right order
		eachdata = gamestate.datadraw[key] # To get the color and dir of each line
		
		color = eachdata[1] # To get the color
		direction = eachdata[2] # To get the direction
		
		add_line(t, color, direction) # To draw the line(s) on the Turtle
	end
end

# ╔═╡ dd4c1194-bec0-4788-aa17-f187da35899d
function change_color_name()
	if gamestate.player == NAME_1
		gamestate.player = NAME_2 # Change from 1 to 2
		gamestate.color = COLOR_2
	elseif gamestate.player == NAME_2
		gamestate.player = NAME_1 # Change from 2 to 1
		gamestate.color = COLOR_1
	end
end

# ╔═╡ 9d6cdcee-dbe6-4c90-aaa1-7d0234aa20ce
function update_game(direction)

	coords = gamestate.coords # To avoid problems updating the coordinates
	newcoords = new_coords(coords, direction) # The new coordinates (maybe)
	
	if values(gamestate.vectors[coords, newcoords]) == 1
		println("Already used, choose another direction.")
		
	elseif values(gamestate.vectors[coords, newcoords]) == 2
		println("You are not allowed to go that way.")
		
	elseif values(gamestate.vectors[coords, newcoords]) == 0 # Update only if = 0
		gamestate.coords = new_coords(coords, direction)
		gamestate.grid = update_grid(gamestate.grid, newcoords)
		gamestate.vectors = update_vectors(gamestate.vectors, coords, newcoords)
	end
end

# ╔═╡ 0cd1f4ee-6e4e-481a-a364-8f92b3879c0c
function play_game(direction)
	
	coords = gamestate.coords # Initial position of the ball
	newcoords = new_coords(coords, direction) # Final position of the ball
	
	if values(gamestate.vectors[coords, newcoords]) == 0 # Draw only if not used
	gamestate.datadraw = update_datadraw(gamestate.datadraw, gamestate.color, direction)
	end
	
	t = Turtle() 
	draw_start(t) # To draw the field
	draw_datadraw(t) # To draw the line(s) on the Turtle
	draw_ball(t)

	if values(gamestate.grid[newcoords]) == 0 # If the player cannot replay
		if gamestate.vectors[coords, newcoords] == 0 # Not leading out
			change_color_name()
		end
	end
		
	
	update_game(direction) # Update the grid, vectors and coords
	
	loosing_conditions() # To check if the player can move
	
	Drawing(t, SIZE*COLS, SIZE*ROWS) # Open the drawing window
end

# ╔═╡ feacf934-8bea-442c-9f32-43aa1455de62
function directions()
	
    directions = Int[] # Array where all the possible directions will go

    for dir in 0:7 # All directions (used and not used)
		
        newcoords = new_coords(gamestate.coords, dir)

        if gamestate.vectors[gamestate.coords, newcoords] == 0
            push!(directions, dir) # Add the direction to the array if it is not used
        end
    end
	
    return directions
end

# ╔═╡ d442eb37-b61c-4a8c-9a4f-aaa767be53f3
function nogo_conditions(direction)
	
	newcoords = new_coords(gamestate.coords, direction)
	
	vectors = gamestate.vectors
	test = 0
	for dir in 0:7
		new = new_coords(newcoords, dir) 
		if vectors[newcoords, new] == 0 # Check if the ball can leave the position
			test += 1
		end
	end
	
	if test <= 1
		return false # The bot shall no go that way if it cannot move afterwards
	end
	
	
	# Some positions are forbidden, the bot shall not go there.
		# The 4 corners
		# The positions in front of the goal if the bot cannot replay
		# The 2 positions creating StackOverFlow errors 
			# → there are 4 possible directions but they are all forbidden
	
	nogo1 = [(-2, ((ROWS-2)/2)-1),(-1,((ROWS-2)/2)-1),(0,(ROWS-2)/2),(0,((ROWS-2)/2)-1),(1,((ROWS-2)/2)-1), (2,((ROWS-2)/2)-1)] 
	for pos1 in nogo1
		if gamestate.grid[pos1] == 0
			if newcoords == pos1
				return false # The bot shall not go if the coord has never been used
			end
		end
	end
	
	nogo2 = [(-1, (ROWS-2)/2), (1, (ROWS-2)/2)] # They create StackOverFlow errors
	if newcoords ∈ nogo2
		return false # The bot shall not go to the 2 sides of the goal
	end
	
	
	nogo3 = [((COLS-2)/2,(ROWS-2)/2),(-(COLS-2)/2,-(ROWS-2)/2),(-(COLS-2)/2,(ROWS-2)/2),((COLS-2)/2,-(ROWS-2)/2), (0, ROWS/2)]
	if newcoords ∈ nogo3
		return false # The bot shall never go in any of the corners
	end
	
	
	return true # Return true if the ball won't go in a forbidden position
end

# ╔═╡ 88224ef4-8637-4102-b071-45a43c352073
function go_goal(dir)

	direction = 8 
	
	if gamestate.coords == (-2,-((ROWS-2)/2)+1)
		direction = 3

	elseif gamestate.coords == (-1,-((ROWS-2)/2)+1)
		direction = 4

	elseif gamestate.coords == (0,-((ROWS-2)/2)+1)
		direction = 4

	elseif gamestate.coords == (1,-((ROWS-2)/2)+1)
		direction = 4

	elseif gamestate.coords == (2,-((ROWS-2)/2)+1)
		direction = 5

	elseif gamestate.coords == (-1,-(ROWS-2)/2)
		direction = 3

	elseif gamestate.coords == (0,-(ROWS-2)/2)
		direction = 4

	elseif gamestate.coords == (1, -(ROWS-2)/2)
		direction = 5
	end

	if direction != 8 # If it has been changed
		
		newcoords = new_coords(gamestate.coords, direction)
		
		if gamestate.vectors[gamestate.coords, newcoords] == 0 # Vector free
			
			return direction 
		end
	end
		
	return dir # If nothing is returned, the initial direction is returned 
end

# ╔═╡ 3a28ab9d-2751-41ae-b07c-22bd339b73b1
function go_direction()
	
	coords = gamestate.coords # Initial position of the ball
	test = 0
	
	for direction in [4,3,5,2,6,1,7,0] # The order of this array matter
		
		newcoords = new_coords(coords, direction)
		
		if gamestate.grid[newcoords] == 1 && gamestate.vectors[coords, newcoords] == 0
			
			for dir in [0,1,2,3,4,5,6,7]
				new = new_coords(newcoords, dir)
				if gamestate.vectors[newcoords, new] == 0 # Check the next directions
					test += 1
				end
			end
			if test > 1 # Check if the bot is not blocked after moving
				
				if coords == (-3, (ROWS-2)/2-1) && newcoords == (-2, (ROWS-2)/2)
					return nothing # The bot shall not make this move
				elseif coords == (3, (ROWS-2)/2-1) && newcoords == (2, (ROWS-2)/2)
					return nothing  # The bot shall not make this move
				else
					return direction # Return direction if the bot can replay
				end
			end
		end
	end
end

# ╔═╡ efb3d473-338c-4fee-a179-9b6c04cf7798
function check_blocked(direction)
	
	# We already know that the bot can go in that direction without being blocked after its move. Now, let's go a bit further.

	new1 = new_coords(gamestate.coords, direction)

	if new1 == (0, -ROWS/2)
		return true
	end
	
	dirs1 = Int[]
	for dir1 in 0:7
		new2 = new_coords(new1, dir1)
		if gamestate.vectors[new1, new2] == 0 && gamestate.grid[new2] == 1
			# Add the possible directions of the bot after its move if it can replay
			push!(dirs1, dir1)
		end
	end

	dirs2 = Int[]
	test2 = 0
	for dir1 in dirs1
		new2 = new_coords(new1, dir1)
		for dir2 in 0:7
			new3 = new_coords(new2, dir2)
			if gamestate.vectors[new2, new3] == 0
				test2 += 1
				if gamestate.grid[new3] == 0
					push!(dirs2, dir2)
				end
			end
		end
	end
	
	if length(dirs1) == 2 # Forced path
		if test2 < 2
			return false # Return false if forced moves → the bot is blocked
		end
	end

	# 'else' could be useful here ??
	
	test3 = 0
	for dir1 in dirs1
		new2 = new_coords(new1, dir1)
		for dir2 in dirs2
			new3 = new_coords(new2, dir2)
			for dir3 in 0:7
				new4 = new_coords(new3, dir3)
				if gamestate.vectors[new3, new4] == 0
					test3 += 1
				end
			end
		end
	end

	if length(dirs2) == 2 # Forced path
		if test3 < 2
			return false # Return false if forced moves → the bot is blocked
		end
	end

	return true
end

# ╔═╡ 73e717b9-bb76-463b-8b14-f96d8a189ffc
function run_bot()
	
	dirs = directions() # To get the possible directions from actual coords
	
	if length(dirs) == 0
		error("No directions are available, you already beat the bot, well done")
		
	elseif length(dirs) == 1
		return dirs[1] # If only one direction is possible, return it directly
	end
	
	value = go_direction()
		
	if value ∈ [0,1,2,3,4,5,6,7] # If a direction is choosen by go_direction()
		if nogo_conditions(value)
				value = go_goal(value) # Change the direction if the bot can score
			return value
		end
	end
	
	proba = probabilities(dirs) # Get the directions probabilities
	dist = Categorical(proba) # Create a discrete distribution
	index = rand(dist) # Generate a random index from the distribution above
	direction = dirs[index] # Select the 'random' direction
	direction = go_goal(direction) # Change the direction if the bot can score

	if nogo_conditions(direction) == true
		if check_blocked(direction)
			return direction # Return if conditions are ok + bot not blocked (3 moves)
		end
	else
			
		if length(dirs) == 2 # If 2 dirs && 1 is nogo → return the other
			if dirs[1] == direction # (avoid StackOverFlow errors if both are nogo)
				return dirs[2] 
			elseif dirs[2] == direction
				return dirs[1]
			end
		else
			if bot.attempts > 50
				return direction
			else
				bot.attempts += 1
				run_bot()
			end
		end
	end
end

# ╔═╡ 9e5fff7e-1251-40dd-bd81-906f96463aba
md"""
$(@bind select_direction Radio(select_interface(), default="Grid(0,0)"))
"""

# ╔═╡ e7ee9c6b-f54a-4ff7-ade4-83e3eec46c39
function play()


	if gamestate.coords != (0, ROWS/2) && gamestate.coords != (0, -ROWS/2)
		if gamestate.player == NAME_1 # The player's turn
			direction = direction_selected(select_direction) # direction from arrows
			
		elseif gamestate.player == NAME_2 # The bot's turn
			bot.attempts = 0
			direction = run_bot() # direction of the bot
		end
		
		if direction == "#" # At the beginning of the game
			t = Turtle() 
			draw_start(t) # Draw the field (grid + borders)
			draw_ball(t) # Draw the ball in the center
			Drawing(t, SIZE*COLS, SIZE*ROWS) 
		else
			play_game(direction) # Move the ball and update gamestate
		end
	else
		println("The game is already finished, please reset to play again")
		t = Turtle() 
		draw_start(t) # To draw the field
		draw_datadraw(t) # To draw the line(s) on the Turtle
		draw_ball(t)
		Drawing(t, SIZE*COLS, SIZE*ROWS)
	end
end

# ╔═╡ 046a7b1a-3dd9-4a48-bc84-c28a9f509c13
md"""
Click here to go in the same direction as the last one:  
$(@bind go Button("Go"))
or to play for the bot
"""

# ╔═╡ cb8f0243-1673-4849-9c42-67fe90af1527
begin
	go
	
	play()
end

# ╔═╡ Cell order:
# ╟─ef51ba50-f663-11ee-0491-35648200404a
# ╟─9675811b-e9c4-46c0-a8d3-307835670bbb
# ╠═a3867900-d5e1-4b4d-85ce-20a157fab8b3
# ╟─7bc85cb3-3f65-4da3-99f2-bf4e7db30924
# ╟─f3795a18-c6bd-4d4d-9f2b-3f6bc7b8e85d
# ╟─123699c9-f286-4cb7-aafe-2220d15dcf53
# ╟─2644f9f1-d1f1-4229-9f98-e8d1388297e1
# ╟─74b99252-d3bf-4a5d-874d-80a97e5ed93a
# ╟─23763acb-0991-4108-b16f-b0647f4ce42d
# ╟─29a527be-8b10-4b0f-abe7-e9fbaa7c59fe
# ╟─38556268-1dcd-4314-8273-de78d9cad8ef
# ╟─f048b29c-1f89-4097-ab59-1aa3c046d281
# ╟─43b124e2-e02a-447c-be3c-2efb21978577
# ╟─62dc5827-2a39-43e3-8208-38fa05864ba9
# ╠═f0a5adce-758d-4a66-bac0-841638c0acc8
# ╟─d81398d0-627e-4c04-ab05-d29cef5a0ba3
# ╟─aeca3167-0647-44cd-89a3-66ee1cc86ffd
# ╟─9c63e661-e583-44c8-ae9d-28a5df3eed45
# ╟─c4c55706-9e9c-451f-8c60-aac569f9b8ff
# ╟─d1936a54-1c93-495d-b3fa-7bcace3b11cf
# ╟─05342582-120d-4deb-b11c-558eb5372929
# ╟─cecba161-e3a6-42c8-928c-a787e54ae085
# ╟─71c7233f-b2f3-459b-b0fa-787c79bc534a
# ╟─2176ab9f-3185-438b-bc81-784d856eac0b
# ╟─2e8f6b24-5138-4421-8eb3-d28fe0f1436b
# ╟─8b3e1b1d-da4f-463d-8827-21ee87b6c04b
# ╟─f351781f-d303-437d-86f7-e1e5b4830963
# ╟─7f92691e-87b9-46cb-9d26-b9c2edf557ad
# ╟─cdfd9aeb-1038-44e5-8ceb-449b3bed1a3c
# ╟─dd4c1194-bec0-4788-aa17-f187da35899d
# ╟─bd5b2e32-91fb-4322-bdc6-18971e34be26
# ╟─4862da43-a86a-4c85-afd5-5c4058dbb887
# ╟─0cd1f4ee-6e4e-481a-a364-8f92b3879c0c
# ╟─9d6cdcee-dbe6-4c90-aaa1-7d0234aa20ce
# ╟─e7ee9c6b-f54a-4ff7-ade4-83e3eec46c39
# ╟─72db2593-9a7c-47aa-9e82-a5da4780d75b
# ╠═b71743da-e8b7-4abb-b04c-81b992278d97
# ╟─feacf934-8bea-442c-9f32-43aa1455de62
# ╟─3a0c3943-22c4-405e-a9c4-9c9c9ccace78
# ╟─d442eb37-b61c-4a8c-9a4f-aaa767be53f3
# ╟─88224ef4-8637-4102-b071-45a43c352073
# ╟─3a28ab9d-2751-41ae-b07c-22bd339b73b1
# ╟─73e717b9-bb76-463b-8b14-f96d8a189ffc
# ╟─efb3d473-338c-4fee-a179-9b6c04cf7798
# ╟─7042cbe7-1116-4e76-a230-78ccbeb6bfe8
# ╟─b18bbeab-0521-4cbe-9788-616dd5df2c64
# ╠═20bf3a92-2e94-467c-848f-965d77ed1596
# ╠═ca6b306f-a979-40b0-bbe5-d1b04fe0f4e0
# ╠═48cd35f8-e01f-48b8-ac98-8f28a150250b
# ╠═0e34f0d4-29bc-4ccf-ba97-8d6cb27228dc
# ╠═e4ed4dd0-4d07-4b13-ab47-bf82bfcae7a9
# ╠═0551c5c9-8b1a-477c-b70c-4e7a05b33b07
# ╠═170f58d7-c567-4f33-a6c0-c336ef6e3f88
# ╠═7c9a9780-155d-49e6-839f-9ffa21e35d87
# ╠═79c33fc3-0892-4d42-a4eb-7a71a3b25daa
# ╠═f1f115b2-b217-473c-bf1f-991b56fa6ca1
# ╟─fb115c66-014d-4426-8164-c4bb1641038f
# ╟─5212cd5a-ced4-4664-8e24-de8946387150
# ╟─1c7a809f-62d6-488b-aded-5d8e34d74868
# ╟─a377a8c4-f56e-4941-ae82-bb734b6b6680
# ╟─95275f8a-55e8-4ff8-93f4-bb74363e6609
# ╟─306f6167-076e-4287-95dd-866f17e959a1
# ╟─fd26c617-1f96-4510-a703-8cf1bd4d636c
# ╟─5feedf68-ba7a-40df-8892-e72f6c59a83c
# ╟─65397e56-b8b3-4fbf-8055-2ce58bfcc240
# ╟─c047cb7c-7f9d-4b4f-a906-3fd1e95b0c56
# ╟─7fd2447d-db67-4247-aa3c-beafe03fbdbd
# ╟─7980d97e-ff7f-4cef-92ae-9af386c513a9
# ╟─334ea312-b0d6-4337-aa14-8fef1ee50302
# ╟─bbeb6053-aec5-4533-a983-cb9e91c69373
# ╟─9e5fff7e-1251-40dd-bd81-906f96463aba
# ╟─046a7b1a-3dd9-4a48-bc84-c28a9f509c13
# ╟─cb8f0243-1673-4849-9c42-67fe90af1527
# ╟─4d7aaf09-d62f-4c91-b699-b4d5c87d83d3
# ╟─2ce24faf-89c4-404e-a2fe-470a76f86bb2
# ╟─85a6ed33-a693-4b4e-a88a-d31579c24c9e
# ╟─ab098fd2-ebdc-403c-a2a2-079b3981fe93
# ╠═339b155f-acec-4376-a372-8201b46ba892
# ╟─d933e888-3cc5-4282-8b7e-21be82b5c3f9
# ╟─ac022121-7ebd-4bf8-8900-10731bc071aa
# ╟─03692153-4523-4ac1-b2d4-4b0f226c46e6
# ╟─f16837d7-5965-4964-b11b-c44924de18af
