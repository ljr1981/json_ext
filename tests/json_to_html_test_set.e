note
	description: "[
		Tests to show an implementation of JSON data converted to an HTML <table>
	]"
	testing: "type/manual"

class
	JSON_TO_HTML_TEST_SET

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

	json_to_html_conversion
			-- Test of capacity to create HTML from JSON input.
		note
			testing:
				"execution/isolated",
				"execution/serial"
			EIS: "src=https://www.w3schools.com/js/js_json_html.asp"
			EIS: "src=https://www.w3schools.com/js/tryit.asp?filename=tryjson_html_table"
			EIS: "src=https://www.w3schools.com/tags/tag_th.asp"
			EIS: "src=https://www.w3schools.com/tags/tryit.asp?filename=tryhtml_table_test"
		local
			l_mock: MOCK_DATA_OBJECT
			l_table: HTML_TABLE
			l_html: STRING
		do
			create l_mock.make_from_json (json_input_data_1)		-- Parse our JSON input to an object with headers and data

			create l_table											-- Create our HTML <table> tag object
			across l_mock.column_names as ic loop					-- Populate it with <th> "header" items
				l_table.add_content (l_table.new_tr)
				l_table.last_new_tr.add_content (l_table.new_th)
				l_table.last_new_th.set_text_content (ic.item)
			end
			across l_mock.column_data as ic_row loop				-- Populate it with <td> "data" items per each row
				l_table.add_content (l_table.new_tr)
				across ic_row.item as ic_column loop
					l_table.last_new_tr.add_content (l_table.new_td)
					l_table.last_new_td.set_text_content (ic_column.item)
				end
			end

				-- Tests to ensure the output is correct!
			assert_strings_equal ("table_html", html_table_output, l_table.html_out)					-- First an exact expected string test
			assert_strings_equal ("table_html_pretty_to_plain", html_de_prettified, l_table.html_out)	-- Then the de-prettified version test
		end

feature {NONE} -- Data

	json_input_data_1: STRING = "[
{
   "results":[{
      "columns":["summary","UID"],
      "data":[{
         "row":["Summary1",123],
        "meta":[null,null]
     },{
        "row":["Summary 2",124],
        "meta":[null,null]
     },{
       "row":["Summary 3",122],
       "meta":[null,null]
     }]
   }],
     "errors":[]
}
]"

	html_table_output: STRING = "<table><tr><th>summary</th></tr><tr><th>UID</th></tr><tr><td>Summary1</td><td>123</td></tr><tr><td>Summary 2</td><td>124</td></tr><tr><td>Summary 3</td><td>122</td></tr></table>"

	html_de_prettified: STRING
		once
			Result := html_table_output_prettified.twin
			Result.replace_substring_all ("%T", "")
			Result.replace_substring_all ("%R", "")
			Result.replace_substring_all ("%N", "")
		end

	html_table_output_prettified: STRING = "[
<table>
	<tr>
		<th>summary</th>
	</tr>
	<tr>
		<th>UID</th>
	</tr>
	<tr>
		<td>Summary1</td>
		<td>123</td>
	</tr>
	<tr>
		<td>Summary 2</td>
		<td>124</td>
	</tr>
	<tr>
		<td>Summary 3</td>
		<td>122</td>
	</tr>
</table>
]"

end


