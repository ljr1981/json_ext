note
	description: "[
		Abstract notion of a JSON serialization class.
	]"
	what: "[
			A class capable of serializing well-formed JSON and into an ASC-II or Unicode byte-stream
			(e.g. a serial string of characters) which can be safely passed over system boundaries.
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
			Inherit from this class to make any other class serializable to a well-formed JSON string.
			
			This class uses reflection (e.g. {INTERNAL}) together with a list of convertible features
			to know what features are to be serialized into JSON. The list of features, is checked in
			a once to ensure the features are valid for the class and any descendant.
			]"
	suppliers: "[
			BOOLEAN, CHARACTER_8, DATE, DATE_TIME, DECIMAL, 
				IMMUTABLE_STRING_8/32, STRING_8, ARRAY/ARRAY_LIST
				INTEGER_8/16/32/64, MIXED_NUMBER, TUPLE
				NATURAL_8/16/32/64, REAL_32/64, TIME: Used for purposes of serialization targets, defining
														how these types are serialized to JSON representations
														to the Eiffel objects that they are.
				
			JSON_ARRAY, JSON_BOOLEAN, JSON_NULL, 
				JSON_NUMBER, JSON_OBJECT, JSON_STRING, 
				JSON_VALUE: Various forms of JSON data types used in the conversion process (e.g. BOOLEAN --> JSON_BOOLEAN)
			]"
	glossary: "[
			JSON: Java Script Object Notation. See: EIS-JSON Organization URI link (above).
			]"
	date: "$Date: 2014-06-11 13:41:26 -0400 (Wed, 11 Jun 2014) $"
	revision: "$Revision: 9319 $"

deferred class
	JSON_SERIALIZABLE

inherit
	JSON_TRANSFORMABLE

