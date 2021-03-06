class
	MOCK_OBJECT

inherit
	JSON_SERIALIZABLE
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			my_string.do_nothing
			my_integer := 9_999
			my_real := 9.999
			my_boolean := True
		end

feature -- Access

	my_string: STRING
		attribute
			Result := "some_string"
		end

	my_integer: INTEGER

	my_real: REAL

	my_boolean: BOOLEAN

feature -- Access: Convertibles

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
		do
			Result := <<
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default
						>>
		end

	convertible_features (a_current: ANY): ARRAY [STRING]
		do
			Result := <<
					"my_string",
					"my_integer",
					"my_real",
					"my_boolean"
					>>
		end

end
