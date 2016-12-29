note
	description: "Summary description for {MOCK_ANCESTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOCK_ANCESTOR

feature -- Access

	ancestor_name: STRING
			-- `ancestor_name' feature for {INTERNAL} testing
		attribute
			create Result.make_empty
		end

end
