note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	JSON_METADATA_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	metadata_creations_tests
			-- `metadata_creations_tests'
		local
			l_meta: JSON_METADATA
		do
			create l_meta.make_text_default
		end

end


