note
	description: "[
					Representation of a Multi-dimensional Array.
					]"

class
	FW_ARRAYN [G -> ANY]

create
	make_n_based,
	make_n_based_filled,
	make_one_based,
	make_one_based_filled

feature {NONE} -- Initialization

	make_one_based_filled (a_bounds_array: ARRAY [INTEGER]; v: G)
			-- Initialize Current as a one-based lower bound on all dimensional vectors
			-- 		and then filled with `v'.
			--| Tested: {ARRAYN_TEST_SET}.test_one_based_filled
		require
			positive_bounds: is_positive_bounds (a_bounds_array)
		do
			make_one_based (a_bounds_array)
			across 1 |..| internal_items.count as ic_index loop
				internal_items.put (v, ic_index.item)
			end
		ensure
			all_filled: across internal_items as ic_items all ic_items.item ~ v end
		end

	make_one_based (a_bounds_array: ARRAY [INTEGER])
			-- Initialize Current as a one-based lower bound on all dimensional vectors.
		require
			positive_bounds: is_positive_bounds (a_bounds_array)
		local
			l_bounds: like bounds
			i: INTEGER
		do
			create l_bounds.make_filled ([0, 0], 1, a_bounds_array.count)
			from i := 1
			until i > a_bounds_array.count
			loop
				l_bounds.put ([1, a_bounds_array [i]], i)
				i := i + 1
			end
			make_n_based (l_bounds)
		end

	make_n_based_filled (a_bounds: like bounds; v: G)
			-- Initialize Current filled with `v' items and with `a_nb' like `bounds'
		require
			is_valid_bounds: is_valid_bounds (a_bounds)
		do
			make_n_based (a_bounds)
			across 1 |..| internal_items.count as ic_index loop
				internal_items.put (v, ic_index.item)
			end
		ensure
			all_filled: across internal_items as ic_items all ic_items.item ~ v end
		end

	make_n_based (a_bounds: like bounds)
			-- Initialize Current with `a_nb' like `bounds'.
			--| Tested: {ARRAYN_TEST_SET}.test_one_based_filled
		require
			is_valid_bounds: is_valid_bounds (a_bounds)
		local
			l_element_count,
			i: INTEGER
		do

			from
				bounds := a_bounds.twin
				i := 1
				l_element_count := 1
			until
				i > a_bounds.count
			loop
				l_element_count := l_element_count * ((a_bounds [i].upper_nb - a_bounds [i].lower_nb) + 1)
				i := i + 1
			end
			create internal_items.make_filled (create {ANY}, 1, l_element_count)
		ensure
			is_empty: is_empty
		end

feature -- Access

	bounds: ARRAY [attached like vector_anchor]
			-- Lower and Upper bounds of Current.
			--| Tested: {ARRAYN_TEST_SET}.test_make_n_based

	dimensions: INTEGER
			-- Number of dimensions in Current `bounds'
		do
			Result := bounds.count
		end

	max_size: INTEGER
			-- Maximum linear size of `internal_items'.
			--| Contract support for revealing maximum linear size for Clients of Current.
		local
			i: INTEGER
		once
			from
				i := 1
				Result := 1
			until
				i > dimensions
			loop
				Result := Result * bounds [i].upper_nb
				i := i + 1
			end
		end

	item (a_vector: ARRAY [INTEGER]): detachable G
			-- Item @ `a_vector'.
		require
			is_valid_vector: is_valid_vector (a_vector)
		do
			if attached {G} internal_items [location (a_vector)] as al_item then
				Result := al_item
			end
		end

	place (a_object: G; a_vector: ARRAY [INTEGER])
			-- Place `a_object' at an empty `a_vector' location.
		require
			empty_location: not attached {G} item (a_vector)
		do
			put (a_object, a_vector)
		ensure
			placed: attached {G} item (a_vector) as al_item and then al_item ~ a_object
		end

	replace (a_object: G; a_vector: ARRAY [INTEGER])
			-- Place or replace `a_object' at `a_vector' location.
		do
			put (a_object, a_vector)
		end

	put (a_object: G; a_vector: ARRAY [INTEGER])
			-- Put `a_object' at `a_vector'
		require
			is_valid_vector: is_valid_vector (a_vector)
		do
			internal_items.put (a_object, location (a_vector))
		ensure
			item_at_location: internal_items [location (a_vector)] ~ a_object
		end

