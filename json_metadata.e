note
	description: "Representation of JSON Metadata"
	design: "[
		The design of {JSON_METADATA} is based largely on the type
		definitions of the HTML <input> tag element. See the
		EIS link below for more.
		]"
	EIS: "name=html_input_type_attribute", "src=https://www.w3schools.com/tags/att_input_type.asp"

class
	JSON_METADATA

inherit
	ANY
		redefine
			default_create
		end

create
	default_create,
	make_text_default,
	make_text,
	make_number,
	make_password,
	make_email,
	make_tel,
	make_url,
	make_date,
	make_datetime_local,
	make_time,
	make_month,
	make_week,
	make_button,
	make_checkbox,
	make_radio,
	make_range,
	make_color,
	make_file,
	make_image,
	make_search,
	make_submit,
	make_reset,
	make_hidden

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			type := "text"
			create name.make_empty
			set_is_required
			set_is_for_output
		end

	make_text_default
		do
			default_create
		end

	make_text (a_name: STRING; a_default_value: like default_value)
			-- <input type="text" name="fname">													--> fname=Fred
		do
			default_create
			make (type, a_name, a_default_value)
		end

	make_number (a_name: STRING; a_min, a_max, a_default_value: attached like min)
			-- <input type="number" name="quantity" min="1" max="5" value="3">					--> quantity=3 (or 1,2,4,5)
			-- min/max (optional)							: Only number,range
		do
			make ("number", a_name, a_default_value.out)
			min := a_min
			max := a_max
		end

	make_password (a_name: STRING; a_maxlength: attached like maxlength)
			-- <input type="password" name="pwd" maxlength="8">									--> pwd=asdfsadf (sent plain-text)
			-- maxlength (optional)							: Only password
		do
			make ("password", a_name, Void)
			maxlength := a_maxlength
		end

	make_email (a_name: STRING; a_default_value: like default_value)
			-- <input type="email" name="usremail" value="ljr1981@msn.com">						--> usremail=ljr1981@msn.com
		do
			make ("email", a_name, a_default_value)
		end

	make_tel (a_name: STRING; a_default_value: like default_value)
			-- <input type="tel" name="usrtel">*												--> usrtel=7702959729
			-- * The "tel" type is NOT masked input and user can type anything, so you'll need masking code.
		do
			make ("tel", a_name, a_default_value)
		end

	make_url (a_name: STRING; a_default_value: like default_value)
			-- <input type="url" name="homepage">**												--> Input undetermined
			-- ** I cannot figure out what the valid input and return-to-server values ought to be.
		do
			make ("url", a_name, a_default_value)
		end

	make_date (a_name: STRING; a_default_value: like default_value)
			-- <input type="date" name="bday"> 													--> bday=2017-06-20
		do
			make ("date", a_name, a_default_value)
		end

	make_datetime_local (a_name: STRING; a_default_value: like default_value)
			-- <input type="datetime-local" name="bdaytime"> 									--> bdaytime=2017-06-20T12:58
		do
			make ("datetime-local", a_name, a_default_value)
		end

	make_time (a_name: STRING; a_default_value: like default_value)
			-- <input type="time" name="usr_time">												--> usr_time=20:42 <-- 08:42PM input masked
		do
			make ("time", a_name, a_default_value)
		end

	make_month (a_name: STRING; a_default_value: like default_value)
			-- <input type="month" name="bdaymonth">											--> bdaymonth=2017-06
		do
			make ("month", a_name, a_default_value)
		end

	make_week (a_name: STRING; a_default_value: like default_value)
			-- <input type="week" name="year_week">												--> year_week=2017-W24
		do
			make ("week", a_name, a_default_value)
		end

	make_button (a_name: STRING)
			-- <input type="button" value="Click me" onclick="msg()">	--> Calls "msg()" js fn
		do
			make ("button", a_name, Void)
		end

	make_checkbox (a_name: STRING; a_default_value: like default_value; a_is_checked: BOOLEAN)
			-- <input type="checkbox" name="vehicle3" value="Boat" checked> 					--> vehicle3=Boat, due to "checked"
		do
			make ("checkbox", a_name, a_default_value)
			is_checked := a_is_checked
		end

	make_radio (a_name: STRING; a_default_value: like default_value)
			-- <input type="radio" name="gender" value="female">	(with other radios in form)	--> gender=female (when selected)
		do
			make ("radio", a_name, a_default_value)
		end

	make_range (a_name: STRING; a_min, a_max, a_default_value: attached like min)
			-- <input type="range" name="points" min="0" max="10" value="9">					--> points=n (1..10 def = 9)
			-- min/max (optional)							: Only number,range
		do
			make ("range", a_name, a_default_value.out)
			min := a_min
			max := a_max
		end

	make_color (a_name: STRING; a_default_value: like default_value)
			-- <input type="color" name="favcolor" value="#28bf34">								--> favcolor=#28bf34
		do
			make ("color", a_name, a_default_value)
		end

	make_file (a_name: STRING)
	-- <input type="file" name="img">													--> img=Capture.PNG
		do
			make ("file", a_name, Void)
		end

	make_image (a_src, a_alt: STRING; a_width, a_height: INTEGER)
			-- <input type="image" src="img_submit.gif" alt="Submit" width="48" height="48">	--> x=22&y=31
			-- <input type="image" name="x" src="img_submit.gif" alt="Submit" width="48" height="48">	--> x.x=23&x.y=24***
			-- *** The "name" attribute is optional on type="image", where name="x" --> x.x=NN&x.y=QQ (wherever user clicked relative on image)
			-- src/alt (optional)							: Only image
			-- width/height (optional)						: Only image
		do
			make ("image", Void, Void)
			src := a_src
			alt := a_alt
			width := a_width
			height := a_height
		end

	make_search (a_name: STRING; a_default_value: like default_value)
			-- Search Google: <input type="search" name="googlesearch">							--> googlesearch=blah
		do
			make ("search", a_name, a_default_value)
		end

	make_submit
			--  <input type="submit" name="x">*****												--> Sends <form> <input> values to server as v1&v2&...vn
			-- ***** The "name" attribute on type="submit" is superfluous.
		do
			make ("submit", "Submit", Void)
		end

	make_reset
			-- <input type="reset" name="x">****												--> resets all <form> values to default values=""
			-- **** The "name" attribute on type="reset" is superfluous.
		do
			make ("reset", "Reset", Void)
		end

	make_hidden (a_name: STRING; a_default_value: like default_value)
	-- <input type="hidden" name="country" value="Norway">								--> country=Norway
		do
			make ("hidden", a_name, a_default_value)
		end

	make (a_type: like type; a_name: like name; a_default_value: like default_value)
		note
			design: "[
				Based on the higher concept of key:value pair where
				the `a_type' determines the specification of how the
				`a_value' lays out, if present.
				]"
		require
			has_type: is_valid_type_identifier (a_type)
		do
			default_create
			type := a_type
			name := a_name
			default_value := a_default_value
		ensure
			type_set: type.same_string (a_type)
			name_set: attached a_name as al_arg_name and then attached name as al_name implies al_name.same_string (al_arg_name)
		end

