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
	date: "$Date: 2015-09-02 16:39:20 -0400 (Wed, 02 Sep 2015) $"
	revision: "$Revision: 12178 $"

deferred class
	JSON_SERIALIZABLE

inherit
	JSON_TRANSFORMABLE

feature -- Access

	representation_from_current (a_current: ANY): STRING
			-- JSON representation of Current (`a_current').
		do
			Result := eiffel_object_to_json_object (a_current).representation
		end

	long_string_tag: STRING_32 = "<<THIS_STRING_WAS_TOO_LONG_TO_BE_PERSISTED>>"
			-- Substitute value persisted into JSON is a string is deemed to be too long.

feature -- Status Report

	is_not_persisting_long_strings: BOOLEAN
			-- Are long strings not being persisted into JSON?
		do
			--| To be redefined by descendants.
		end

feature {JSON_SERIALIZABLE} -- Implementation: Unkeyed Conversions

	eiffel_object_to_json_object (a_object: ANY): JSON_OBJECT
			-- Convert Current (`a_object') to a JSON_OBJECT (if possible) by way of `convertible_features'
			--	list using `reflector'. A detachable (Void) Result (JSON_OBJECT) will be returned in one case
			--	only: No feature of the `convertible_features' list is an attribute. Otherwise,
			--	even attributes with Void results will result in JSON Void representations for
			--	those features.
		local
			i, j: INTEGER
			l_key: STRING
			l_json_key: JSON_STRING
			l_json_value: detachable JSON_VALUE
			l_field: detachable ANY
			l_is_void: BOOLEAN
			l_reflector: INTERNAL
			l_hash: HASH_TABLE [BOOLEAN, STRING]
			l_convertible_features: ARRAYED_LIST [STRING]
		do
			create l_reflector
			create {JSON_OBJECT} Result.make
			create l_convertible_features.make_from_array (convertible_features (a_object))
			create l_hash.make (0)
			l_hash.compare_objects

			from i := 1
			until i > l_convertible_features.count
			loop
				l_hash.force (False, l_convertible_features.i_th (i))
				i := i + 1
			end

			from j := 1
			until j > l_reflector.field_count (a_object)
			loop
				l_key := l_reflector.field_name (j, a_object).twin
				if l_hash.has (l_key) then
					l_hash.force (True, l_key)
					check has_key: l_hash.has_key (l_key) end
					l_field := l_reflector.field (j, a_object)
					create l_json_key.make_json (l_key)
					l_json_value := Void
					l_is_void := False
					if is_not_persisting_long_strings and then attached {READABLE_STRING_GENERAL} l_field as al_string and then al_string.count > long_string_character_count then
						Result.put (create {JSON_STRING}.make_json_from_string_32 (long_string_tag), l_key)
					else
						Result.put (eiffel_to_json (l_field, l_key), l_key)
					end
				end
				j := j + 1
			end
			check all_converted:
				across l_hash as ic_hash all
					ic_hash.item.item
				end
			end
		end

	eiffel_array_to_json_array (a_array: ARRAY [detachable ANY]): JSON_ARRAY
			-- Converts `a_special' (ARRAY or ARRAYED_LIST) to JSON_ARRAY.
			-- Detachable elements are represented by JSON_NULL in Result.
		local
			k: INTEGER
		do
			create Result.make_array
			if attached {ARRAY [detachable ANY]} a_array as al_array then
				from k := 1
				until k > al_array.count
				loop
					if attached al_array.item (k) as al_item then
						if attached {JSON_SERIALIZABLE} al_item as al_convertible then
							Result.add (al_convertible.eiffel_object_to_json_object (al_convertible))
						elseif attached {ARRAY [detachable ANY]} al_item as al_array_item then
							Result.add (eiffel_array_to_json_array (al_array_item))
						elseif attached {ARRAYED_LIST [detachable ANY]} al_item as al_arrayed_list_item then
							Result.add (eiffel_arrayed_list_to_json_array (al_arrayed_list_item))
						else
							if attached eiffel_any_to_json_value ("element_" + k.out, al_item) as al_value then
								Result.add (al_value)
							else
								Result.add (create {JSON_NULL})
							end
						end
					else
						Result.add (create {JSON_NULL})
					end
					k := k + 1
				end
			end
		end

	eiffel_arrayed_list_to_json_array (a_arrayed_list: ARRAYED_LIST [detachable ANY]): JSON_ARRAY
			-- Converts `a_special' (ARRAY or ARRAYED_LIST) to JSON_ARRAY.
			-- Detachable elements are represented by JSON_NULL in Result.
		local
			k: INTEGER
		do
			create Result.make_array
			if attached {ARRAYED_LIST [detachable ANY]} a_arrayed_list as al_arrayed_list then
				from al_arrayed_list.start
				until al_arrayed_list.exhausted
				loop
					if attached al_arrayed_list.item_for_iteration as al_item then
						if attached {JSON_SERIALIZABLE} al_item as al_convertible then
							Result.add (al_convertible.eiffel_object_to_json_object (al_convertible))
						elseif attached {ARRAY [detachable ANY]} al_item as al_array_item then
							Result.add (eiffel_array_to_json_array (al_array_item))
						elseif attached {ARRAYED_LIST [detachable ANY]} al_item as al_arrayed_list_item then
							Result.add (eiffel_arrayed_list_to_json_array (al_arrayed_list_item))
						else
							if attached eiffel_any_to_json_value ("element_" + k.out, al_item) as al_value then
								Result.add (al_value)
							else
								Result.add (create {JSON_NULL})
							end
						end
					else
						Result.add (create {JSON_NULL})
					end
					al_arrayed_list.forth
				end
			end
		end

feature {NONE} -- Implementation: Keyed Conversions

	eiffel_mixed_number_json_array (a_key: STRING; a_mixed_number: FW_MIXED_NUMBER): JSON_ARRAY
			-- Converts `a_mixed_number' to JSON_ARRAY with the following specification:
			-- "feature_name":[is_negative, whole_part, numerator, denominator]
		local
			l_negative: JSON_BOOLEAN
			l_whole_part: JSON_NUMBER
			l_numerator: JSON_NUMBER
			l_denominator: JSON_NUMBER
		do
			create l_negative.make_boolean (a_mixed_number.is_negative)
			create l_whole_part.make_integer (a_mixed_number.whole_part.as_integer_64)
			create l_numerator.make_integer (a_mixed_number.numerator)
			create l_denominator.make_integer (a_mixed_number.denominator)
			create Result.make_array
			Result.add (l_negative)
			Result.add (l_whole_part)
			Result.add (l_numerator)
			Result.add (l_denominator)
		ensure
			four_values: Result.count = 4
			first_boolean: attached {JSON_BOOLEAN} Result.i_th (1)
			second_number: attached {JSON_NUMBER} Result.i_th (2)
			second_same_number: Result.i_th (2).is_equal (create {JSON_NUMBER}.make_integer (a_mixed_number.whole_part.as_integer_64))
			third_number: attached {JSON_NUMBER} Result.i_th (3)
			third_same_number: Result.i_th (3).is_equal (create {JSON_NUMBER}.make_integer (a_mixed_number.numerator))
			fourth_number: attached {JSON_NUMBER} Result.i_th (4)
			fourth_same_number: Result.i_th (4).is_equal (create {JSON_NUMBER}.make_integer (a_mixed_number.denominator))
		end

	eiffel_tuple_to_json_array (a_key: STRING; a_tuple: TUPLE [detachable ANY]): JSON_ARRAY
			-- Convert `a_tuple' to JSON_ARRAY with `a_key'
		local
			i: INTEGER
		do
			create Result.make_array
			from i := 1
			until i > a_tuple.count
			loop
				if attached eiffel_to_json (a_tuple.item (i), a_key) as al_value then
					Result.add (al_value)
				end
				i := i + 1
			end
		end

	eiffel_decimal_to_json_string (a_key: STRING; a_decimal: detachable DECIMAL): JSON_STRING
			-- Convert `a_decimal' to JSON_STRING with `a_key'
			--| The `out_tuple' produces a tuple in the form of: [negative, coefficient, exponent]
			--| For example: 99.9 = [0,999,-1]
		do
			if attached a_decimal as al_decimal then
				create Result.make_json_from_string_32 (al_decimal.out_tuple)
			else
				create Result.make_json_from_string_32 ("void")
			end
		end

	eiffel_date_to_json_string (a_key: STRING; a_date: DATE): JSON_STRING
			-- Convert `a_date' to JSON_STRING with `a_key'
		do
			create Result.make_json_from_string_32 (a_date.year.out + "/" + a_date.month.out + "/" + a_date.day.out)
		end

	eiffel_time_to_json_string (a_key: STRING; a_time: TIME): JSON_STRING
			-- Convert `a_time' to JSON_STRING with `a_key'
		do
			create Result.make_json_from_string_32 (a_time.hour.out + "/" + a_time.minute.out + "/" + a_time.second.out)
		end

	eiffel_date_time_to_json_string (a_key: STRING; a_date_time: DATE_TIME): JSON_STRING
			-- Convert `a_date_time' to JSON_STRING with `a_key'
		do
			create Result.make_json_from_string_32 (a_date_time.year.out + "/" + a_date_time.month.out + "/" + a_date_time.day.out + "/" + a_date_time.hour.out + "/" + a_date_time.minute.out + "/" + a_date_time.second.out)
		end

	eiffel_any_to_json_value (a_key: STRING; a_field: ANY): detachable JSON_VALUE
			-- If possible, convert various Eiffel types to JSON types given `a_key', `a_field'.
		local
			l_json_key: JSON_STRING
			l_json_value: detachable JSON_VALUE
			l_is_void: BOOLEAN
		do
			create {JSON_NULL} Result
			create l_json_key.make_json_from_string_32 (a_key)
			l_json_value := Void
			l_is_void := False

			if attached {JSON_SERIALIZABLE} a_field as al_convertible then
				Result := al_convertible.eiffel_object_to_json_object (al_convertible)
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
			elseif attached {TUPLE [detachable ANY]} a_field as al_tuple then
				Result := eiffel_tuple_to_json_array (a_key, al_tuple)
			elseif attached {FW_MIXED_NUMBER} a_field as al_mixed_number then
				Result := eiffel_mixed_number_json_array (a_key, al_mixed_number)
			elseif attached {DECIMAL} a_field as al_decimal then
				Result := eiffel_decimal_to_json_string (a_key, al_decimal)
			end
		end

	eiffel_to_json (a_field: detachable ANY; a_key: STRING): detachable JSON_VALUE
			-- ???
		do
			create {JSON_NULL} Result
			if attached {JSON_SERIALIZABLE} a_field as al_convertible then
				Result := al_convertible.eiffel_object_to_json_object (al_convertible)
			elseif attached {ARRAY [detachable ANY]} a_field as al_array then
				Result := eiffel_array_to_json_array (al_array)
			elseif attached {ARRAYED_LIST [detachable ANY]} a_field as al_array then
				Result := eiffel_arrayed_list_to_json_array (al_array)
			elseif attached {FW_MIXED_NUMBER} a_field as al_mixed_number then
				Result := eiffel_mixed_number_json_array (a_key, al_mixed_number)
			elseif attached {TUPLE [detachable ANY]} a_field as al_tuple then
				Result := eiffel_tuple_to_json_array (a_key, al_tuple)
			elseif attached {DECIMAL} a_field as al_decimal then
				Result := eiffel_decimal_to_json_string (a_key, al_decimal)
			elseif attached {DATE} a_field as al_date then
				Result := eiffel_date_to_json_string (a_key, al_date)
			elseif attached {TIME} a_field as al_time then
				Result := eiffel_time_to_json_string (a_key, al_time)
			elseif attached {DATE_TIME} a_field as al_date_time then
				Result := eiffel_date_time_to_json_string (a_key, al_date_time)
			elseif attached {TUPLE [detachable ANY]} a_field as al_tuple then
				Result := eiffel_tuple_to_json_array (a_key, al_tuple)
			elseif attached {FW_MIXED_NUMBER} a_field as al_mixed_number then
				Result := eiffel_mixed_number_json_array (a_key, al_mixed_number)
			elseif attached {DECIMAL} a_field as al_decimal then
				Result := eiffel_decimal_to_json_string (a_key, al_decimal)
			elseif attached a_field as al_field then
				Result := eiffel_any_to_json_value (a_key, al_field)
			end

		end

feature {NONE} -- Implementation

	long_string_character_count: INTEGER
			-- If a string has more characters than the output of this feature, it is considered a long string.
		do
			Result := 10000
		end

end
