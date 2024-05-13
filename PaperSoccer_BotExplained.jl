### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ fff4dd20-112e-11ef-1c61-03711c01c1e5
begin
    import Pkg
	io = IOBuffer()
    Pkg.activate(io = io)
	deps = [pair.second for pair in Pkg.dependencies()]
	direct_deps = filter(p -> p.is_direct_dep, deps)
    pkgs = [x.name for x in direct_deps]
	if "NativeSVG" ∉ pkgs
		Pkg.add(url="https://github.com/BenLauwens/NativeSVG.jl.git")
	end

	using NativeSVG
end

# ╔═╡ 53d817f6-5117-41b3-9020-a16276bb6d3b
md"""
# Project Julia - ES123
First programming project at the Royal Military Academy (Belgium)

For the final exam of the ES123 (Computer Algorithms and Programming Project) course taught by Ben Lauwens, each student had to choose a game from a provided list and create it using Pluto.jl

There are two versions of the game:

- The multiplayer version called _PaperSoccer.jl_
- The player vs. Bot version called _PaperSoccer-Bot.jl_

And a notebook explaining how the bot is working called _PaperSoccer-BotExplained.jl_

Here, you are currently on the _PaperSoccer-BotExplained.jl_ version. You can find the other version on my GitHub page:
"""

# ╔═╡ 9eefbc22-9c41-46c9-bccd-c1e3a336322d
# https://github.com/aurelienhbts/PlutoPaperSoccer.jl

# ╔═╡ db2e09ba-72d9-4baa-b6f9-8b94444a4865
md"""
## Diagrams
If the stroke of the rectangle is red, it is a reference to another function (and another diagram).\
And if it is green, the function returns a value to the 'play' function. 
"""

# ╔═╡ 4156de35-08f7-4af2-a925-06540a67f162
md"""
#### Explaination of the main function 'run_bot'
This function connects all the other functions.
"""

# ╔═╡ 45fd4342-e646-4faa-b089-6229a443ecbb


# ╔═╡ 5f5fa1cd-62d0-40b3-908c-10d00f9e2ee9
md"""
#### Diagram for the 'go_direction' function
This function returns a direction if there exist a direction where the bot can replay. It returns 'nothing' otherwise.
"""

# ╔═╡ 7a6753b3-ba1e-45d7-9cf5-e946a5203771


# ╔═╡ e05b6c23-bf36-4285-b4a8-16befe212a4a
md"""
#### Diagram for the 'nogo_directions' function
Check if the bot is blocked after moving in the previously selected direction or if it will go to some forbidden places (corners, in front of its goal if he cannot replay...).
"""

# ╔═╡ 2fcb3590-415a-4f92-8207-eff27c19ef88


# ╔═╡ 0dcae0e7-8b00-427a-a01e-ad4523519e27
md"""
#### Diagram for the 'go_goal' function
This function gives a new direction if the bot is at some precise locations. If the conditions are not fullfilled, the previous direction will be returned.
"""

# ╔═╡ bd444771-2ef7-4e98-bed9-6bda9e5bb7cc


# ╔═╡ 17407972-ac6b-492a-b334-2e314633e668
md"""
#### Diagram for the 'check_blocked' function
This function checks if the bot is going to be blocked after 3 forced moves.\
If there are only 2 possible directions from the new position (actual + forced), it continues to compute. If there are less than 2 possible directions, return 'false' and if more, return 'true'.\
So, the bot cannot choose a direction that would blocked it in less than 3 forced moves.
"""

# ╔═╡ fb23d190-019f-458a-998e-16894d54890b
# The layout is from lecture11.jl

