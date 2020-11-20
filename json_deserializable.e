note
	description: "[
			Abstract notion of a JSON deserialization class.
			]"
	what: "[
			A class capable of deserializing well-formed JSON and reconsituting or rehydrating an
			Eiffel class object from it.
			]"
	why: "[
			Various reasons, not the least of which are:
			
			1. Storage of complex object structures in RDBMS systems is a significant challenge
				that can be overcome by storing complex structures in JSON. Note that XML is 
				both verbose and difficult to use due to overburden of text and tags. JSON
				solves this issue by being terse. It also solves a problem that XML finds 
				difficulty in cleanly modeling complex object structures. JSON does not.
			2. JSON is a better choice for sending pure text data over the wire because of less
				text to send (about 30% lighter).
			]"
	EIS: "name=JSON Organization", "protocol=URI", "src=http://www.json.org"
	EIS: "name=Serialization (Deserialization)", "protocol=URI", "src=http://en.wikipedia.org/wiki/Serialization"
	how: "[
			Inherit from this class to make any other class deserializable from a well-formed JSON string.
			]"
	suppliers: "[
			BOOLEAN, CHARACTER_8, DATE, DATE_TIME, DECIMAL, 
				IMMUTABLE_STRING_8/32, STRING_8, , ARRAY/ARRAY_LIST
				INTEGER_8/16/32/64, MIXED_NUMBER, TUPLE
				NATURAL_8/16/32/64, REAL_32/64, TIME: Used for purposes of deserialization targets, defining
														how these types are deserialized from JSON representations
														to the Eiffel objects that they are, attaching their data
														to a target feature.
				
			JSON_ARRAY, JSON_BOOLEAN, JSON_NULL, 
				JSON_NUMBER, JSON_OBJECT, JSON_STRING, 
				JSON_VALUE: Various forms of JSON data types used in the conversion process (e.g. JSON_BOOLEAN --> BOOLEAN)
			
			JSON_PARSER: Used to parse the well-formed JSON string down to its JSON data type objects above.
			]"
	glossary: "[
			JSON: Java Script Object Notation. See: EIS-JSON Organization URI link (above).
			]"
	date: "$Date: 2015-12-31 07:55:33 -0500 (Thu, 31 Dec 2015) $"
	revision: "$Revision: 12934 $"

deferred class
	JSON_DESERIALIZABLE

inherit
	JSON_TRANSFORMABLE

feature {NONE} -- Initialization

	make_from_json (a_json: STRING)
			-- Initialize Current by parsing `a_json' and rehydrating it into Current.
		note
			what: "[
					Prototype creation procedure establishing that Deserializable things can be created from JSON strings.
					]"
			why: "[
					Objects must be deserializable by creation based on JSON strings.
					]"
			how: "[
					The JSON string in `a_json' is converted first to a JSON_OBJECT and then parsed to specific
					JSON things like arrays, strings, booleans, and so on. Those objects are then converted to
					the specific features, restoring the class to it original form at the point of serialization.
					]"
			BNF: "[]"
		require
			force_require_else_true_in_descendants: False
		deferred
		end