feature -- Basic Operations

	clear_all
			-- Clear all `internal_items' of Current.
		do
			make_n_based (bounds)
		ensure
			is_empty: is_empty
		end

	do_all (a_action: PROCEDURE [ANY, TUPLE [G]])
			-- Apply `a_action' to every item, from first to last.
			-- Semantics not guaranteed if `action' changes the structure;
			-- in such a case, apply iterator to clone of structure instead.
		do
			internal_items.do_all (a_action)
		end

	do_if (a_action: PROCEDURE [ANY, TUPLE [G]]; a_test: FUNCTION [ANY, TUPLE [G], BOOLEAN])
			-- Apply `action' to every item that satisfies `test', from first to last.
			-- Semantics not guaranteed if `action' or `test' changes the structure;
			-- in such a case, apply iterator to clone of structure instead.
		do
			internal_items.do_if (a_action, a_test)
		end

	do_while (a_action: PROCEDURE [ANY, TUPLE [G]]; a_test: FUNCTION [ANY, TUPLE [G], BOOLEAN])
			-- Apply `a_action' to every item that satisfies `a_test' until it is not True.
		local
			l_test_failed: BOOLEAN
		do
			across internal_items as ic_items until l_test_failed loop
				check has_item: attached {G} ic_items.item as al_item then
					a_test.call ([al_item])
					l_test_failed := not a_test.last_result
					if not l_test_failed then
						a_action.call ([al_item])
					end
				end
			end
		end

feature -- Status Report

	frozen is_empty: BOOLEAN
			-- Is Current empty?
			--| Tested: {ARRAYN_TEST_SET}.test_one_based_filled
		do
			Result := across internal_items as ic_items all not attached {G} ic_items.item end
		end

	frozen is_valid_vector (a_vector: ARRAY [INTEGER]): BOOLEAN
			-- Is `a_vector' valid, based on `bounds'?
			--| Tested: {ARRAYN_TEST_SET}.test_make_n_based
		do
			Result := a_vector.count <= dimensions
			Result := Result and across a_vector as ic_vector
									all
										ic_vector.item > 0
									end
			Result := Result and across a_vector as ic_vector
									all
										ic_vector.item >= bounds [ic_vector.cursor_index].lower_nb and
										ic_vector.item <= bounds [ic_vector.cursor_index].upper_nb
									end
			Result := Result and location (a_vector) <= max_size
		end

	frozen is_positive_bounds (a_array: ARRAY [INTEGER]): BOOLEAN
			-- Is `a_array' a valid set of boundaries for `bounds'?
			--| Tested: {ARRAYN_TEST_SET}.test_make_n_based
		do
			Result := across a_array as ic_items all ic_items.item > 0 end
		end

	frozen is_valid_bounds (a_bounds: like bounds): BOOLEAN
			-- Is `a_bounds' valid based on all positive and lower <= upper?
			--| Tested: {ARRAYN_TEST_SET}.test_one_based_filled
		do
			Result := across a_bounds as ic_bounds all
							ic_bounds.item.lower_nb > 0 and
							ic_bounds.item.upper_nb > 0 and
							ic_bounds.item.lower_nb <= ic_bounds.item.upper_nb
						end
		end

feature {TEST_SET_BRIDGE} -- Implementation

	location (a_vector: ARRAY [INTEGER]): INTEGER
			-- The linear location of element in `internal_items' at `a_vector'.
		require
			two_or_more: dimensions > 1
			is_valid_vector: is_valid_vector (a_vector)
		local
			i,
			l_segment_size: INTEGER
		do
			from
				i := 1
				l_segment_size := max_size
			until
				i = dimensions
			loop
				l_segment_size := (l_segment_size / (bounds [i].upper_nb - bounds [i].lower_nb + 1)).truncated_to_integer
				Result := Result + l_segment_size * (a_vector [i] - bounds [i].lower_nb)
				i := i + 1
			end
			Result := Result + a_vector [i]
		end

	internal_items: ARRAY [ANY]
			-- Internal storage of items for Current.

feature {TEST_SET_BRIDGE} -- Constants

	vector_anchor: detachable TUPLE [lower_nb, upper_nb: INTEGER]
			-- Type anchor for vector `bounds'.
			--| Tested: {ARRAYN_TEST_SET}.test_make_n_based

invariant
	valid_bounds: is_valid_bounds (bounds)

note
	design: "[
		An array which can be multi-dimensional.
		]"

end
