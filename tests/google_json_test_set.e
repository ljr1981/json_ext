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
			testing:  "execution/isolated",
						"execution/serial"
			testing: "covers/{MOCK_END_EVENT}.make_from_json",
						"covers/{MOCK_RESOURCE}.make_with_end_event",
						"covers/{MOCK_RESOURCE}.make_from_json"
			testing: "covers/{MOCK_END_EVENT}.Convertible_features",
						"covers/{MOCK_END_EVENT}.date",
						"covers/{MOCK_END_EVENT}.datetime",
						"covers/{MOCK_END_EVENT}.json_out",
						"covers/{MOCK_END_EVENT}.timezone"
			testing: "covers/{MOCK_RESOURCE}.Convertible_features",
						"covers/{MOCK_RESOURCE}.end_event",
						"covers/{MOCK_RESOURCE}.set_end_event",
						"covers/{MOCK_RESOURCE}.json_out"
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
			assert_strings_equal ("resource_from_end_event", json_resource, l_resource.json_out)
			l_resource.set_end_event (l_end_event)
			assert_strings_equal ("resource_from_end_event_2", json_resource, l_resource.json_out)

				-- Create the same Resource, but using JSON and then ensure the json_out matches output.
			create l_resource.make_from_json (json_resource.twin)
			assert_strings_equal ("resource_from_json", json_resource, l_resource.json_out)

				-- Circle back and ensure end event is still what we think.
			l_end_event := l_resource.end_event.twin
			assert_strings_equal ("date", "12/12/2020", l_end_event.date.out)
			assert_strings_equal ("dateTime", "12/12/2020 1:02:03.000 AM", l_end_event.datetime.out)
			assert_strings_equal ("timeZone", "EST", l_end_event.timezone)
			assert_strings_equal ("end_event", json_end_event, l_end_event.json_out)
		end

feature {NONE} -- Implementation: JSON

	json_end_event: STRING = "[
{"date":"2020/12/12","dateTime":"2020/12/12/1/2/3","timeZone":"EST"}
]"

	json_resource: STRING = "[
{"end":{"date":"2020/12/12","dateTime":"2020/12/12/1/2/3","timeZone":"EST"}}
]"

end