feature {NONE} -- Implementation: Array Fillers

	fill_arrayed_list_of_strings (a_json_array: JSON_ARRAY): ARRAYED_LIST [STRING]
			-- Fill list.
		local
			l_filler: JSON_FILLABLES [STRING]
		do
			create l_filler
			Result := l_filler.fill_arrayed_list_of_any_type (a_json_array, agent string_creation_agent)
		end

	fill_arrayed_list_of_detachable_strings (a_json_array: JSON_ARRAY): ARRAYED_LIST [detachable STRING]
			-- Fill list.
		local
			l_filler: JSON_FILLABLES [detachable STRING]
		do
			create l_filler
			Result := l_filler.fill_arrayed_list_of_any_detachable_type (a_json_array, agent detachable_string_creation_agent)
		end

	string_creation_agent (a_json_string: STRING): STRING
			-- Creation agent for STRING
		do
			Result := a_json_string
		end

	detachable_string_creation_agent (a_json_string: STRING): detachable STRING
			-- Detached version of `string_creation_agent'.
		do
			if not a_json_string.same_string ("null") then
				Result := a_json_string
			end
		end

	fill_arrayed_list_of_decimals (a_json_array: JSON_ARRAY): ARRAYED_LIST [DECIMAL]
			-- Fill list.
		local
			l_filler: JSON_FILLABLES [DECIMAL]
		do
			create l_filler
			Result := l_filler.fill_arrayed_list_of_any_type (a_json_array, agent decimal_creation_agent)
		end

	decimal_creation_agent (a_json_string: STRING): DECIMAL
			-- Decimal creation agent.
		do
			create Result.make_from_string (a_json_string)
		end

	fill_arrayed_list_of_integers (a_json_array: JSON_ARRAY): ARRAYED_LIST [INTEGER]
			-- Fill list.
		local
			l_filler: JSON_FILLABLES [INTEGER]
		do
			create l_filler
			Result := l_filler.fill_arrayed_list_of_any_type (a_json_array, agent integer_creation_agent)
		end

	integer_creation_agent (a_json_string: STRING): INTEGER
			-- Integer creation agent.
		require
			is_integer: a_json_string.is_integer
		do
			Result := a_json_string.to_integer
		end

	fill_arrayed_list_of_booleans (a_json_array: JSON_ARRAY): ARRAYED_LIST [BOOLEAN]
			-- Fill list.
		local
			l_filler: JSON_FILLABLES [BOOLEAN]
		do
			create l_filler
			Result := l_filler.fill_arrayed_list_of_any_type (a_json_array, agent boolean_creation_agent)
		end

	boolean_creation_agent (a_json_string: STRING): BOOLEAN
			-- Boolean creation agent.
		require
			is_boolean: a_json_string.is_boolean
		do
			Result := a_json_string.to_boolean
		end

	fill_arrayed_list_of_naturals (a_json_array: JSON_ARRAY): ARRAYED_LIST [NATURAL]
			-- Fill list.
		local
			l_filler: JSON_FILLABLES [NATURAL]
		do
			create l_filler
			Result := l_filler.fill_arrayed_list_of_any_type (a_json_array, agent natural_creation_agent)
		end

	natural_creation_agent (a_json_string: STRING): NATURAL
			-- Natural creation agent.
		require
			is_boolean: a_json_string.is_natural
		do
			Result := a_json_string.to_natural
		end

	fill_arrayed_list_of_reals (a_json_array: JSON_ARRAY): ARRAYED_LIST [REAL]
			-- Fill list.
		local
			l_filler: JSON_FILLABLES [REAL]
		do
			create l_filler
			Result := l_filler.fill_arrayed_list_of_any_type (a_json_array, agent real_creation_agent)
		end

	real_creation_agent (a_json_string: STRING): REAL
			-- Real creation agent.
		require
			is_boolean: a_json_string.is_real
		do
			Result := a_json_string.to_real
		end

	fill_arrayed_list_of_dates (a_json_array: JSON_ARRAY): ARRAYED_LIST [DATE]
			-- Fill list.
		local
			l_filler: JSON_FILLABLES [DATE]
		do
			create l_filler
			Result := l_filler.fill_arrayed_list_of_any_type (a_json_array, agent date_creation_agent)
		end

	date_creation_agent (a_json_string: STRING): DATE
			-- Date creation agent.
		do
			Result := string_to_date (a_json_string, '/')
		end

feature {NONE} -- Implementation: Basic Operations

	json_string_to_json_object (a_json: STRING): detachable JSON_OBJECT
			-- Parse `a_json' to its resulting JSON_OBJECT.
		local
			l_parser: JSON_PARSER
		do
			if a_json [a_json.count].is_control then
				from

				until
					not a_json [a_json.count].is_control
				loop
					a_json.remove_tail (1)
				end
			end
			if a_json [a_json.count] = ')' then
				a_json [a_json.count] := '}'
			end
			create l_parser.make_with_string (a_json)
			l_parser.parse_content
			if attached l_parser.parsed_json_object as al_object then
				Result := al_object.twin
			end
		end

	json_object_to_json_objects (a_object: JSON_OBJECT): ARRAYED_LIST [JSON_OBJECT]
			-- JSON_OBJECT to list of JSON_OBJECTs
		do
			create Result.make (5)
			across
				a_object.current_keys as ic_keys
			loop
				if attached {JSON_OBJECT} a_object.item (ic_keys.item) as al_object then
					Result.force (al_object)
				end
			end
		end

	json_object_to_json_string_objects (a_object: JSON_OBJECT): ARRAYED_LIST [JSON_STRING]
			-- JSON_OBJECT to list of JSON_STRING_OBJECTs
		do
			create Result.make (5)
			across
				a_object.current_keys as ic_keys
			loop
				if attached {JSON_STRING} a_object.item (ic_keys.item) as al_object then
					Result.force (al_object)
				end
			end
		end

	json_object_to_json_object (a_object: JSON_OBJECT; a_index: INTEGER): detachable JSON_OBJECT
			-- JSON_OBJECT to JSON_OBJECT
		local
			l_objects: ARRAYED_LIST [JSON_OBJECT]
		do
			l_objects := json_object_to_json_objects (a_object)
			if a_index = 0 and not l_objects.is_empty then
				Result := l_objects [1]
			elseif l_objects.is_empty then
				Result := Void
			elseif a_index <= l_objects.count then
				Result := l_objects [a_index]
			else
				Result := Void
			end
		end

	json_object_to_json_string_object (a_object: JSON_OBJECT; a_index: INTEGER): detachable JSON_STRING
			-- JSON_OBJECT to JSON_STRING_OBJECT
		local
			l_objects: ARRAYED_LIST [JSON_STRING]
		do
			l_objects := json_object_to_json_string_objects (a_object)
			if a_index = 0 and not l_objects.is_empty then
				Result := l_objects [1]
			elseif l_objects.is_empty then
				Result := Void
			elseif a_index <= l_objects.count then
				Result := l_objects [a_index]
			else
				Result := Void
			end
		end

	json_object_to_json_reference_subobject (a_object: JSON_OBJECT; a_attribute_name: STRING): detachable JSON_OBJECT
			-- Locate a reference for attribute `a_attribute_name' in `a_object' and create the referenced object.
		local
			l_key: JSON_STRING
		do
			create l_key.make_from_string (a_attribute_name)
			if attached {JSON_OBJECT} a_object.item (l_key) as al_json_object then
				Result := al_json_object
			end
		end

