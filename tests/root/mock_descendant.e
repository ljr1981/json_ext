note
	description: "Summary description for {MOCK_DESCENDANT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOCK_DESCENDANT

inherit
	MOCK_ANCESTOR
		export
			{NONE} all
			{MOCK_DESCENDANT, TEST_SET_BRIDGE}
				ancestor_name
		end

	JSON_SERIALIZABLE

	JSON_DESERIALIZABLE

create
	make_from_json

feature {NONE} -- Initialization

	make_from_json (a_json: STRING_8)
			-- <Precursor>
		require else											-- This must be here because the ancestor is False.
			True												--	Leaving it False, will cause this to fail.
		local
			l_object: detachable JSON_OBJECT					-- You must have one of these because ...
			l_any: detachable ANY
		do
			l_object := json_string_to_json_object (a_json)		-- ... the JSON string is parsed to a JSON_OBJECT.
			check attached_object: attached l_object end		-- This proves that our JSON parsing was okay.

				-- {STRING}s
			ancestor_name := json_object_to_json_string_representation_attached ("ancestor_name", l_object)
			descendant_name := json_object_to_json_string_representation_attached ("descendant_name", l_object)
		end

feature -- Access

	descendant_name: STRING
			-- `descendant_name' feature for {INTERNAL} testing
		attribute
			create Result.make_empty
		end

feature {NONE} -- Implementation: Access

	metadata (a_current: ANY): ARRAY [JSON_METADATA]
		do
			Result := <<
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default
						>>
		end

	convertible_features (a_current: ANY): ARRAY [STRING]
			-- Features of Current (`a_current') identified to participate in JSON conversion.
		do
			Result := <<"ancestor_name", "descendant_name">>
		end

end
