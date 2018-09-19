note
	description: "Mock PERSON for Serialization (from ancestor) and Deserialization (added here by inheritance) testing"

class
	MOCK_PERSON_FOR_BOTH_SERIALIZATION_AND_DESERIALIZATION

inherit
	MOCK_PERSON_FOR_SERIALIZATION_ONLY

	JSON_DESERIALIZABLE

create
	default_create,
	make_from_json

feature {NONE} -- Initialization

	make_from_json (a_json: STRING)
			-- <Precursor>
		require else
			True
		do
			check has_root_object: attached json_string_to_json_object (a_json) as al_object then
				name := json_object_to_json_string_representation_attached ("name", al_object)
				age := json_object_to_integer ("age", al_object)
				date_of_birth := json_object_to_date_attached ("date_of_birth", al_object)
			end
		end

end