feature {NONE} -- Conversions: String

	json_object_to_json_string_representation (a_attribute_name: STRING; a_object: JSON_OBJECT): detachable STRING
			-- Deserialize actual STRING value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			if attached {JSON_NULL} a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) then
				Result := Void
			elseif attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation
				Result := strip_json_quotes (Result)
			end
		end

	json_object_to_json_string_representation_attached (a_attribute_name: STRING; a_object: JSON_OBJECT): STRING
			-- Deserialize actual STRING value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			check attached json_object_to_json_string_representation (a_attribute_name, a_object) as al_attached_result then
				Result := al_attached_result
			end
		end

	json_object_to_json_immutable_string_representation (a_attribute_name: STRING; a_object: JSON_OBJECT): detachable IMMUTABLE_STRING_32
			-- Deserialize actual IMMUTABLE_STRING_32 for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			if attached {JSON_NULL} a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) then
				Result := Void
			elseif attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				create Result.make_from_string (strip_json_quotes (al_object.representation))
			end
		end

	json_object_to_json_immutable_string_representation_attached (a_attribute_name: STRING; a_object: JSON_OBJECT): IMMUTABLE_STRING_32
			-- JSON_OBJECT to IMMUTABLE_STRING_32
		do
			check attached json_object_to_json_immutable_string_representation (a_attribute_name, a_object) as al_attached_result then
				Result := al_attached_result
			end
		end

	recursive_json_object_to_json_string_representation (a_attribute_name: STRING; a_object: JSON_OBJECT): STRING
			-- Deserialize actual STRING value for `a_attribute_name' from `a_object', looking within interior JSON_OBJECTs.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			create Result.make_empty
			if attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation
			else
				across a_object as ic_object until not Result.is_empty loop
					if attached {JSON_OBJECT} ic_object.item as al_object then
						Result := recursive_json_object_to_json_string_representation (a_attribute_name, al_object)
					end
				end
			end
			if not Result.is_empty then
				Result := strip_json_quotes (Result)
			end
		end

