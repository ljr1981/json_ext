class
	ARRAY2_EXT [G]

inherit
	ARRAY2 [G]
		rename
			height as row_count,
			width as column_count
		end

create
	make,
	make_filled

feature -- Access

	row (i: INTEGER): ARRAY [G]
			-- Fetch `row' number `i' from Current.
		require
			valid_i: i >= 1 and then i <= row_count
		do
			create Result.make_empty
			Result.grow (column_count)
			across
				1 |..| column_count as ic_col
			loop
				Result.put (item (i, ic_col.item), ic_col.item)
			end
		ensure
			row_same: across 1 |..| Result.count as ic all
							item (i, ic.item) ~ Result.item (ic.item)
						end
		end

	column (i: INTEGER): ARRAY [G]
			-- Fetch `column' number `i' from Current.
		require
			valid_i: i >= 1 and then i <= column_count
		do
			create Result.make_empty
			Result.grow (row_count)
			across
				1 |..| row_count as ic_row
			loop
				Result.put (item (ic_row.item, i), ic_row.item)
			end
		ensure
			col_same: across 1 |..| Result.count as ic all
							item (ic.item, i) ~ Result.item (ic.item)
						end
		end

feature -- Settings

	put_row (a_row: ARRAY [G]; a_row_index: INTEGER)
			-- Put items in `a_row' into Current on `a_row_index'.
		require
			col_count: a_row.count = column_count
		do
			across
				a_row as ic
			loop
				put (ic.item, a_row_index, ic.cursor_index)
			end
		ensure
			row_put: across 1 |..| a_row.count as ic all
							item (a_row_index, ic.item) ~ a_row.item (ic.item)
						end
		end

	put_row_offset (a_items: ARRAY [G]; a_row_index, a_offset: INTEGER)
			-- Put `a_items' into Current, starting in column number `a_offset'.
		require
			non_empty: not a_items.is_empty
			col_count: a_items.count <= column_count
			valid_offset: a_offset >= 1 and then
							a_offset < column_count and then
							column_count >= (a_offset + a_items.count - 1)
		do
			across
				a_items as ic
			loop
				put (ic.item, a_row_index, ic.cursor_index + a_offset - 1)
			end
		ensure
			row_put: across 1 |..| a_items.count as ic all
							item (a_row_index, ic.item + a_offset - 1) ~ a_items.item (ic.item)
						end
		end

	put_column (a_column: ARRAY [G]; a_column_index: INTEGER)
			-- Put items in `a_column' into Current on `a_column_index'.
		require
			row_count: a_column.count = row_count
		do
			across
				a_column as ic
			loop
				put (ic.item, ic.cursor_index, a_column_index)
			end
		ensure
			col_put: across 1 |..| a_column.count as ic all
							item (ic.item, a_column_index) ~ a_column.item (ic.item)
						end
		end

	put_column_offset (a_items: ARRAY [G]; a_column_index, a_offset: INTEGER)
			-- Put `a_items' into Current, starting in row number `a_offset'.
		require
			non_empty: not a_items.is_empty
			row_count: a_items.count <= row_count
			valid_offset: a_offset >= 1 and then
							a_offset < row_count and then
							row_count >= (a_offset + a_items.count - 1)
		do
			across
				a_items as ic
			loop
				put (ic.item, ic.cursor_index + a_offset - 1, a_column_index)
			end
		ensure
			column_put: across 1 |..| a_items.count as ic all
							item (ic.item + a_offset - 1, a_column_index) ~ a_items.item (ic.item)
						end
		end

end
