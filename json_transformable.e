note
	description: "[
		Abstract notion of a JSON_TRANSFORMABLE class.
		
		Transformation will consist of serialization and deserialization, and the features
		of this class will represent common features of both processes.
		]"

deferred class
	JSON_TRANSFORMABLE

feature {NONE} -- Implementation: Access

	convertible_features (a_current: ANY): ARRAY [STRING]
			-- Features of Current (`a_current') identified to participate in JSON conversion.
		deferred
		ensure
			result_not_empty: not Result.is_empty
			has_all_features: has_all_features (a_current, Result)
		end

feature {NONE} -- Implementation

	reflector: INTERNAL
			-- ??
		attribute
			create Result
		end

	has_all_features (a_object: ANY; a_array: like convertible_features): BOOLEAN
			-- Does `convertible_features' reflect features of Current (`a_object')?
		local
			l_reflector: INTERNAL
			i, j: INTEGER
			l_found: BOOLEAN
		do
				--| This is the optimistic view of Result; the pessimistic view is preferred.
			Result := True
			create l_reflector
			from i := 1
			until i > a_array.count
			loop
				l_found := False
				from j := 1
				until j > l_reflector.field_count (a_object) or l_found
				loop
					l_found := l_reflector.field_name (j, a_object).same_string (a_array.item (i))
					j := j + 1
				end
				Result := Result and l_found
				i := i + 1
			end
		end

end