feature {NONE} -- Conversions: Boolean

	json_object_to_boolean (a_attribute_name: STRING; a_object: JSON_OBJECT): BOOLEAN
			-- Deserialize actual BOOLEAN value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			if attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation.same_string (json_true)
			end
		end

	recursive_json_object_to_boolean (a_attribute_name: STRING; a_object: JSON_OBJECT): BOOLEAN
			-- Deserialize actual BOOLEAN value for `a_attribute_name' from `a_object', looking within interior JSON_OBJECTs.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			if attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation.same_string (json_true)
			else
				across a_object as ic_object until Result loop
					if attached {JSON_OBJECT} ic_object.item as al_object then
						Result := recursive_json_object_to_boolean (a_attribute_name, al_object)
					end
				end
			end
		end

feature {NONE} -- Conversions: Integer

	json_object_to_integer (a_attribute_name: STRING; a_object: JSON_OBJECT): INTEGER
			-- Deserialize actual INTEGER value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			check json_integer_value: attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation.to_integer
			end
		end

	json_object_to_integer_8 (a_attribute_name: STRING; a_object: JSON_OBJECT): INTEGER_8
			-- Deserialize actual INTEGER_8 value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			check json_integer_8_value: attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation.to_integer_8
			end
		end

	json_object_to_integer_16 (a_attribute_name: STRING; a_object: JSON_OBJECT): INTEGER_16
			-- Deserialize actual INTEGER_16 value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			check json_integer_16_value: attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation.to_integer_16
			end
		end

	json_object_to_integer_32 (a_attribute_name: STRING; a_object: JSON_OBJECT): INTEGER_32
			-- Deserialize actual INTEGER_32 value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			check json_integer_32_value: attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation.to_integer_32
			end
		end

	recursive_json_object_to_integer_32 (a_attribute_name: STRING; a_object: JSON_OBJECT): INTEGER_32
			-- Deserialize actual INTEGER_32 value for `a_attribute_name' from `a_object', looking within interior JSON_OBJECTs.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			if attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation.to_integer_32
			else
				across a_object as ic_object until Result > 0 loop
					if attached {JSON_OBJECT} ic_object.item as al_object then
						Result := recursive_json_object_to_integer_32 (a_attribute_name, al_object)
					end
				end
			end
		end

	json_object_to_integer_64 (a_attribute_name: STRING; a_object: JSON_OBJECT): INTEGER_64
			-- Deserialize actual INTEGER_64 value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			check json_integer_64_value: attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation.to_integer_64
			end
		end

feature {NONE} -- Conversions: Naturals

	json_object_to_natural_8 (a_attribute_name: STRING; a_object: JSON_OBJECT): NATURAL_8
			-- Deserialize actual NATURAL_8 value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			check json_natural_8_value: attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation.to_natural_8
			end
		end

	json_object_to_natural_16 (a_attribute_name: STRING; a_object: JSON_OBJECT): NATURAL_16
			-- Deserialize actual NATURAL_16 value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			check json_natural_16_value: attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation.to_natural_16
			end
		end

	json_object_to_natural_32 (a_attribute_name: STRING; a_object: JSON_OBJECT): NATURAL_32
			-- Deserialize actual NATURAL_32 value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			check json_natural_32_value: attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation.to_natural_32
			end
		end

	json_object_to_natural_64 (a_attribute_name: STRING; a_object: JSON_OBJECT): NATURAL_64
			-- Deserialize actual NATURAL_64 value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			check json_natural_64_value: attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation.to_natural_64
			end
		end

