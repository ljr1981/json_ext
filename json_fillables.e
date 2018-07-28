note
	description: "Representation of {JSON_FILLABLES} or arrays with JSON things."

	purpose: "[
		Collection of features to transform JSON_ARRAY items into ARRAYED_LIST items.
		
		Specifically, we've a list of [G]'s in the JSON_ARRAY and want to place them 
		into an ARRAYED_LIST [G].
		]"

	details: "[
		Sometimes we get JSON_ARRAY lists filled with "x" things and we need typical ARRAYED_LIST [G].
		]"

class
	JSON_FILLABLES [G -> detachable ANY]

feature -- JSON Type Fillers

	filled_arrayed_list_of_json_objects (a_json_array: JSON_ARRAY): ARRAYED_LIST [JSON_OBJECT]
			-- Create an ARRAYED_LIST [JSON_OBJECT] from `a_json_array' as JSON_ARRAY list.
			-- Only attached items in the list are moved from the JSON_ARRAY to the ARRAYED_LIST.
		local
			l_item: ANY
		do
			create Result.make (a_json_array.count)
			across
				a_json_array as ic
			loop
				if attached {JSON_OBJECT} ic.item as al_item then
					Result.force (al_item)
				end
			end
		end

feature -- Base Type Fillers

	fill_arrayed_list_of_any_type (a_json_array: JSON_ARRAY; a_creator_agent: FUNCTION [ANY, TUPLE [STRING], attached G]): ARRAYED_LIST [attached G]
		local
			l_item: STRING
			l_result: G
		do
			create Result.make (a_json_array.count)
			across
				a_json_array as ic
			loop
				check as_string: attached {JSON_STRING} ic.item as al_string then
					l_item := al_string.representation.twin
					check leading_double_quote: l_item [1] = '"' end
					l_item.remove_head (1) -- Remove the leading double-quote
					check trailing_double_quote: l_item [l_item.count] = '"' end
					l_item.remove_tail (1) -- Remove the trailing double-quote
					a_creator_agent.call ([l_item])
					check proper_result: attached {G} a_creator_agent.last_result as al_result then
						Result.force (al_result)
					end
				end
			end
		end

	fill_arrayed_list_of_any_detachable_type (a_json_array: JSON_ARRAY; a_creator_agent: FUNCTION [ANY, TUPLE [STRING], G]): ARRAYED_LIST [G]
		local
			l_item: STRING
			l_result: G
		do
			create Result.make (a_json_array.count)
			across
				a_json_array as ic
			loop
				check as_string: attached {JSON_STRING} ic.item as al_string then
					l_item := al_string.representation.twin
					check leading_double_quote: l_item [1] = '"' end
					l_item.remove_head (1) -- Remove the leading double-quote
					check trailing_double_quote: l_item [l_item.count] = '"' end
					l_item.remove_tail (1) -- Remove the trailing double-quote
					a_creator_agent.call ([l_item])
					check proper_result: attached {G} a_creator_agent.last_result as al_result then
						Result.force (al_result)
					end
				end
			end
		end

end
