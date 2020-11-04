note
	description: "Mock PERSON for Serialization testing only."

class
	MOCK_BUGS

inherit
	JSON_SERIALIZABLE

feature -- Attributes

	name: STRING
			-- The `name' of Current {PERSON}.
		attribute
			create Result.make_empty
		end

	age: INTEGER
			-- The `age' of Current {PERSON}.

	date_of_birth: DATE
			-- The `date_of_birth' of Current {PERSON}.
		attribute
			create Result.make_now
		end

feature -- Setters

	set_name (s: STRING)
			--
		do
			name := s
		end

	set_age (i: INTEGER)
			--
		do
			age := i
		end

	set_date_of_birth (d: DATE)
			--
		do
			date_of_birth := d
		end

	set_date_of_birth_from_string (s: STRING)
			-- Sets `date_of_birth' based on `s'.
			-- Follows spec code: `date_time_spec'
		local
			l_date: DATE
		do
			create l_date.make_from_string_default (s)
			create l_date.make_from_string (s, date_time_spec)
			set_date_of_birth (l_date)
		end

feature {NONE} -- Constants

	date_time_spec: STRING
			-- Date-time (parsing) "code" specification.
		note
			EIS: "src=https://www.eiffel.org/doc/solutions/DATE_TIME_to_STRING_Conversion"
		once
			Result := "[0]mm/[0]dd/yyyy hh12:mi:ss.ff3 am"
		end

feature {NONE} -- Implementation

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			-- <Precursor>
		do
			Result := <<
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default
						>>
		end

	convertible_features (a_current: ANY): ARRAY [STRING]
			-- <Precursor>
		do
			Result := <<
					"name",
					"age",
					"date_of_birth"
					>>
		end

	convertible_features_tuple: TUPLE [name_item, age_item, dob_item: STRING]
			--
		do
			Result := [convertible_features (Current) [1], convertible_features (Current) [2], convertible_features (Current) [3]]
		end

end