feature {NONE} -- Conversions: Real

	json_object_to_real_32 (a_attribute_name: STRING; a_object: JSON_OBJECT): REAL_32
			-- Deserialize actual REAL_32 value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			check json_real_32_value: attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation.to_real_32
			end
		end

	json_object_to_real_64 (a_attribute_name: STRING; a_object: JSON_OBJECT): REAL_64
			-- Deserialize actual REAL_64 value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			check json_real_64_value: attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				Result := al_object.representation.to_real_64
			end
		end

feature {NONE} -- Conversions: Date

	json_object_to_date_attached (a_attribute_name: STRING; a_object: JSON_OBJECT): DATE
			-- Deserialize DATE value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			create Result.make_now
			check json_date_value: attached {JSON_STRING} a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_string then
				Result := json_string_to_date (al_string)
			end
		end

	json_object_to_date (a_attribute_name: STRING; a_object: JSON_OBJECT): detachable DATE
			-- Deserialize DATE value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			create Result.make_now
			if attached {JSON_STRING} a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_string then
				Result := json_string_to_date (al_string)
			end
		end

	json_string_to_date (a_json_string: JSON_STRING): DATE
			-- Deserialize actual DATE value from `a_json_string'.
		do
			Result := string_to_date (strip_json_quotes (a_json_string.representation), '/')
		end

	string_to_date (a_string: STRING; a_splitter: CHARACTER): DATE
			-- String to date
		local
			l_specification: LIST [STRING_8]
			l_dd, l_mm, l_yyyy: INTEGER
		do
			l_specification := a_string.split (a_splitter)
			l_yyyy := l_specification.i_th (1).to_integer
			l_mm := l_specification.i_th (2).to_integer
			l_dd := l_specification.i_th (3).to_integer
			create Result.make_day_month_year (l_dd, l_mm, l_yyyy)
		end

feature {NONE} -- Conversions: Time

	json_object_to_time (a_attribute_name: STRING; a_object: JSON_OBJECT): TIME
			-- Deserialize TIME value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			create Result.make_now
			check json_time_value: attached {JSON_STRING} a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_string then
				Result := json_string_to_time (al_string)
			end
		end

	json_string_to_time (a_json_string: JSON_STRING): TIME
			-- Deserialize actual TIME value from `a_json_string'.
		do
			Result := string_to_time (strip_json_quotes (strip_json_brackets (strip_json_percents (a_json_string.representation))), '/')
		end

	string_to_time (a_string: STRING; a_splitter: CHARACTER): TIME
			-- String to time
		local
			l_list: LIST [STRING]
			l_hours, l_minutes, l_seconds: INTEGER
			l_json_string: STRING
		do
			l_list := a_string.split (a_splitter)
			l_hours := l_list.i_th (1).to_integer
			l_minutes := l_list.i_th (2).to_integer
			l_seconds := l_list.i_th (3).to_integer
			create Result.make (l_hours, l_minutes, l_seconds)
		end

