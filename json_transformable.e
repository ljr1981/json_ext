note
	description: "[
		Abstract notion of a JSON_TRANSFORMABLE class.
		
		Transformation will consist of serialization and deserialization, and the features
		of this class will represent common features of both processes.
		]"
	date: "$Date: 2014-03-06 11:17:16 -0500 (Thu, 06 Mar 2014) $"
	revision: "$Revision: 8796 $"

deferred class
	JSON_TRANSFORMABLE

feature {NONE} -- Implementation: Access

	convertible_features (a_current: ANY): ARRAY [STRING]
			-- Features of Current (`a_current') identified as participating in JSON conversion.
		deferred
		ensure
			result_not_empty: not Result.is_empty
			has_all_features: has_all_features (a_current, Result)
		end

feature {NONE} -- Implementation

	reflector: INTERNAL
			-- Reflection resource for Current.
		once ("object")
			create Result
		end

	has_all_features (a_object: ANY; a_convertible_features: like convertible_features): BOOLEAN
			-- Does `a_convertible_features' reflect features of Current `a_object'?
		local
			i, j: INTEGER
			l_found: BOOLEAN
		do
			Result := across a_convertible_features as ic_features all
							across 1 |..| reflector.field_count (a_object) as ic some
								reflector.field_name (ic.item, a_object).same_string (ic_features.item)
							end
						end
		end

end
