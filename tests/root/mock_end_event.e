note
	description: "A Mock Google Calendar End Event"

class
	MOCK_END_EVENT

inherit
	JSE_AWARE
		redefine
			json_out
		end

create
	make_from_json

feature {NONE} -- Initialization

	make_from_json (a_json: STRING)
			--<Precursor>
			-- Ensure `date', `datetime', and `timezone' are found and extracted.
		require else
			True
		local
			l_object: detachable JSON_OBJECT
		do
			l_object := json_string_to_json_object (a_json)
			check attached l_object as al_object then
				create date.make_from_string (json_object_to_json_string_representation_attached ("date", l_object), "yyyy/[0]mm/[0]dd")
				create datetime.make_from_string (json_object_to_json_string_representation_attached (datetime_identifier, l_object), "yyyy/[0]mm/[0]dd hh24:[0]mi:[0]ss")
				timezone := json_object_to_json_string_representation_attached (timezone_identifier, l_object)
			end
		end

feature {NONE} -- Constants

	datetime_identifier: STRING = "dateTime"
			-- A camel-cased dateTime identifier to match Google.

	timezone_identifier: STRING = "timeZone"
			-- A camel-cased timeZone identifier to match Google.

feature -- Access

	date: DATE
			-- What is the `date' of the Event?
		attribute
			create Result.make_now
		end

	datetime: DATE_TIME
			-- What is the `datetime' of the Event?
		attribute
			create Result.make_now
		end

	timeZone: STRING
			-- What `timezone' is the Event in?
		attribute
			create Result.make_empty
		end

feature -- Status Report

	has_json_input_error: BOOLEAN
			--<Precursor>

feature -- Output

	json_out: STRING
			--<Precursor>
			--Reformat datetime and timezone to camel-cased versions per Google.
		do
			Result := Precursor
			Result.replace_substring_all ("datetime", "dateTime")
			Result.replace_substring_all ("timezone", "timeZone")
		end

feature {NONE} -- Implementation

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			-- <Precursor>
		do
			Result := <<
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default
						>>
		end

	convertible_features (a_object: ANY): ARRAY [STRING]
			-- <Precursor>
			-- Never use the camel-casing here. This is for Eiffel reference.
		once ("object")
			Result := <<
						"date",
						"datetime",
						"timezone"
						>>
		end

end