feature {NONE} -- Conversions: Date-Time

	json_object_to_date_time (a_attribute_name: STRING; a_object: JSON_OBJECT): detachable DATE_TIME
			-- Deserialize DATE_TIME value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			if attached {JSON_STRING} a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_string then
				Result := json_string_to_date_time (al_string)
			end
		end

	json_object_to_date_time_attached (a_attribute_name: STRING; a_object: JSON_OBJECT): DATE_TIME
			-- Deserialize DATE_TIME value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			create Result.make_now
			check json_time_date_value: attached {JSON_STRING} a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_string then
				Result := json_string_to_date_time (al_string)
			end
		end

	json_string_to_date_time (a_json_string: JSON_STRING): DATE_TIME
			-- Deserialize actual DATE_TIME value from `a_json_string'.
		local
			l_list: LIST [STRING]
			l_json_string: STRING
			l_year, l_month, l_day, l_hour, l_minute: INTEGER
			l_second: REAL_64
		do
			l_json_string := strip_json_brackets (strip_json_quotes (a_json_string.representation.twin))
			l_list := l_json_string.split ('/')
			l_year := l_list.i_th (1).to_integer
			l_month := l_list.i_th (2).to_integer
			l_day := l_list.i_th (3).to_integer
			l_hour := l_list.i_th (4).to_integer
			l_minute := l_list.i_th (5).to_integer_32
			l_second := l_list.i_th (6).to_real
			create Result.make_fine (l_year, l_month, l_day, l_hour, l_minute, l_second)
		end

feature {TEST_SET_HELPER} -- Conversions: Decimal

	json_object_to_decimal (a_attribute_name: STRING; a_object: JSON_OBJECT): detachable DECIMAL
			-- Deserialize actual DECIMAL value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			create Result
--			check attached {JSON_OBJECT} a_object as al_object then
				if attached {JSON_NULL} a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) then
					Result := Void
				elseif attached {JSON_STRING} a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_value then
					Result := json_string_to_decimal (al_value)
				end
--			end
		end

	json_object_to_decimal_attached (a_attribute_name: STRING; a_object: JSON_OBJECT): DECIMAL
			-- Deserialize actual DECIMAL value for `a_attribute_name' from `a_object'.
		require
			non_empty_attribute_name: not a_attribute_name.is_empty
		do
			check attached_result: attached json_object_to_decimal (a_attribute_name, a_object) as al_attached_result then
				Result := al_attached_result
			end
		end

	json_string_to_decimal (a_json_string: JSON_STRING): DECIMAL
			-- Deserialize actual DECIMAL value from `a_json_string'.
		local
			l_string, l_value_string: STRING
			l_specification: LIST [STRING_8]
			l_exponent: INTEGER
		do
			l_string :=  strip_json_brackets (strip_json_quotes (a_json_string.representation))
			if l_string.occurrences (',') = 0 then
				create Result.make_from_string (l_string)
			else
				l_specification := l_string.split (',')
				create l_value_string.make_empty
				l_value_string.append_string (l_specification [2])
				if l_value_string.has_substring ("NaN") then
					create Result.make_from_string ("NaN")
				else
					l_exponent := l_specification [3].to_integer
					if l_exponent < 0 then
						l_value_string.prepend_string (create {STRING}.make_filled ('0', l_exponent.abs))
						l_value_string.insert_string (".", l_value_string.count + l_exponent + 1)
					end
					if l_specification [1].same_string ("1") then
						l_value_string.precede ('-')
					end
					create Result.make_from_string (l_value_string)
				end
			end
		end

feature {TEST_SET_BRIDGE} -- Conversions: Mixed Number

	json_string_to_mixed_number (a_json_array: JSON_ARRAY): FW_MIXED_NUMBER
			-- Deserialize actual MIXED_NUMBER value from `a_json_array'
		local
			l_negative: BOOLEAN
			l_whole: NATURAL_64
			l_numerator, l_denominator: NATURAL_32
		do
			check negative: attached {JSON_BOOLEAN} a_json_array.i_th (1) as al_json_null then
				if al_json_null.representation.same_string (Json_true) then
					l_negative := True
				end
			end
			check whole: attached {JSON_NUMBER} a_json_array.i_th (2) as al_whole then
				l_whole := al_whole.item.to_natural_64
			end
			check numerator: attached {JSON_NUMBER} a_json_array.i_th (3) as al_numerator then
				l_numerator := al_numerator.item.to_natural_32
			end
			check denominator: attached {JSON_NUMBER} a_json_array.i_th (4) as al_denominator then
				l_denominator := al_denominator.item.to_natural_32
			end
			create Result.make (l_negative, l_whole, l_numerator, l_denominator)
		end

