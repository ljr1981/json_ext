note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	MOCK_OBJECT_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	mock_object_tests
			-- `mock_object_tests'
		local
			l_mock: MOCK_OBJECT
		do
			create l_mock
				-- count of items
			assert_integers_equal ("count", 4, l_mock.attributes_hash_on_name (l_mock).count)

				-- data types
			assert_strings_equal ("string", 	"some_string", 	l_mock.attribute_value_string ("my_string", l_mock))
			assert_integers_equal ("integer", 	9999, 			l_mock.attribute_value_integer ("my_integer", l_mock))
			assert_strings_equal ("real", 		"9.999", 		l_mock.attribute_value_real ("my_real", l_mock).out)
			assert_booleans_equal ("boolean", 	True, 			l_mock.attribute_value_boolean ("my_boolean", l_mock))
		end

end


