note
	description: "A {MOCK_DATA_OBJECT} designed for parsing a specific JSON data set."
	explanation: "[

		]"
	EIS: "name=Eiffel Users > JSON to HTML table", "src=https://groups.google.com/forum/#!topic/eiffel-users/gzP60ZLNcZc"
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

class
	MOCK_DATA_OBJECT

inherit
	JSON_DESERIALIZABLE

create
	make_from_json

feature {NONE} -- Initialization

	make_from_json (a_json: STRING)
			-- <Precursor>
		require else
			is_true: True
		local
			l_data: ARRAYED_LIST [STRING]
		do
			check has_root_object: attached {JSON_OBJECT} json_string_to_json_object (a_json) as al_object then
				check has_results_array: attached {JSON_ARRAY} al_object.item (create {JSON_STRING}.make_from_string_general ("results")) as al_results_array then
					check has_results_object: attached {JSON_OBJECT} al_results_array [1] as al_results_object then
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
		attribute
			create Result.make (100)
		end

	column_data: ARRAYED_LIST [ARRAYED_LIST [STRING]]
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