feature {NONE} -- Conversions: HASH_TABLE

	json_object_to_hash_table (a_attribute_name: STRING_8; a_object: JSON_OBJECT): HASH_TABLE [ANY, HASHABLE]
			-- Deserialize HASH_TABLE from `a_attribute_name' within `a_object'.
		do
			Result := json_array_to_eiffel_hash_table (json_object_to_tuple_as_json_array (a_attribute_name, a_object))
		end

	json_array_to_eiffel_hash_table (a_array: JSON_ARRAY): HASH_TABLE [ANY, HASHABLE]
			-- Convert `a_array' {JSON_ARRAY} to an Eiffel {HASH_TABLE [G. K]}.
		local
			i: INTEGER
			l_key: detachable HASHABLE
			l_value: detachable ANY
		do
			create Result.make (a_array.count)
			across
				a_array.array_representation as ic
			loop
				check attached {JSON_ARRAY} ic.item as al_pair then
					if
						attached {JSON_VALUE} al_pair [1] as al_item_key and then
						attached al_item_key.is_hashable
					then
						if al_item_key.is_number and then attached {JSON_NUMBER} al_item_key as al_number then
							if al_number.is_double then l_key := al_number.double_item
							elseif al_number.is_integer then l_key := al_number.integer_64_item
							elseif al_number.is_natural then l_key := al_number.natural_64_item
							elseif al_number.is_real then l_key := al_number.real_64_item
							else check unknown_numeric_type: False end
							end
						elseif al_item_key.is_object and then attached {JSON_OBJECT} al_item_key as al_object then
							check unhandled_json_object: False end	-- TODO: handle JSON object as hashable-key ... ???
						elseif al_item_key.is_string and then attached {JSON_STRING} al_item_key as al_string then
							l_key := al_string.item
						end
					end
					if
						attached {JSON_VALUE} al_pair [2] as al_item_value and then
						attached al_item_value.is_hashable
					then
						if al_item_value.is_number and then attached {JSON_NUMBER} al_item_value as al_number then
							if al_number.is_double then l_value := al_number.double_item
							elseif al_number.is_integer then l_value := al_number.integer_64_item
							elseif al_number.is_natural then l_value := al_number.natural_64_item
							elseif al_number.is_real then l_value := al_number.real_64_item
							else check unknown_numeric_type: False end
							end
						elseif al_item_value.is_object and then attached {JSON_OBJECT} al_item_value as al_object then
							check unhandled_json_object: False end	-- TODO: handle JSON object as hashable-key ... ???
						elseif al_item_value.is_string and then attached {JSON_STRING} al_item_value as al_string then
							l_value := al_string.item
						end
					end
					if attached l_key and attached l_value then
						Result.force (l_value, l_key)
					end
				end
			end
		end

feature {NONE} -- Conversions: Tuple

	json_array_to_eiffel_tuple (a_array: JSON_ARRAY): TUPLE
			-- JSON_ARRAY to TUPLE
		local
			i: INTEGER
		do
			create Result
			across
				a_array.array_representation as ic
			loop
				i := ic.cursor_index
				if attached {JSON_BOOLEAN} ic.item as al_item then
					Result.put_boolean (al_item.item, i)
				elseif attached {JSON_NULL} ic.item as al_item then
					Result.put (al_item, i)
				elseif attached {JSON_NUMBER} ic.item as al_item then
					if al_item.is_double then
						Result.put_double (al_item.double_item, i)
					elseif al_item.is_integer then
						Result.put_integer (al_item.integer_type, i)
					elseif al_item.is_natural then
						Result.put_natural_64 (al_item.natural_64_item, i)
					elseif al_item.is_real then
						Result.put_real (al_item.real_type, i)
					end
				elseif attached {JSON_OBJECT} ic.item as al_item then
					Result.put (json_string_to_json_object (al_item.representation), i)
				elseif attached {JSON_STRING} ic.item as al_item then
					Result.put (al_item.item, i)
				end
				i := i + 1
			end
		end

	json_object_to_tuple_as_json_array (a_attribute_name: STRING; a_object: JSON_OBJECT): JSON_ARRAY
			-- Deserialize actual TUPLE value for `a_attribute_name' from `a_object'.
		do
			create Result.make_empty
			if attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				if attached {JSON_ARRAY} al_object as al_array then
					Result := al_array
				elseif attached {JSON_STRING} al_object as al_string then
					Result.put_front (al_string)
				elseif attached {JSON_NULL} al_object as al_null then
					do_nothing -- NULL values count for nothing in building of the array
				else
					check unknown_type: False end
				end
			end
		end

	json_object_to_json_array (a_attribute_name: STRING; a_object: JSON_OBJECT): JSON_ARRAY
			-- Deserialize actual ARRAY value for `a_attribute_name' from `a_object'.
		do
			create Result.make (1_000)
			check json_array_value: attached a_object.item (create {JSON_STRING}.make_from_string (a_attribute_name)) as al_object then
				if attached {JSON_ARRAY} al_object as al_array then
					Result := al_array
				else
					create Result.make_empty
				end
			end
		end

