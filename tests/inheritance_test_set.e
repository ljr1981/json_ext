note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	INHERITANCE_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	inheritance_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_mock: MOCK_DESCENDANT
		do
			create l_mock.make_from_json (json_string)
			assert_strings_equal ("ancestor", "fred", l_mock.ancestor_name)
			assert_strings_equal ("json", json_string, l_mock.representation_from_current (l_mock))
			assert_strings_equal ("json_out", json_string, l_mock.json_out)
		end

feature {NONE} -- Constants

	json_string: STRING = "[
{"ancestor_name":"fred","descendant_name":"pebbles"}
]"

feature -- Test routines

	array2_ext_test
		local
			l_array: ARRAY2_EXT [INTEGER]
		do
			create l_array.make_filled (0, 3, 4)
			l_array.put_row (row_1, 1)
			l_array.put_row (row_2, 2)
			l_array.put_row (row_3, 3)
			assert_integers_equal ("row_3_col_4", 4_000, l_array.item (3, 4)) -- Ensure on `put_row' now handles this!

			assert_arrays_equal ("row_1", row_1, l_array.row (1))
			assert_arrays_equal ("row_2", row_2, l_array.row (2))
			assert_arrays_equal ("row_3", row_3, l_array.row (3))

			assert_arrays_equal ("col_1", col_1, l_array.column (1))
			assert_arrays_equal ("col_2", col_2, l_array.column (2))
			assert_arrays_equal ("col_3", col_3, l_array.column (3))
			assert_arrays_equal ("col_4", col_4, l_array.column (4))

			l_array.put_row_offset (offset_2, 2, 2) -- put `offset_2' in row-2, starting in col-2
			assert_arrays_equal ("offset_2_result", offset_2_result, l_array.row (2))
		end

feature {NONE} -- Constants

	row_1: ARRAY [INTEGER]
			-- Row data
		once Result := <<10, 20, 30, 40>> end

	row_2: ARRAY [INTEGER]
			-- Row data
		once Result := <<100, 200, 300, 400>> end

	row_3: ARRAY [INTEGER]
			-- Row data
		once Result := <<1_000, 2_000, 3_000, 4_000>> end

	col_1: ARRAY [INTEGER]
			-- Column data
		once Result := <<10, 100, 1_000>> end

	col_2: ARRAY [INTEGER]
			-- Column data
		once Result := <<20, 200, 2_000>> end

	col_3: ARRAY [INTEGER]
			-- Column data
		once Result := <<30, 300, 3_000>> end

	col_4: ARRAY [INTEGER]
			-- Column data
		once Result := <<40, 400, 4_000>> end

	offset_2: ARRAY [INTEGER]
			-- Offset data
		once Result := <<-200, -300>> end

	offset_2_result: ARRAY [INTEGER]
			-- Offset data
		once Result := <<100, -200, -300, 400>> end

end


