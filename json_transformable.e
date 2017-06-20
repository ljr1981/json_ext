note
	description: "[
		Abstract notion of a JSON_TRANSFORMABLE class.
		
		Transformation will consist of serialization and deserialization, and the features
		of this class will represent common features of both processes.
		]"

deferred class
	JSON_TRANSFORMABLE

feature -- Access

	attribute_value_attached (a_name: STRING; a_object: ANY): ANY
		do
			check attached attribute_value (a_name, a_object) as al_result then Result := al_result end
		end

	attribute_value_string (a_name: STRING; a_object: ANY): STRING
		do
			check attached {STRING} attribute_value_attached (a_name, a_object) as al_result then Result := al_result end
		end

	attribute_value_integer (a_name: STRING; a_object: ANY): INTEGER
		do
			check attached {INTEGER} attribute_value_attached (a_name, a_object) as al_result then Result := al_result end
		end

	attribute_value_real (a_name: STRING; a_object: ANY): REAL
		do
			check attached {REAL} attribute_value_attached (a_name, a_object) as al_result then Result := al_result end
		end

	attribute_value_boolean (a_name: STRING; a_object: ANY): BOOLEAN
		do
			check attached {BOOLEAN} attribute_value_attached (a_name, a_object) as al_result then Result := al_result end
		end

	attribute_value_character (a_name: STRING; a_object: ANY): CHARACTER
		do
			check attached {CHARACTER} attribute_value_attached (a_name, a_object) as al_result then Result := al_result end
		end

	attribute_value_date (a_name: STRING; a_object: ANY): DATE
		do
			check attached {DATE} attribute_value_attached (a_name, a_object) as al_result then Result := al_result end
		end

	attribute_value_time (a_name: STRING; a_object: ANY): TIME
		do
			check attached {TIME} attribute_value_attached (a_name, a_object) as al_result then Result := al_result end
		end

	attribute_value_date_time (a_name: STRING; a_object: ANY): DATE_TIME
		do
			check attached {DATE_TIME} attribute_value_attached (a_name, a_object) as al_result then Result := al_result end
		end

	attribute_value (a_name: STRING; a_object: ANY): detachable ANY
		do
			if attached {FUNCTION [ANY, TUPLE, detachable ANY]} attributes_hash_on_name (a_object).item (a_name) as al_agent then
				al_agent.call ([Void])
				Result := al_agent.last_result
			end
		end

	attributes_hash_on_name (a_object: ANY): HASH_TABLE [FUNCTION [ANY, TUPLE, detachable ANY], STRING]
			-- Iterate over `convertible_features', storing agent-refs to Current attributes.
			-- This facilitates clients being able to extract data from Current in Key:Value pairs
			--	for purposes such as populating tables of items like current; going over objects
			--	and then over attributes.
		local
			i, j, v, l_count: INTEGER
			l_found: BOOLEAN
			l_array: like convertible_features
		once
			l_array := convertible_features (a_object)
			l_count := l_array.count
			create Result.make (l_count)
			from
				i := 1
				v := l_count
			until
				i > l_count
			loop
				l_found := False
				from
					j := 1
				until
					j > reflector.field_count (a_object) or l_found
				loop
					l_found := reflector.field_name (j, a_object).same_string (l_array.item (i))
					if l_found then
						Result.force (agent reflector.field (j, a_object), reflector.field_name (j, a_object))
					end
					j := j + 1
				end
				i := i + 1
				v := v - 1
			variant
				v
			end
		end

feature -- Access

	metadata (a_current: ANY): ARRAY [JSON_METADATA]
		deferred
		ensure
			applied_to_all_convertibles: convertible_features (a_current).count = Result.count
			valid_types: across Result as ic_result some
								across valid_types as ic_types some
									ic_types.item.same_string (ic_result.item.type)
								end
							end
		end

	valid_types: ARRAY [STRING]
		once
			Result := <<"button","checkbox","color","date","datetime-local","email","file","hidden","image","month","number","password","radio","range","reset","search","submit","tel","text","time","url","week">>
		end

	convertible_features (a_current: ANY): ARRAY [STRING]
			-- Features of Current (`a_current') identified to participate in JSON conversion.
		deferred
		ensure
			result_not_empty: not Result.is_empty
			has_all_features: has_all_features (a_current, Result)
		end

feature {NONE} -- Implementation

	reflector: INTERNAL
			-- `reflector' once'd for Current
		once
			create Result
		end

	has_all_features (a_object: ANY; a_array: like convertible_features): BOOLEAN
			-- Does `convertible_features' reflect features of Current (`a_object')?
		local
			i, j: INTEGER
			l_found: BOOLEAN
		do
				--| This is the optimistic view of Result; the pessimistic view is preferred.
			Result := True
			from i := 1
			until i > a_array.count
			loop
				l_found := False
				from j := 1
				until j > reflector.field_count (a_object) or l_found
				loop
					l_found := reflector.field_name (j, a_object).same_string (a_array.item (i))
					j := j + 1
				end
				Result := Result and l_found
				i := i + 1
			end
		end

end
