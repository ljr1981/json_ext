note
	description: "A Mock Google Calendar Resource"

class
	MOCK_RESOURCE

inherit
	JSE_AWARE
		redefine
			json_out
		end

create
	make_from_json,
	make_with_end_event

feature {NONE} -- Initialization

	make_with_end_event (a_end_event: like end_event)
			--
		do
			end_event := a_end_event
		end

	make_from_json (a_json: STRING)
			--<Precursor>
		require else
			True
		local
			l_object: detachable JSON_OBJECT
		do
			l_object := json_string_to_json_object (a_json)
			check attached l_object as al_object then
				check attached json_object_to_json_string_representation_attached (end_event_identifier, al_object) as al_end_event_json then
					create end_event.make_from_json (al_end_event_json)
				end
			end
		end

feature {NONE} -- Constants

	end_event_identifier: STRING = "end"

feature -- Access

	end_event: MOCK_END_EVENT

feature -- Setters

	set_end_event (a_item: like end_event)
			--
		do
			end_event := a_item
		end

feature -- Output

	json_out: STRING
			--<Precursor>
		do
			Result := Precursor
			Result.replace_substring_all ("end_event", "end")
			Result.replace_substring_all ("datetime", "dateTime")
			Result.replace_substring_all ("timezone", "timeZone")
		end

feature {NONE} -- Implementation

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			-- <Precursor>
		do
			Result := <<
						create {JSON_METADATA}.make_text_default
						>>
		end

	convertible_features (a_object: ANY): ARRAY [STRING]
			-- <Precursor>
		once ("object")
			Result := <<
						"end_event"
						>>
		end

end
