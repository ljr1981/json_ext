note
	description: "A {MOCK_DATA_OBJECT} designed for parsing a specific JSON data set."
	explanation: "[

		]"
	EIS: "name=Eiffel Users > JSON to HTML table", "src=https://groups.google.com/forum/#!topic/eiffel-users/gzP60ZLNcZc"

class
	MOCK_DATA_OBJECT

inherit
	JSON_DESERIALIZABLE

create
	make_from_json_for_table_index,
	make_from_json

feature {NONE} -- Initialization

	make_from_json_for_table_index (a_json: STRING; a_table_index: INTEGER)
		require
			positive_index: a_table_index > 0
		do
			table_index := a_table_index
			make_from_json (a_json)
		end

	table_index: INTEGER

	make_from_json (a_json: STRING)
			-- <Precursor>
		note
			details: "[
				1. Each "check" could also be an "if-then-elseif" structure. We use a check here
					because we have a specific expectation (i.e. exact specification) of how the
					data will be structured. By using a "check", we are asking that the data hold
					perfectly to the specification and that checking to ensure it does comes
					before this routine is executed.
				2. The "check" items are performed from outside to inside. For example:
					a. The outermost {JSON_VALUE} is a {JSON_OBJECT}, so the first "check" ensures
						that the first parsed item is that outer object.
					b. Within outer object is the "results" array (i.e. [ ... ]), which logically means
						that we might have more than one set of results (e.g. column-names-and-data objects).
						Stated another way--we may have more than one table in our results. However,
						we PRESUME (ASSUME) (in the code) that our data will have but one result item!
				3. There is a `make_from_json' (this routine), which makes the presumption of 1 table-of-data in the JSON data.
					There is also a `make_from_json_for_table_index', which takes an index number value
					representing precisely which table it expects to find. Note that the table must be there
					in the array, otherwise the code will fail on the check. So, again--it is the responsiblity
					of the caller to ensure the table data is there in the array.
				]"
			sample_JSON_data: "[
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

		require else
			is_true: True
		local
			l_data: ARRAYED_LIST [STRING]
			l_table_index: INTEGER
		do
			if table_index > 0 then
				l_table_index := table_index
			else
				l_table_index := 1
			end
			check has_root_object: attached {JSON_OBJECT} json_string_to_json_object (a_json) as al_object then
				check has_results_array: attached {JSON_ARRAY} al_object.item (create {JSON_STRING}.make_from_string_general ("results")) as al_results_array then
					check has_table_element: al_results_array.count >= l_table_index end
					check has_results_object: attached {JSON_OBJECT} al_results_array [l_table_index] as al_results_object then -- See 2(b) in notes above.
						-- Columns --> column_names array ...
						check has_columns_array: attached {JSON_ARRAY} al_results_object.item (create {JSON_STRING}.make_from_string_general ("columns")) as al_columns_array then
							across
								al_columns_array as ic
							loop
								check has_column_name: attached {JSON_STRING} ic.item as al_column_name then
									column_names.force (al_column_name.item)
								end -- has_column_name
							end -- al_columns_array
						end -- has_columns_array
						-- Data --> column_data array ...
						check has_data_array: attached {JSON_ARRAY} al_results_object.item (create {JSON_STRING}.make_from_string_general ("data")) as al_data_array then
							across
								al_data_array as ic
							loop
								check has_row_object: attached {JSON_OBJECT} ic.item as al_row_object then
									check has_columns_data: attached {JSON_ARRAY} al_row_object.item (create {JSON_STRING}.make_from_string_general ("row")) as al_columns_data then
										create l_data.make (al_columns_data.count)
										across
											al_columns_data as ic_column_data
										loop
											if attached {JSON_STRING} ic_column_data.item as al_string then
												l_data.force (al_string.item)
											else
												l_data.force (ic_column_data.item.representation)
											end
										end
										column_data.force (l_data)
									end -- has_columns_data
								end -- has_row_object
							end -- across al_data_array
						end -- has_data_array
					end -- has_results_object
				end -- has_results_array
			end -- has_root_object
		end

feature -- Access

	column_names: ARRAYED_LIST [STRING]
			-- Extracted column names (e.g. "columns":["summary","UID"])
		attribute
			create Result.make (100)
		end

	column_data: ARRAYED_LIST [ARRAYED_LIST [STRING]]
			-- First by rows, then each column within each row.
			-- All data-types are represented and stored as {STRING}s.
		attribute
			create Result.make (100)
		end

feature {NONE} -- Implementation

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			-- <Precursor>
		do
			Result := <<
						>>
		end

	convertible_features (a_object: ANY): ARRAY [STRING]
			-- <Precursor>
		once ("object")
			Result := <<
						>>
		end

end
