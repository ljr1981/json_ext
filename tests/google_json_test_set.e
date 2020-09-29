note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	GOOGLE_JSON_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	google_json_tests
			-- Test Google Calendar Resource and End-event JSON Serialization and Deserialization
		note
			testing:  "execution/isolated", "execution/serial"
			EIS: "name=Resource representations", "src=https://developers.google.com/calendar/v3/reference/events"
		local
			l_end_event: MOCK_END_EVENT
			l_resource: MOCK_RESOURCE
		do
				-- Create an Event and ensure the correct camel-case on dateTime and timeZone in the JSON output.
			create l_end_event.make_from_json (json_end_event.twin)
			assert_strings_equal ("date", "12/12/2020", l_end_event.date.out)
			assert_strings_equal ("dateTime", "12/12/2020 1:02:03.000 AM", l_end_event.datetime.out)
			assert_strings_equal ("timeZone", "EST", l_end_event.timezone)
			assert_strings_equal ("end_event", json_end_event, l_end_event.json_out)

				-- Create a Resource with the Event and ensure end_event becomes just end in the JSON output.
			create l_resource.make_with_end_event (l_end_event)
			assert_strings_equal ("resource", json_resource, l_resource.json_out)
		end

feature {NONE} -- Implementation: JSON

	json_end_event: STRING = "[
{"date":"2020/12/12","dateTime":"2020/12/12/1/2/3","timeZone":"EST"}
]"

	json_resource: STRING = "[
{"end":{"date":"2020/12/12","dateTime":"2020/12/12/1/2/3","timeZone":"EST"}}
]"

end


