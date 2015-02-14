note
	description: "[
		Tests of the {MOCK_PERSON} class.
		]"

class
	MOCK_PERSON_TEST_SET

inherit
	TEST_SET_HELPER

feature -- Tests

	mock_person_serialization_test
			-- Test serialization of {MOCK_PERSON} object.
		local
			l_mock: MOCK_PERSON
		do
			create l_mock
			l_mock.set_first_name (test_first_name)
			l_mock.set_last_name (test_last_name)
			assert_strings_equal ("serialized_mock_person", mock_person_json, l_mock.representation_from_current (l_mock))
		end

	mock_person_deserialization_test
			-- Test deserialization of `mock_person_json' to {MOCK_PERSON} object.
		local
			l_mock: MOCK_PERSON
		do
			create l_mock.make_from_json (mock_person_json)
			assert_strings_equal ("first_name", test_first_name, l_mock.first_name)
			assert_strings_equal ("last_name", test_last_name, l_mock.last_name)
		end

feature {NONE} -- Implementation: Constants

	mock_person_json: STRING = "[
{"first_name":"Bugs","last_name":"Bunny"}
]"

	test_first_name: STRING = "Bugs"

	test_last_name: STRING = "Bunny"

end
