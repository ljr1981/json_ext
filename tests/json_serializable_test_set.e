note
	testing: "type/manual"

class
	JSON_SERIALIZABLE_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		redefine
			on_prepare
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
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
			assert_equal ("current_representation_consistent", current_representation, representation_from_current (Current))
		end

	test_eiffel_object_to_json_object
			-- Test `eiffel_object_to_json_object'
		note
			testing:
				"covers/{JSON_SERIALIZABLE}.eiffel_object_to_json_object",
				"covers/{JSON_SERIALIZABLE}.convertible_features",
				"covers/{JSON_SERIALIZABLE}.eiffel_to_json"
		local
			l_object: JSON_OBJECT
		do
			l_object := eiffel_object_to_json_object (Current)
			assert_equal ("object", current_representation, l_object.representation)
		end

	test_eiffel_array_to_json_array
			-- Test `eiffel_array_to_json_array'
		local
			l_array: ARRAY [INTEGER]
			l_json_array: JSON_ARRAY
		do
			create l_array.make_from_array (<<1,2,3,4,5>>)
			l_json_array := eiffel_array_to_json_array (l_array)
			assert_equal ("has_five_elements", 5, l_json_array.count)
			assert_equal ("one", 1, l_json_array.i_th (1).representation.to_integer)
			assert_equal ("two", 2, l_json_array.i_th (2).representation.to_integer)
			assert_equal ("three", 3, l_json_array.i_th (3).representation.to_integer)
			assert_equal ("four", 4, l_json_array.i_th (4).representation.to_integer)
			assert_equal ("five", 5, l_json_array.i_th (5).representation.to_integer)
		end

	test_eiffel_mixed_number_to_json_array
			-- Test `eiffel_mixed_number_to_json_array'
		local
			l_mixed_number: FW_MIXED_NUMBER
			l_json_array: JSON_ARRAY
		do
			create l_mixed_number.make (False, 1, 2, 3)
			l_json_array := eiffel_mixed_number_json_array ("mixed_number_positive", l_mixed_number)
			assert_equal ("mixed_number_representation_1_2_3", "[false,1,2,3]", l_json_array.representation)
			create l_mixed_number.make (True, 5, 1, 6)
			l_json_array := eiffel_mixed_number_json_array ("mixed_number_negative", l_mixed_number)
			assert_equal ("mixed_number_representation_neg_5_1_6", "[true,5,1,6]", l_json_array.representation)
		end

	test_eiffel_tuple_to_json_array
			-- Test `eiffel_tuple_to_json_array'
		local
			l_tuple: TUPLE [name: STRING; age: INTEGER]
			l_json_array: JSON_ARRAY
		do
			l_tuple := ["Bugs Bunny", 90]
			l_json_array := eiffel_tuple_to_json_array ("tuple", l_tuple)
			assert_equal ("tuple", "[%"Bugs Bunny%",90]", l_json_array.representation)
		end

	test_eiffel_decimal_to_json_string
			-- Test `eiffel_decimal_to_json_string'
		local
			l_decimal: DECIMAL
			l_json_string: JSON_STRING
		do
			create l_decimal.make_from_string ("123.456")
			l_json_string := eiffel_decimal_to_json_string ("decimal", l_decimal)
			assert_equal ("decimal", "%"[0,123456,-3]%"", l_json_string.representation)
		end

	test_eiffel_void_decimal_to_json_string
			-- Test `eiffel_decimal_to_json_string'
		local
			l_decimal: detachable DECIMAL
			l_json_string: JSON_STRING
		do
			l_json_string := eiffel_decimal_to_json_string ("decimal", Void)
			assert_equal ("decimal", "%"void%"", l_json_string.representation)
		end

	test_eiffel_date_to_json_string
			-- Test `eiffel_date_to_json_string'
		local
			l_date: DATE
			l_json_string: JSON_STRING
		do
			create l_date.make_month_day_year (1, 8, 1963)
			l_json_string := eiffel_date_to_json_string ("date", l_date)
			assert_equal ("date", "%"1963/1/8%"", l_json_string.representation)
		end

	test_eiffel_time_to_json_string
			-- Test `eiffel_time_to_json_string'
		local
			l_time: TIME
			l_json_string: JSON_STRING
		do
			create l_time.make (5, 15, 30)
			l_json_string := eiffel_time_to_json_string ("time", l_time)
			assert_equal ("time", "%"5/15/30%"", l_json_string.representation)
		end

	test_eiffel_date_time_to_json_string
			-- Test `eiffel_date_time_to_json_string'
		local
			l_date_time: DATE_TIME
			l_json_string: JSON_STRING
		do
			create l_date_time.make (2012, 12, 21, 6, 6, 6)
			l_json_string := eiffel_date_time_to_json_string ("date_time", l_date_time)
			assert_equal ("doomsday_date_time", "%"2012/12/21/6/6/6%"", l_json_string.representation)
		end

	test_eiffel_any_to_json_value
			-- Test `eiffel_any_to_json_value'
		note
				-- Top-level NPath calls
			testing:
				"covers/{JSON_SERIALIZABLE}.eiffel_object_to_json_object",
				"covers/{JSON_SERIALIZABLE}.eiffel_tuple_to_json_array",
				"covers/{JSON_SERIALIZABLE}.eiffel_mixed_number_json_array",
				"covers/{JSON_SERIALIZABLE}.eiffel_decimal_to_json_string"
		do
				--| STRING
			check json_string_8: attached {JSON_STRING} eiffel_any_to_json_value ("string_8", ("Elmer Fudd").to_string_8) as al_json_string then
				assert_equal ("json_string_8", "%"Elmer Fudd%"", al_json_string.representation)
			end
			check json_string_32: attached {JSON_STRING} eiffel_any_to_json_value ("string_32", ("Elmer Fudd").to_string_32) as al_json_string then
				assert_equal ("json_string_32", "%"Elmer Fudd%"", al_json_string.representation)
			end

				--| INTEGER
			check json_integer_8: attached {JSON_NUMBER} eiffel_any_to_json_value ("integer_8", (8).to_integer_8) as al_json_number then
				assert_equal ("integer_8", "8", al_json_number.representation)
			end
			check json_integer_16: attached {JSON_NUMBER} eiffel_any_to_json_value ("integer_16", (16).to_integer_16) as al_json_number then
				assert_equal ("integer_16", "16", al_json_number.representation)
			end
			check json_integer_32: attached {JSON_NUMBER} eiffel_any_to_json_value ("integer_32", (32).to_integer_32) as al_json_number then
				assert_equal ("integer_32", "32", al_json_number.representation)
			end
			check json_integer_64: attached {JSON_NUMBER} eiffel_any_to_json_value ("integer_64", (64).to_integer_64) as al_json_number then
				assert_equal ("integer_64", "64", al_json_number.representation)
			end

				--| NATURAL
			check json_natural_8: attached {JSON_NUMBER} eiffel_any_to_json_value ("natural_8", (8).to_natural_8) as al_json_number then
				assert_equal ("natural_8", "8", al_json_number.representation)
			end
			check json_natural_16: attached {JSON_NUMBER} eiffel_any_to_json_value ("natural_16", (16).to_natural_16) as al_json_number then
				assert_equal ("natural_16", "16", al_json_number.representation)
			end
			check json_natural_32: attached {JSON_NUMBER} eiffel_any_to_json_value ("natural_32", (32).to_natural_32) as al_json_number then
				assert_equal ("natural_32", "32", al_json_number.representation)
			end
			check json_natural_64: attached {JSON_NUMBER} eiffel_any_to_json_value ("natural_64", (64).to_natural_64) as al_json_number then
				assert_equal ("natural_64", "64", al_json_number.representation)
			end

				--| REAL
			check json_real_32: attached {JSON_NUMBER} eiffel_any_to_json_value ("real_32", (3.2).item) as al_json_number then
				assert_equal ("real_32", "3.2000000000000002", al_json_number.representation)
			end
			check json_real_64: attached {JSON_NUMBER} eiffel_any_to_json_value ("real_64", (6.4).item) as al_json_number then
				assert_equal ("real_64", "6.4000000000000004", al_json_number.representation)
			end

				--| BOOLEAN
			check boolean_true: attached {JSON_BOOLEAN} eiffel_any_to_json_value ("boolean_true", true) as al_json_boolean then
				assert_equal ("boolean_true", "true", al_json_boolean.representation)
			end

				--| TUPLE
			check tuple_numerics: attached {JSON_ARRAY} eiffel_any_to_json_value ("tuple_numerics", [1,2,3]) as al_json_array then
				assert_equal ("tuple_numerics", "[1,2,3]", al_json_array.representation)
			end
			check tuple_strings: attached {JSON_ARRAY} eiffel_any_to_json_value ("tuple_strings", ["Larry", "Curly", "Mo"]) as al_json_array then
				assert_equal ("tuple_strings", "[%"Larry%",%"Curly%",%"Mo%"]", al_json_array.representation)
			end
			check tuple_mixed: attached {JSON_ARRAY} eiffel_any_to_json_value ("tuple_mixed", [1, "Curly", 3]) as al_json_array then
				assert_equal ("tuple_mixed", "[1,%"Curly%",3]", al_json_array.representation)
			end

				--| MIXED_NUMBER
			check mixed_number: attached {JSON_ARRAY} eiffel_any_to_json_value ("mixed_number", create {FW_MIXED_NUMBER}.make (False, 1, 2, 3)) as al_json_array then
				assert_equal ("mixed_number", "[false,1,2,3]", al_json_array.representation)
			end

				--| DECIMAL
			check decimal: attached {JSON_STRING} eiffel_any_to_json_value ("decimal", create {DECIMAL}.make_from_string ("123.456")) as al_json_string then
				assert_equal ("decimal", "%"[0,123456,-3]%"", al_json_string.representation)
			end
		end

feature {NONE} -- Implementation: Representation Constants

	current_representation: STRING = "{%"name%":%"Bugs Bunny%"}"

feature {NONE} -- Implementation: Mock Features

	name: STRING

feature {NONE} -- Implementation

	metadata (a_current: ANY): ARRAY [TUPLE [type: STRING]]
		do
			Result := <<
						["text"]
						>>
		end

	convertible_features (a_object: ANY): ARRAY [STRING]
			-- <Precursor>
		once
			Result := <<"name">>
		end

end