Drawing(width=720, height=310) do
	@info "Diagram for the 'check_blocked' function."
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
	rect(x=310, y=10, width=100, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=315, y=30, font_family="JuliaMono, monospace", font_size="0.7rem", font_weight=600) do
		str("Test directions")
	end
	text(x=315, y=50, font_family="JuliaMono, monospace", font_size="0.7rem", font_weight=600) do
		str("if forced moves")
	end
	line(x1=310, y1=60, x2=260, y2=85, stroke="black", marker_end="url(#arrow)")
	line(x1=410, y1=60, x2=460, y2=85, stroke="black", marker_end="url(#arrow)")
	rect(x=150, y=90, width=100, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=160, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("Not blocked")
	end
	text(x=168, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("continue")
	end
	line(x1=150, y1=140, x2=130, y2=162, stroke="black", marker_end="url(#arrow)")
	rect(x=75, y=170, width=100, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=86, y=190, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("Not blocked")
	end
	text(x=94, y=210, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("continue")
	end
	line(x1=250, y1=140, x2=270, y2=162, stroke="black", marker_end="url(#arrow)")
	rect(x=225, y=170, width=100, height=50, fill="rgb(242, 242, 242)", stroke="green")
	text(x=248, y=190, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("Blocked")
	end
	text(x=230, y=210, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("---> 'false'")
	end
	line(x1=75, y1=220, x2=53, y2=242, stroke="black", marker_end="url(#arrow)")
	rect(x=0, y=250, width=100, height=50, fill="rgb(242, 242, 242)", stroke="green")
	text(x=20, y=270, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("Can move")
	end
	text(x=15, y=290, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("---> 'true'")
	end
	line(x1=175, y1=220, x2=197, y2=242, stroke="black", marker_end="url(#arrow)")
	rect(x=150, y=250, width=100, height=50, fill="rgb(242, 242, 242)", stroke="green")
	text(x=150+25, y=270, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("Blocked")
	end
	text(x=158, y=290, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("---> 'false'")
	end
	rect(x=470, y=90, width=100, height=50, fill="rgb(242, 242, 242)", stroke="green")
	text(x=495, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("Blocked")
	end
	text(x=478, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("---> 'false'")
	end
end

# ╔═╡ e5841d0b-99ff-45d6-98f7-40c8f7f0df5e


# ╔═╡ c65c71cb-7fca-488f-b03e-0cf13b309ec3
begin
function create_rectangles(NameFunction, texts) # Could use texts...

	n = Int(length(texts)/2)
	h = 100 * n # Height of the window
	m = 0
	t_ = 0
	
	Drawing(width=720, height=h) do
		@info "Diagram for the '$NameFunction' function."
		defs() do
        	marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
			end
		end

		for t in texts
			color = "black"
			t_ += 1
			if t != texts[1] 
				if texts[t_-1] == 1 
					color = "red"
				elseif texts[t_-1] == 2
					color = "green"
				end
			end
			if t ∉ [0, 1, 2]
				y = 10 + m * 100
				rect(x=150, y=y, width=420, height=50, fill="rgb(242, 242, 242)", stroke=color)
				
				y_ = y + 35 # The text needs to be in the center y of the rectangle
				x_ = 200 + 160+length(t)/2 * 8.5  # Center the text in x (use REM ??)
				text(x=x_, y=y_, font_family="JuliaMono, monospace", text_anchor="end", font_size="rem", font_weight=600) do
	        		str(t) # The text that will be displayed
	    		end
				
				y1 = y_ + 20
				y2 = y1 + 30
				if t != texts[2n] # Do not draw an arrow if it is the last rectangle
					line(x1=360, y1=y1, x2=360, y2=y2, stroke="black", marker_end="url(#arrow)")
				end
				m += 1 # Update for the next rectangle
			end
		end
	end
end

html"""
	The function for the diagrams:
"""
end

# ╔═╡ 188fd14d-579a-4c8c-9634-d50f239f125d
begin
	text_runbot = [
		0, "Get all the possible directions ",
		2, "If only one option → return 'direction' ",
		1, "If more options → try 'go_direction' ",
		1, "Verify the direction with 'nogo_conditions' ",
		1, "Check if the bot is in a 'go_goal' position ",
		2, "If all conditions ok → return 'direction' ",
		0, "Get the proba associated with the directions ",
		0, "Select a direction using the probabilities ",
		1, "Check if the bot is in a 'go_goal' position ",
		1, "run 'nogo_conditions' and 'check_blocked' ",
		2, "Return 'direction' if the conditions are ok ",
		2, "If 2 dirs and 1st is nogo → return the 2nd ",
		0, "If all conditions fail → run 'run_bot' again ",
		2, "If > 50 attempts, return random direction "
	]
	
	text_godirection = [
		0, "Test the directions with 'gamestate.vectors' ",
		0, "If the bot can replay, set 'direction' ",
		0, "Check if the bot is blocked after moving ",
		2, "Return 'nothing' if move = 1 of 2 forbidden ",
		2, "If the bot is not blocked, return 'direction' "
	]

	text_nogoconditions = [
		0, "Check if the bot is blocked after moving ",
		2, "Return 'false' if it is blocked ",
		2, "Return 'false' if the direction is forbidden ",
		2, "Return 'false' if direction to 1 the corners ",
		2, "Return 'true' if all the conditions are ok "
	]

	text_gogoal = [
		0, "Check the position of the bot ", 
		0, "If at some places, change the 'direction'",
		2, "Return the updated 'direction' ",
		2, "If no update, return the old 'position' "
	]
	
	html"""
	The text for the diagrams:
	"""
end

# ╔═╡ 5da08ddb-c39c-4265-a45a-dbda216d8a5d
create_rectangles("run_bot", text_runbot)

# ╔═╡ 43334e15-1af8-467e-a2c4-0874b073526a
create_rectangles("go_direction", text_godirection)

# ╔═╡ 06431b03-4a14-4100-923c-39feb2aa7b64
create_rectangles("nogo_conditions", text_nogoconditions)

# ╔═╡ 7b6712d7-ea01-4e08-b8e0-8c6991f76492
create_rectangles("go_goal", text_gogoal)

# ╔═╡ 18356b18-cfc1-415b-87a9-3ae634e6eda4


# ╔═╡ 23f7495a-2f5e-4d31-ad6e-1031ff07b869
md"""
## Miscellaneous informations
"""

# ╔═╡ 8f5e5f0a-7267-41d7-8dab-8c9c76a1076f
md""" 
##### The GameState mutable structure:
"""

# ╔═╡ ef080d1a-5743-48df-aa74-ee9641b8b7a5
mutable struct GameState
    coords # To store the actual coords
	grid # To update the status of the different positions
	vectors # To update the status of different directions
	datadraw # To draw all the lines (add one at the time)
	player # To know which player has to play → for the color of the Turtle()
	color # To set the color of the lines
end

# ╔═╡ 5c3306e2-9c61-412a-8b50-dbc55a4032e3
md"""
All the functions of the bot are working thanks to the mutable structure that the game computing system is using.
Here is a quick explanation of all the fields (they are all updated at each move):

- **_coords_**: A tuple that stores the current coordinates of the ball and is updated using the `update_game` function.

- **_grid_**: A dictionary that stores all the coordinates of the grid and their associated state (0 if the position has never been used, and 1 if the position has already been used). This field is updated using the `update_grid` and `update_game` functions.

- **_vectors_**: A dictionary that stores all the vectors of the grid and their associated state (0 if the direction has never been used, 1 if the direction has already been used, and 2 if the direction cannot ever be used). This field is updated using the `update_vectors` and `update_game` functions.

- **_datadraw_**: A dictionary that stores all the data for the turtle (direction and color of each line). A growing number is associated with the data of each move so that each time the game is updated, all the lines can be drawn in the correct order. This field is updated using the `update_datadraw` and `play_game` functions.

- **_player_** and **_color_**: These two fields (a string and a symbol, respectively) store the name of the player currently playing and their color. They are updated using the `change_color_name` and `play_game` functions.
"""


# ╔═╡ e9840a37-5491-41b6-b444-f29a6909b0d2
md"""
##### The Bot mutable structure
"""

# ╔═╡ 7a2428f1-905f-47b9-8ca2-6f233c65e549
mutable struct Bot
	attempts :: Int # To avoid StackOverFlow errors (set a maximum per turn)
	randomness :: Float64 # The temperature for the bot moves
end

# ╔═╡ 49e175b4-a12b-444c-b1db-89685d271d67
md"""
- **_attempts_**: This field stores an integer that grows each time the `run_bot` function is called and is reset at each move of the bot. It has been created to avoid StackOverflow errors. If the count reaches 50 because all the possible directions do not agree with the conditions, the `run_bot` function will return a random direction.

- **_randomness_**: This field stores the temperature (a number between 0.05 and 2). It influences the probability associated with the directions that the bot can choose. It is commonly referred to as "the temperature" when discussing GPTs (Generative Pretrained Transformers). Here, when the temperature is low, the probabilities tend to favor the most weighted direction (heading towards the player's goal). And when the temperature is high, all the directions have nearly equal probability (resulting in the bot playing randomly).
"""


# ╔═╡ Cell order:
# ╟─fff4dd20-112e-11ef-1c61-03711c01c1e5
# ╟─53d817f6-5117-41b3-9020-a16276bb6d3b
# ╠═9eefbc22-9c41-46c9-bccd-c1e3a336322d
# ╟─db2e09ba-72d9-4baa-b6f9-8b94444a4865
# ╟─4156de35-08f7-4af2-a925-06540a67f162
# ╟─5da08ddb-c39c-4265-a45a-dbda216d8a5d
# ╟─45fd4342-e646-4faa-b089-6229a443ecbb
# ╟─5f5fa1cd-62d0-40b3-908c-10d00f9e2ee9
# ╟─43334e15-1af8-467e-a2c4-0874b073526a
# ╟─7a6753b3-ba1e-45d7-9cf5-e946a5203771
# ╟─e05b6c23-bf36-4285-b4a8-16befe212a4a
# ╟─06431b03-4a14-4100-923c-39feb2aa7b64
# ╟─2fcb3590-415a-4f92-8207-eff27c19ef88
# ╟─0dcae0e7-8b00-427a-a01e-ad4523519e27
# ╟─7b6712d7-ea01-4e08-b8e0-8c6991f76492
# ╟─bd444771-2ef7-4e98-bed9-6bda9e5bb7cc
# ╟─17407972-ac6b-492a-b334-2e314633e668
# ╟─fb23d190-019f-458a-998e-16894d54890b
# ╟─e5841d0b-99ff-45d6-98f7-40c8f7f0df5e
# ╟─c65c71cb-7fca-488f-b03e-0cf13b309ec3
# ╟─188fd14d-579a-4c8c-9634-d50f239f125d
# ╟─18356b18-cfc1-415b-87a9-3ae634e6eda4
# ╟─23f7495a-2f5e-4d31-ad6e-1031ff07b869
# ╟─8f5e5f0a-7267-41d7-8dab-8c9c76a1076f
# ╠═ef080d1a-5743-48df-aa74-ee9641b8b7a5
# ╟─5c3306e2-9c61-412a-8b50-dbc55a4032e3
# ╟─e9840a37-5491-41b6-b444-f29a6909b0d2
# ╠═7a2428f1-905f-47b9-8ca2-6f233c65e549
# ╟─49e175b4-a12b-444c-b1db-89685d271d67
