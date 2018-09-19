note
	testing: "type/manual"

class
	JSON_EXAMPLE_TEST_SET

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

	json_example_test
		note
			detail: "[
			New test routine
			JSON_OBJECT and JSON_ARRAY can have multiple-embedded JSON_VALUE items. 
				Use the notion of "count" in either case
				to determine the scope of what is present in the JSON string. 
				For instance: The example below contains just
				a single Glossary Division with potentially multiple 
				Glossary Entry(ies). However, the JSON could easily present
				multiple Glossary Division(s), each with multiple Glossary 
				Entries. You may or may not know the scope of the
				structure and containership. Moreover, your code might 
				have certain expectations of what is contained, where
				an actual instance of a JSON string might have additional 
				JSON_VALUE bits your code is unaware of. In this case,
				your code might need to be flexible on the count of JSON_VALUEs 
				at any level, using the {JSON_VALUE}.item ("some_name") to
				parse out the particular JSON_VALUE your code specification 
				recognizes.

			Moreover, structures such as the one exemplified below can be
				hidden with an object API. Thus, the example could be coded to
				a {GLOSSARY} object with a `make_from_json (a_json: STRING)',
				which then populates features of {GLOSSARY} with the
				parsed data.

			NOTE: The JSON Parser library does not handle malformed JSON.
				It simply does not parse. For example: In the JSON below, if
				the "glossry" key tag is missing, then the parser will simply
				fail to parse and report: {JSON_PARSER}.is_parsed = False.
				]"
		local
			l_object: detachable JSON_OBJECT
			l_parser: JSON_PARSER
		do
			create l_parser.make_with_string (Json_glossary)
			l_parser.parse_content
			assert ("is_parsed", l_parser.is_parsed)

			l_object := l_parser.parsed_json_object
			check attached_object: attached l_object end

				--| Start with the outside JSON_OBJECT "glossary"
			check attached_glossary: attached {JSON_OBJECT} l_object.item ("glossary") as al_glossary then

					--| There are two elements contained in "glossary": "title" and "GlossDiv"
				assert_equal ("glossary_key_count_is_2", 2, al_glossary.current_keys.count)

					--| Get a JSON_STRING for "title"
				check attached_title: attached {JSON_STRING} al_glossary.item ("title") as al_title then
					assert_strings_equal ("title_is_example_glossary", "example glossary", al_title.item)
				end

					--| Get a JSON_OBJECT for "GlossDiv"
				check attached_glossary_div: attached {JSON_OBJECT} al_glossary.item ("GlossDiv") as al_glossary_div then

						--| "GlossDiv" has two elements: "title" and "GlossList"
					assert_equal ("glossdiv_key_count_is_2", 2, al_glossary_div.current_keys.count)

						--| Get "title"
					check attached_glossdiv_title: attached {JSON_STRING} al_glossary_div.item ("title") as al_glossdiv_title then
						assert_strings_equal ("glossdiv_title_S", "S", al_glossdiv_title.item)
					end

						--| Get "GlossList"
					check attached_glossdiv_list: attached {JSON_OBJECT} al_glossary_div.item ("GlossList") as al_glosslist then

							--| "GlossList" has one element: "GlossEntry"
						assert_equal ("glosslist_count_is_1", 1, al_glosslist.current_keys.count)
						check attached_glossentry: attached {JSON_OBJECT} al_glosslist.item ("GlossEntry") as al_glossentry then

								--| "GlossList" has seven elements: ...
							assert_equal ("glosslist_count_is_7", 8, al_glossentry.current_keys.count)
							check attached_entry_id: attached {JSON_STRING} al_glossentry.item ("ID") as al_entry then
								assert_strings_equal ("entry_id_SGML", "SGML", al_entry.item)
							end
							check attached_entry_sortas: attached {JSON_STRING} al_glossentry.item ("SortAs") as al_entry then
								assert_strings_equal ("entry_id_sortas", "SGML", al_entry.item)
							end
							check attached_entry_price: attached {JSON_NUMBER} al_glossentry.item ("Price") as al_entry then
								assert_strings_equal ("entry_id_price", "0.01", al_entry.item)
							end
							check attached_entry_glossterm: attached {JSON_STRING} al_glossentry.item ("GlossTerm") as al_entry then
								assert_strings_equal ("entry_id_glossterm", "Standard Generalized Markup Language", al_entry.item)
							end
							check attached_entry_acronym: attached {JSON_STRING} al_glossentry.item ("Acronym") as al_entry then
								assert_strings_equal ("entry_id_acronym", "SGML", al_entry.item)
							end
							check attached_entry_abbrev: attached {JSON_STRING} al_glossentry.item ("Abbrev") as al_entry then
								assert_strings_equal ("entry_id_abbrev", "ISO 8879:1986", al_entry.item)
							end
							check attached_entry_glossdef: attached {JSON_OBJECT} al_glossentry.item ("GlossDef") as al_glossdef then

									--| "GlossList" has seven elements: ...
								assert_equal ("glossdef_count_is_2", 2, al_glossdef.current_keys.count)
								check attached_para: attached {JSON_STRING} al_glossdef.item ("para") as al_para then
									assert_strings_equal ("para_def", "A meta-markup language, used to create markup languages such as DocBook.", al_para.item)
								end
								check attached_seealso: attached {JSON_ARRAY} al_glossdef.item ("GlossSeeAlso") as al_seealso then
										--| See Also array has 2 elements
									assert_equal ("see_also_count_is_2", 2, al_seealso.count)
										--| Arrays are checked by way of the `{JSON_ARRAY}.i_th(x).representation' feature call
									assert_strings_equal ("see_also_GML", "%"GML%"", al_seealso.i_th (1).representation)
									assert_strings_equal ("see_also_XML", "%"XML%"", al_seealso.i_th (2).representation)
								end
							end
							check attached_entry_glosssee: attached {JSON_STRING} al_glossentry.item ("GlossSee") as al_glosssee then
								assert_strings_equal ("gloss_see_markup", "markup", al_glosssee.item)
							end
						end
					end
				end
			end
		end

feature {NONE} -- Implementation: Constants

	Json_glossary: STRING
			-- JSON Glossary example text.
		note
			description: "[
				See EIS (below) for a quick explanation of how JSON is structured 
				as a collection of objects, arrays, strings, numbers, etc.
				]"
			EIS: "name=json_org_example", "src=http://json.org/example.html"
			EIS: "name=json_org_description", "src=http://json.org"
		once
			Result := json_glossary_string
		end

	json_glossary_string: STRING = "[
{
    "glossary": {
        "title": "example glossary",
		"GlossDiv": {
            "title": "S",
			"GlossList": {
                "GlossEntry": {
                    "ID": "SGML",
                    "Price":0.01,
					"SortAs": "SGML",
					"GlossTerm": "Standard Generalized Markup Language",
					"Acronym": "SGML",
					"Abbrev": "ISO 8879:1986",
					"GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
						"GlossSeeAlso": ["GML", "XML"]
                    },
					"GlossSee": "markup"
                }
            }
        }
    }
}
	]"

end