feature {NONE} -- Implementation

	strip_json_quotes (a_json_string: STRING): STRING
			-- Remove attribute quotes from `a_json_string'
		do
			Result := strip_json_head_and_tail (a_json_string, "%"", "%"")
		ensure
			quotes_removed: not (Result.starts_with ("%"") and Result.ends_with ("%""))
		end

	strip_json_escaped_characters (a_json_string: STRING): STRING
			-- Remove escaped characters from `a_json_string' added in {JSON_STRING}.escaped_json_string.
			-- TODO: Do we want to escape all characters from {JSON_STRING}.escaped_json_string?
		do
			Result := a_json_string
			Result.replace_substring_all ("\%"", "%"")
--			Result.replace_substring_all ("\\", "\")
--			Result.replace_substring_all ("\b", "%B")
--			Result.replace_substring_all ("\f", "%F")
--			Result.replace_substring_all ("\n", "%N")
--			Result.replace_substring_all ("\r", "%R")
--			Result.replace_substring_all ("\t", "%T")
		ensure
--			escaped_characters: not (Result.has_substring ("\r") or else Result.has_substring ("\n") or else Result.has_substring ("\f")  or else Result.has_substring ("\b") or else Result.has_substring ("\\") or else Result.has_substring ("\%""))
			escapted_characters: not Result.has_substring ("\%"")
		end

	strip_json_brackets (a_json_string: STRING): STRING
			-- Remove brackets from `a_string'
		do
			Result := strip_json_head_and_tail (a_json_string, "[", "]")
		ensure
			brackets_removed: not (Result.starts_with ("[") and Result.ends_with ("]"))
		end

	strip_json_percents (a_json_string: STRING): STRING
			-- Remove attribute quotes from `a_json_string'
		do
			Result := strip_json_head_and_tail (a_json_string, "%%", "%%")
		ensure
			quotes_removed: not (Result.starts_with ("%%") and Result.ends_with ("%%"))
		end

	strip_json_head_and_tail (a_json_string: STRING; a_head, a_tail: STRING): STRING
			-- Strips `a_character' from `a_json_string'.
		do
			Result := a_json_string.twin
			if Result.starts_with (a_head) and Result.ends_with (a_tail) then
				Result.remove_head (1)
				Result.remove_tail (1)
			end
		end

	to_decimal (a_tuple: STRING): DECIMAL
			-- Create a DECIMAL from `a_tuple'.
		local
			l_tuple, l_string_value: STRING
			l_list: LIST [STRING_8]
		do
			l_tuple := strip_json_brackets (a_tuple).twin
			l_list := l_tuple.split (',')
			create l_string_value.make_empty
			if l_list.i_th (1).same_string ("-1") then
				l_string_value.append_character ('-')
			end
			l_string_value.append (l_list.i_th (2))
			l_string_value.insert_character ('.', l_string_value.count + (l_list.i_th (3).to_integer) + 1)
			create Result.make_from_string (l_string_value)
		end

feature {NONE} -- Implementation: Constants

	json_true: STRING = "true"
			-- Constant

	json_false: STRING = "false"
			-- Constant

end