feature -- Access

	representation_from_current (a_current: like Current): STRING
			-- JSON representation of Current (`a_current').
		do
			Result := serializable_to_json_object (a_current).representation
		end

feature {JSON_SERIALIZABLE} -- Implementation: Unkeyed Conversions

	serializable_to_json_object (a_object: JSON_SERIALIZABLE): JSON_OBJECT
			-- Convert Current (`a_object') to a JSON_OBJECT (if possible) by way of `convertible_features'
			--	list using `reflector'. A detachable (Void) Result (JSON_OBJECT) will be returned in one case
			--	only: No feature of the `convertible_features' list is an attribute. Otherwise,
			--	even attributes with Void results will result in JSON Void representations for
			--	those features.
		local
			i, j: INTEGER
			l_key: STRING
			l_hash: HASH_TABLE [BOOLEAN, STRING]
		do
			create {JSON_OBJECT} Result.make
			create l_hash.make (convertible_features (a_object).count)
			l_hash.compare_objects

			across convertible_features (a_object) as ic_features loop
				l_hash.force (False, ic_features.item)
			end
			across 1 |..| reflector.field_count (a_object) as ic loop
				l_key := reflector.field_name (ic.item, a_object).twin
				if l_hash.has (l_key) then
					l_hash.force (True, l_key)
					check has_key: l_hash.has_key (l_key) end
					Result.put (any_detachable_to_json_value (l_key, reflector.field (ic.item, a_object)), l_key)
				end
			end
			check all_converted: across l_hash as ic_hash all ic_hash.item.item end end
		end

	array_to_json_array (a_array: ARRAY [detachable ANY]): JSON_ARRAY
			-- Converts `a_special' (ARRAY or ARRAYED_LIST) to JSON_ARRAY.
			-- Detachable elements are represented by JSON_NULL in Result.
		do
			create Result.make_array
			across a_array as ic_array loop
				if attached ic_array.item as al_item then
					if attached {JSON_SERIALIZABLE} al_item as al_convertible then
						Result.add (al_convertible.serializable_to_json_object (al_convertible))
					elseif attached {ARRAY [detachable ANY]} al_item as al_array_item then
						Result.add (array_to_json_array (al_array_item))
					elseif attached {ARRAYED_LIST [detachable ANY]} al_item as al_arrayed_list_item then
						Result.add (arrayed_list_to_json_array (al_arrayed_list_item))
					else
						if attached any_detachable_to_json_value ({JSON_CONSTANTS}.element_prefix + ic_array.cursor_index.out, al_item) as al_value then
							Result.add (al_value)
						else
							Result.add (create {JSON_NULL})
						end
					end
				else
					Result.add (create {JSON_NULL})
				end
			end
		end

	arrayed_list_to_json_array (a_arrayed_list: ARRAYED_LIST [detachable ANY]): JSON_ARRAY
			-- Converts `a_special' (ARRAY or ARRAYED_LIST) to JSON_ARRAY.
			-- Detachable elements are represented by JSON_NULL in Result.
		do
			create Result.make_array
			across a_arrayed_list as ic_arrayed_list loop
				if attached ic_arrayed_list.item as al_item then
					if attached {JSON_SERIALIZABLE} al_item as al_convertible then
						Result.add (al_convertible.serializable_to_json_object (al_convertible))
					elseif attached {ARRAY [detachable ANY]} al_item as al_array_item then
						Result.add (array_to_json_array (al_array_item))
					elseif attached {ARRAYED_LIST [detachable ANY]} al_item as al_arrayed_list_item then
						Result.add (arrayed_list_to_json_array (al_arrayed_list_item))
					else
						if attached any_detachable_to_json_value ({JSON_CONSTANTS}.element_prefix + ic_arrayed_list.cursor_index.out, al_item) as al_value then
							Result.add (al_value)
						else
							Result.add (create {JSON_NULL})
						end
					end
				else
					Result.add (create {JSON_NULL})
				end
			end
		end

feature {NONE} -- Implementation: Keyed Conversions

	tuple_to_json_array (a_key: STRING; a_tuple: TUPLE [detachable ANY]): JSON_ARRAY
			-- Convert `a_tuple' to JSON_ARRAY with `a_key'
		local
			i: INTEGER
		do
			create Result.make_array
			from i := 1
			until i > a_tuple.count
			loop
				if attached any_detachable_to_json_value (a_key, a_tuple.item (i)) as al_value then
					Result.add (al_value)
				end
				i := i + 1
			end
		end

	decimal_to_json_string (a_key: STRING; a_decimal: detachable DECIMAL): JSON_STRING
			-- Convert `a_decimal' to JSON_STRING with `a_key'
			--| The `out_tuple' produces a tuple in the form of: [negative, coefficient, exponent]
			--| For example: 99.9 = [0,999,-1]
		do
			if attached a_decimal then
				create Result.make_json_from_string_32 (a_decimal.out_tuple)
			else
				create Result.make_json_from_string_32 ({JSON_CONSTANTS}.json_void)
			end
		end

	date_to_json_string (a_key: STRING; a_date: DATE): JSON_STRING
			-- Convert `a_date' to JSON_STRING with `a_key'
		do
			create Result.make_json_from_string_32 (a_date.year.out + "/" + a_date.month.out + "/" + a_date.day.out)
		end

	time_to_json_string (a_key: STRING; a_time: TIME): JSON_STRING
			-- Convert `a_time' to JSON_STRING with `a_key'
		do
			create Result.make_json_from_string_32 (a_time.hour.out + "/" + a_time.minute.out + "/" + a_time.second.out)
		end

	date_time_to_json_string (a_key: STRING; a_date_time: DATE_TIME): JSON_STRING
			-- Convert `a_date_time' to JSON_STRING with `a_key'
		do
			create Result.make_json_from_string_32 (a_date_time.year.out + "/" + a_date_time.month.out + "/" + a_date_time.day.out + "/" + a_date_time.hour.out + "/" + a_date_time.minute.out + "/" + a_date_time.second.out)
		end

	any_detachable_to_json_value (a_key: STRING; a_field: detachable ANY): detachable JSON_VALUE
			-- If possible, convert various Eiffel types to JSON types given `a_key', `a_field'.
		do
			create {JSON_NULL} Result
			if attached {JSON_SERIALIZABLE} a_field as al_convertible then
				Result := al_convertible.serializable_to_json_object (al_convertible)
			elseif attached {IMMUTABLE_STRING_8} a_field as al_field then
				create {JSON_STRING} Result.make_json_from_string_32 (al_field.out)
			elseif attached {IMMUTABLE_STRING_32} a_field as al_field then
				create {JSON_STRING} Result.make_json_from_string_32 (al_field.out)
			elseif attached {STRING_8} a_field as al_field then
				create {JSON_STRING} Result.make_json_from_string_32 (al_field)
			elseif attached {STRING_32} a_field as al_field then
				create {JSON_STRING} Result.make_json_from_string_32 (al_field)
			elseif attached {INTEGER_8} a_field as al_integer then
				create {JSON_NUMBER} Result.make_integer (al_integer)
			elseif attached {INTEGER_16} a_field as al_integer then
				create {JSON_NUMBER} Result.make_integer (al_integer)
			elseif attached {INTEGER_32} a_field as al_integer then
				create {JSON_NUMBER} Result.make_integer (al_integer)
			elseif attached {INTEGER_64} a_field as al_integer then
				create {JSON_NUMBER} Result.make_integer (al_integer)
			elseif attached {NATURAL_8} a_field as al_natural then
				create {JSON_NUMBER} Result.make_natural (al_natural)
			elseif attached {NATURAL_16} a_field as al_natural then
				create {JSON_NUMBER} Result.make_natural (al_natural)
			elseif attached {NATURAL_32} a_field as al_natural then
				create {JSON_NUMBER} Result.make_natural (al_natural)
			elseif attached {NATURAL_64} a_field as al_natural then
				create {JSON_NUMBER} Result.make_natural (al_natural)
			elseif attached {REAL_32} a_field as al_real then
				create {JSON_NUMBER} Result.make_real (al_real)
			elseif attached {REAL_64} a_field as al_real then
				create {JSON_NUMBER} Result.make_real (al_real)
			elseif attached {BOOLEAN} a_field as al_boolean then
				create {JSON_BOOLEAN} Result.make_boolean (al_boolean)
			elseif attached {DECIMAL} a_field as al_decimal then
				Result := decimal_to_json_string (a_key, al_decimal)
			elseif attached {ARRAY [detachable ANY]} a_field as al_array then
				Result := array_to_json_array (al_array)
			elseif attached {ARRAYED_LIST [detachable ANY]} a_field as al_array then
				Result := arrayed_list_to_json_array (al_array)
			elseif attached {TUPLE [detachable ANY]} a_field as al_tuple then
				Result := tuple_to_json_array (a_key, al_tuple)
			elseif attached {DECIMAL} a_field as al_decimal then
				Result := decimal_to_json_string (a_key, al_decimal)
			elseif attached {DATE} a_field as al_date then
				Result := date_to_json_string (a_key, al_date)
			elseif attached {TIME} a_field as al_time then
				Result := time_to_json_string (a_key, al_time)
			elseif attached {DATE_TIME} a_field as al_date_time then
				Result := date_time_to_json_string (a_key, al_date_time)
			else
				check unknown_type: False end
			end
		end

end
