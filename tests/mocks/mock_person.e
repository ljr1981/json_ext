note
	description: "[
		Mock representation of a generic "PERSON" class that is serializable and deserializable.
		]"
	synopsis: "[
		SERIALIZATION SETUP
		===================
		(1) Add features as you like and want (e.g. `first_name', `last_name' in Access feature group).
		(2) Add features names as strings to `convertible_features' {ARRAY}.
		
		DONE: You now have everything you need for serialization.
		
		DESERIALIZATION SETUP
		=====================
		(1) Ensure `make_from_json' is declared as creation procedure in the "create" class block.
		(2) Ensure each serialized feature (e.g. `convertible_features') is deserialized from `a_object' in `initialize_from_json_object'.
		
		DONE: You now have everything you need for deserialization.
		
		NOTES
		=====
		(1) The `make_from_json' will convert its `a_json' {STRING} into `a_object', which is provided in `initialize_from_json_object'.
			It is this object that one uses to extract each attribute feature from the {JSON_OBJECT} and reconstitute it. You will find
			a number of `json_object_to_???' feature calls available to you. Choose the converter that best matches the assignment
			target. For example: `first_name' is assigned to `json_object_to_attached_string', passing the name of the feature to be
			extracted as data and the `a_object', which (presumably) has the feature data.
			
			STRING
			======
			json_object_to_attached_string 				(a_attribute_name: STRING_8; a_object: JSON_OBJECT): STRING_8
			json_object_to_attached_string_all 			(a_attribute_name: STRING_8; a_object: JSON_OBJECT): STRING_8
			json_object_to_attached_string_first 		(a_attribute_name: STRING_8; a_object: JSON_OBJECT): STRING_8
			json_object_to_detachable_string 			(a_attribute_name: STRING_8; a_object: JSON_OBJECT): detachable STRING_8
			json_object_to_attached_immutable_string 	(a_attribute_name: STRING_8; a_object: JSON_OBJECT): IMMUTABLE_STRING_32
			json_object_to_detached_immutable_string 	(a_attribute_name: STRING_8; a_object: JSON_OBJECT): detachable IMMUTABLE_STRING_32

			BOOLEAN
			=======
			json_object_to_boolean 						(a_attribute_name: STRING_8; a_object: JSON_OBJECT): BOOLEAN
			json_object_to_boolean_first 				(a_attribute_name: STRING_8; a_object: JSON_OBJECT): BOOLEAN

			DATE/TIME
			=========
			json_object_to_date 						(a_attribute_name: STRING_8; a_object: JSON_OBJECT): DATE
			json_object_to_time 						(a_attribute_name: STRING_8; a_object: JSON_OBJECT): TIME
			json_object_to_date_time 					(a_attribute_name: STRING_8; a_object: JSON_OBJECT): DATE_TIME

			DECIMAL
			=======
			json_object_to_decimal_attached 			(a_attribute_name: STRING_8; a_object: JSON_OBJECT): DECIMAL
			json_object_to_decimal 						(a_attribute_name: STRING_8; a_object: JSON_OBJECT): detachable DECIMAL

			INTEGER
			=======
			json_object_to_integer_8 					(a_attribute_name: STRING_8; a_object: JSON_OBJECT): INTEGER_8
			json_object_to_integer_16 					(a_attribute_name: STRING_8; a_object: JSON_OBJECT): INTEGER_16
			json_object_to_integer 						(a_attribute_name: STRING_8; a_object: JSON_OBJECT): INTEGER_32
			json_object_to_integer_32 					(a_attribute_name: STRING_8; a_object: JSON_OBJECT): INTEGER_32
			json_object_to_integer_64 					(a_attribute_name: STRING_8; a_object: JSON_OBJECT): INTEGER_64
			
			NATURAL
			=======
			json_object_to_natural_8 					(a_attribute_name: STRING_8; a_object: JSON_OBJECT): NATURAL_8
			json_object_to_natural_16 					(a_attribute_name: STRING_8; a_object: JSON_OBJECT): NATURAL_16
			json_object_to_natural_32 					(a_attribute_name: STRING_8; a_object: JSON_OBJECT): NATURAL_32
			json_object_to_natural_64 					(a_attribute_name: STRING_8; a_object: JSON_OBJECT): NATURAL_64

			REAL
			====
			json_object_to_real_32 						(a_attribute_name: STRING_8; a_object: JSON_OBJECT): REAL_32
			json_object_to_real_64 						(a_attribute_name: STRING_8; a_object: JSON_OBJECT): REAL_64

			JSON_ARRAY
			==========
			json_object_to_json_array 					(a_attribute_name: STRING_8; a_object: JSON_OBJECT): JSON_ARRAY
			json_object_to_tuple_as_json_array 			(a_attribute_name: STRING_8; a_object: JSON_OBJECT): JSON_ARRAY
		]"

class
	MOCK_PERSON

inherit
	JSON_SERIALIZABLE
		redefine
			default_create
		end

	JSON_DESERIALIZABLE
		undefine
			default_create
		end

create
	default_create,
	make_from_json

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			create first_name.make_empty
			create last_name.make_empty
			create birthdate.make_now
			create aliases.make (0)
		end

	initialize_from_json_object (a_object: JSON_OBJECT)
			-- <Precursor>
		local
			l_aliases: JSON_ARRAY
		do
			first_name := json_object_to_attached_string ("first_name", a_object)
			last_name := json_object_to_attached_string ("last_name", a_object)
			birthdate := json_object_to_date ("birthdate", a_object)
			l_aliases := json_object_to_json_array ("aliases", a_object)
			create aliases.make (l_aliases.count)
			across l_aliases as ic_aliases loop
				aliases.force (remove_all (ic_aliases.item.representation))
			end
		end

feature -- Access

	first_name: STRING
			-- First name of Current.

	last_name: STRING
			-- Last name of Current.

	birthdate: DATE
			-- Birth-date of Current.

	aliases: ARRAYED_LIST [STRING]
			-- Aliases of Current.

feature -- Settings

	add_alias (a_alias: STRING)
			-- Add `a_alias' to `aliases'.
		do
			aliases.force (a_alias)
		ensure
			has_alias: aliases.has (a_alias)
		end

	set_first_name (a_first_name: like first_name)
			-- Sets `first_name' with `a_first_name'.
		do
			first_name := a_first_name
		ensure
			first_name_set: first_name = a_first_name
		end

	set_last_name (a_last_name: like last_name)
			-- Sets `last_name' with `a_last_name'.
		do
			last_name := a_last_name
		ensure
			last_name_set: last_name = a_last_name
		end

	set_birthdate (a_birthdate: like birthdate)
			-- Sets `birthdate' with `a_birthdate'.
		do
			birthdate := a_birthdate
		ensure
			birthdate_set: birthdate = a_birthdate
		end

feature {NONE} -- Implementation

	convertible_features (a_current: ANY): ARRAY [STRING]
			-- <Precursor>
		do
			Result := <<"first_name",
						"last_name",
						"birthdate",
						"aliases">>
		end

end
