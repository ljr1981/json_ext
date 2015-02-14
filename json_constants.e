note
	description: "Summary description for {JSON_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_CONSTANTS

feature -- Constants

	element_prefix: STRING = "element_"
			-- Prefix for elements

	json_void: STRING = "void"
			-- Representation of Void in JSON.

	json_true: STRING = "true"
			-- Representation of True in JSON.

	json_false: STRING = "false"
			-- Representation of False in JSON.

;end