feature -- Access: Required


	-- Use within a <form> as a Submit button, which grabs content of the form and submits
	-- EXAMPLE:

	-- HTML Script:
	-- <form action="/action_page.php">
	--	  Select your favorite color: <input type="color" name="favcolor" value="#5141e0"><br>
	--	  Birthday: <input type="date" name="bday" value="2017-06-20">
	--	  <input type="submit">
	-- </form>

	-- RESULTS-IN:
	-- Submitted Form Data
	--	Your input was received as:
	--	favcolor=#5141e0&bday=2017-06-02
	--	The server has processed your input and returned this answer.


	-- Attributes of Interest:
	--------------------------
	-- type (required)								: All
	-- name (required/optional-depending)			: All, but image,reset,submit
	-- value (required for default values going-in)	: All, but reset,submit

	-- Optional Attributes:
	-----------------------

	type: STRING
			--------- BASIC
			--	text (default) - single-line text field (default width is 20 characters)
			--	number - field for entering a number
			--	password - password field (characters are masked)
			--	email - field for an e-mail address
			--	tel - field for entering a telephone number
			--	url - field for entering a URL
			--------- DATE & TIME
			--	date - date control (year, month and day (no time))
			--	datetime-local - date and time control (year, month, day, hour, minute, second, and fraction of a second (no time zone)
			--	time - control for entering a time (no time zone)
			--	month - month and year control (no time zone)
			--	week - week and year control (no time zone)
			--------- CONTROLS
			--	button - clickable button (mostly used with a JavaScript to activate a script)
			--	checkbox - checkbox
			--	radio - radio button
			--	range - control for entering a number whose exact value is not important (like a slider control). Default range is from 0 to 100
			--------- PICKERS & SELECTORS
			--	color - color picker
			--	file - file-select field and a "Browse..." button (for file uploads)
			--	image - image as the submit button
			--------- BUTTONS
			--	search - text field for entering a search string
			--	submit - submit button
			--	reset - reset button (resets all form values to default values)
			--------- MISC
			--	hidden - hidden input field

	name: detachable STRING
	name_attached: STRING do check attached name as al_result then Result := al_result end end

feature -- Access: Optional default_value

	default_value: detachable STRING
	default_value_attached: STRING do check attached default_value as al_result then Result := al_result end end

feature -- Access: Optional src,alt

	src,alt: detachable STRING
	src_attached: attached like src do check attached src as al_result then Result := al_result end end
	alt_attached: attached like alt do check attached alt as al_result then Result := al_result end end

feature -- Access: Optional width,height

	width,height: detachable INTEGER
	width_attached: attached like width do check attached width as al_result then Result := al_result end end
	height_attached: attached like height do check attached height as al_result then Result := al_result end end

feature -- Access: Optional min,max

	min,max: detachable INTEGER
	min_attached: attached like min do check attached min as al_result then Result := al_result end end
	max_attached: attached like max do check attached max as al_result then Result := al_result end end

feature -- Access: Optional maxlength

	maxlength: detachable INTEGER
	maxlength_attached: attached like maxlength do check attached maxlength as al_result then Result := al_result end end

feature -- Access: Checkbox

	is_checked: BOOLEAN

feature -- Queries

	is_required: BOOLEAN
			-- `is_required' within the Client context.
			--	(i.e. what does `is_required' mean to the Client--it could be anything)

	is_for_output: BOOLEAN
			-- `is_for_output' (like `is_required') depends on Client context.
			-- 	(i.e. the semantic purpose of `is_for_output' is held in the Client and not here)

	is_valid_type_identifier (a_identifier: like type): BOOLEAN
		do
			Result := across valid_type_identifiers as ic some a_identifier.same_string (ic.item) end
		end

	is_valid_type: BOOLEAN
		do
			Result := is_valid_type_identifier (type)
		end

feature -- Setters

	set_is_required do is_required := True end
	reset_is_required do is_required := False end

	set_is_for_output do is_for_output := True end
	reset_is_for_output do is_for_output := False end

feature -- Constants

	valid_type_identifiers: ARRAY [STRING]
		once
			Result := <<
						"text",
						"number",
						"password",
						"email",
						"tel",
						"url",
						"date",
						"datetime-local",
						"time",
						"month",
						"week",
						"button",
						"checkbox",
						"radio",
						"range",
						"color",
						"file",
						"image",
						"search",
						"submit",
						"reset",
						"hidden"
						>>
		end

invariant
	valid_type_identifier: is_valid_type

end
