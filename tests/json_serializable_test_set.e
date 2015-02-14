note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date: 2014-05-16 14:48:28 -0400 (Fri, 16 May 2014) $"
	revision: "$Revision: 9183 $"
	testing: "type/manual"

class
	JSON_SERIALIZABLE_TEST_SET

inherit
	TEST_SET_HELPER
		redefine
			on_prepare
		end

	JSON_SERIALIZABLE
		undefine
			default_create
		end

feature {NONE} -- Initialization

	on_prepare
		do
			Precursor
			name := "Bugs Bunny"
		end

feature -- Test routines

	test_representation
			-- Test `representation_from_current'
		do
			assert_equals ("current_representation_consistent", current_representation, representation_from_current (Current))
		end

	test_eiffel_object_to_json_object
			-- Test `serializable_to_json_object'
		local
			l_object: JSON_OBJECT
		do
			l_object := serializable_to_json_object (Current)
			assert_equals ("object", current_representation, l_object.representation)
		end

	test_eiffel_array_to_json_array
			-- Test `array_to_json_array'
		local
			l_json_array: JSON_ARRAY
		do
			l_json_array := array_to_json_array (<<1,2,3,4,5>>)
			assert_equals ("has_five_elements", 5, l_json_array.count)
			assert_equals ("one", 1, l_json_array.i_th (1).representation.to_integer)
			assert_equals ("two", 2, l_json_array.i_th (2).representation.to_integer)
			assert_equals ("three", 3, l_json_array.i_th (3).representation.to_integer)
			assert_equals ("four", 4, l_json_array.i_th (4).representation.to_integer)
			assert_equals ("five", 5, l_json_array.i_th (5).representation.to_integer)
		end

	test_eiffel_tuple_to_json_array
			-- Test `tuple_to_json_array'
		local
			l_json_array: JSON_ARRAY
		do
			l_json_array := tuple_to_json_array ("tuple", ["Bugs Bunny", 90])
			assert_equals ("tuple", "[%"Bugs Bunny%",90]", l_json_array.representation)
		end

	test_eiffel_decimal_to_json_string
			-- Test `decimal_to_json_string'
		local
			l_decimal: DECIMAL
			l_json_string: JSON_STRING
		do
			create l_decimal.make_from_string ("123.456")
			l_json_string := decimal_to_json_string ("decimal", l_decimal)
			assert_equals ("decimal", "%"[0,123456,-3]%"", l_json_string.representation)
		end

	test_eiffel_void_decimal_to_json_string
			-- Test `decimal_to_json_string'
		local
			l_decimal: detachable DECIMAL
			l_json_string: JSON_STRING
		do
			l_json_string := decimal_to_json_string ("decimal", Void)
			assert_equals ("decimal", "%"void%"", l_json_string.representation)
		end

	test_eiffel_date_to_json_string
			-- Test `date_to_json_string'
		local
			l_date: DATE
			l_json_string: JSON_STRING
		do
			create l_date.make_month_day_year (1, 8, 1963)
			l_json_string := date_to_json_string ("date", l_date)
			assert_equals ("date", "%"1963/1/8%"", l_json_string.representation)
		end

	test_eiffel_time_to_json_string
			-- Test `time_to_json_string'
		local
			l_json_string: JSON_STRING
		do
			l_json_string := time_to_json_string ("time", create {TIME}.make (5, 15, 30))
			assert_equals ("time", "%"5/15/30%"", l_json_string.representation)
		end

	test_eiffel_date_time_to_json_string
			-- Test `date_time_to_json_string'
		local
			l_date_time: DATE_TIME
			l_json_string: JSON_STRING
		do
			create l_date_time.make (2012, 12, 21, 6, 6, 6)
			l_json_string := date_time_to_json_string ("date_time", l_date_time)
			assert_equals ("doomsday_date_time", "%"2012/12/21/6/6/6%"", l_json_string.representation)
		end

	test_eiffel_any_to_json_value
			-- Test `any_detachable_to_json_value'
		do
				--| STRING
			check json_string_8: attached {JSON_STRING} any_detachable_to_json_value ("string_8", ("Elmer Fudd").to_string_8) as al_json_string then
				assert_equals ("json_string_8", "%"Elmer Fudd%"", al_json_string.representation)
			end
			check json_string_32: attached {JSON_STRING} any_detachable_to_json_value ("string_32", ("Elmer Fudd").to_string_32) as al_json_string then
				assert_equals ("json_string_32", "%"Elmer Fudd%"", al_json_string.representation)
			end

				--| INTEGER
			check json_integer_8: attached {JSON_NUMBER} any_detachable_to_json_value ("integer_8", (8).to_integer_8) as al_json_number then
				assert_equals ("integer_8", "8", al_json_number.representation)
			end
			check json_integer_16: attached {JSON_NUMBER} any_detachable_to_json_value ("integer_16", (16).to_integer_16) as al_json_number then
				assert_equals ("integer_16", "16", al_json_number.representation)
			end
			check json_integer_32: attached {JSON_NUMBER} any_detachable_to_json_value ("integer_32", (32).to_integer_32) as al_json_number then
				assert_equals ("integer_32", "32", al_json_number.representation)
			end
			check json_integer_64: attached {JSON_NUMBER} any_detachable_to_json_value ("integer_64", (64).to_integer_64) as al_json_number then
				assert_equals ("integer_64", "64", al_json_number.representation)
			end

				--| NATURAL
			check json_natural_8: attached {JSON_NUMBER} any_detachable_to_json_value ("natural_8", (8).to_natural_8) as al_json_number then
				assert_equals ("natural_8", "8", al_json_number.representation)
			end
			check json_natural_16: attached {JSON_NUMBER} any_detachable_to_json_value ("natural_16", (16).to_natural_16) as al_json_number then
				assert_equals ("natural_16", "16", al_json_number.representation)
			end
			check json_natural_32: attached {JSON_NUMBER} any_detachable_to_json_value ("natural_32", (32).to_natural_32) as al_json_number then
				assert_equals ("natural_32", "32", al_json_number.representation)
			end
			check json_natural_64: attached {JSON_NUMBER} any_detachable_to_json_value ("natural_64", (64).to_natural_64) as al_json_number then
				assert_equals ("natural_64", "64", al_json_number.representation)
			end

				--| REAL
			check json_real_32: attached {JSON_NUMBER} any_detachable_to_json_value ("real_32", (3.2).item) as al_json_number then
				assert_equals ("real_32", "3.2000000000000002", al_json_number.representation)
			end
			check json_real_64: attached {JSON_NUMBER} any_detachable_to_json_value ("real_64", (6.4).item) as al_json_number then
				assert_equals ("real_64", "6.4000000000000004", al_json_number.representation)
			end

				--| BOOLEAN
			check boolean_true: attached {JSON_BOOLEAN} any_detachable_to_json_value ("boolean_true", true) as al_json_boolean then
				assert_equals ("boolean_true", "true", al_json_boolean.representation)
			end

				--| TUPLE
			check tuple_numerics: attached {JSON_ARRAY} any_detachable_to_json_value ("tuple_numerics", [1,2,3]) as al_json_array then
				assert_equals ("tuple_numerics", "[1,2,3]", al_json_array.representation)
			end
			check tuple_strings: attached {JSON_ARRAY} any_detachable_to_json_value ("tuple_strings", ["Larry", "Curly", "Mo"]) as al_json_array then
				assert_equals ("tuple_strings", "[%"Larry%",%"Curly%",%"Mo%"]", al_json_array.representation)
			end
			check tuple_mixed: attached {JSON_ARRAY} any_detachable_to_json_value ("tuple_mixed", [1, "Curly", 3]) as al_json_array then
				assert_equals ("tuple_mixed", "[1,%"Curly%",3]", al_json_array.representation)
			end

				--| DECIMAL
			check decimal: attached {JSON_STRING} any_detachable_to_json_value ("decimal", create {DECIMAL}.make_from_string ("123.456")) as al_json_string then
				assert_equals ("decimal", "%"[0,123456,-3]%"", al_json_string.representation)
			end
		end

feature {NONE} -- Implementation: Representation Constants

	current_representation: STRING = "{%"name%":%"Bugs Bunny%"}"

feature {NONE} -- Implementation: Mock Features

	name: STRING

feature {NONE} -- Implementation

	convertible_features (a_object: ANY): ARRAY [STRING]
			-- <Precursor>
		once
			Result := <<"name">>
		end

;end


