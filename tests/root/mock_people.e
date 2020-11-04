note
	description: "Mock of People"

class
	MOCK_PEOPLE

inherit
	JSE_AWARE

create
	default_create,
	make_from_json

feature {NONE} -- Initialization

	make_from_json (a_json: STRING)
			-- <Precursor>
		require else
			implemented: True
		do
			check required_root_object: attached json_string_to_json_object (a_json) as al_object then
					-- Parse and add people items ...
				across
					json_object_to_tuple_as_json_array ("people", al_object) as ic_people
				loop
					check has_person: attached {JSON_VALUE} ic_people.item as al_value then
						check has_object: attached {JSON_OBJECT} json_string_to_json_object (al_value.representation) as al_person_object then
							people.force (create {MOCK_ELMER}.make_from_json (al_person_object.representation))
						end
					end
				end
			end
		end

feature -- Access

	people: ARRAYED_LIST [MOCK_ELMER]
			-- A list of `people' that can be serialized and deserialized.
		attribute
			create Result.make (2)
		end

feature {NONE} -- Implementation

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			-- <Precursor>
		do
			Result := <<
						create {JSON_METADATA}.make_text_default
						>>
		end

	convertible_features (a_current: ANY): ARRAY [STRING]
			-- <Precursor>
		do
			Result := <<
					"people"
					>>
		end

	convertible_features_tuple: TUPLE [people: STRING]
			--
		do
			Result := [convertible_features (Current) [1]]
		end

end
