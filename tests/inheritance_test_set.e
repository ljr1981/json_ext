note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	INHERITANCE_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Test routines

	inheritance_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_mock: MOCK_DESCENDANT
		do
			create l_mock.make_from_json (json_string)
			assert_strings_equal ("ancestor", "fred", l_mock.ancestor_name)
			assert_strings_equal ("json", json_string, l_mock.representation_from_current (l_mock))
		end

feature {NONE} -- Constants

	json_string: STRING = "[
{"ancestor_name":"fred","descendant_name":"pebbles"}
]"

end


