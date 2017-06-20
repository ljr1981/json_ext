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

	metadata (a_current: ANY): ARRAY [TUPLE [type: STRING]]
		do
			Result := <<
						["text"],
						["text"],
						["text"],
						["text"]
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
