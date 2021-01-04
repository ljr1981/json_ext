note
	description: "[
		Abstract notion of a fully serializable and deserializable object.
		]"
	typical_deferred_initialization_code: "[
		COPY-AND-USE the code below to quickly

feature {NONE} -- Initialization (JSON)

	make_from_json (a_json: STRING)
			--<Precursor>
		require else
			True
		do
			check attached json_string_to_json_object (a_json) as al_object then
				-- conversions of items in al_object --> Eiffel feature objects
				-- see {JSON_CODE_GENERATOR} for more (use TEST_SET to generate)
			end
		end

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			--<Precursor>
		do
			Result := {ARRAY [JSON_METADATA]} <<>> -- populate with "create {JSON_METADATA}.make_text_default"
		end

	convertible_features (a_current: ANY): ARRAY [STRING]
			--<Precursor>
		do
			Result := {ARRAY [STRING]} <<>> -- populate with "my_feature_name"
		end

feature -- Status Report

	has_json_input_error: BOOLEAN

]"


deferred class
	JSE_AWARE

inherit
	JSON_DESERIALIZABLE

	JSON_SERIALIZABLE

	JSON_CODE_GENERATOR

note
	purpose: "[
		When you want your class (object) to be both serializable and deserializable,
		then inherit from this class. Doing so will mean that you have to "decorate"
		your class with some of the inherited features from the inherit-clause above.
		Just follow the Eiffel-compiler bouncing ball together with example code from
		the test target of this library (e.g. {EXAMPLES_TEST_SET}).
		]"

end
