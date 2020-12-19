note
	description: "[
		Abstract notion of a fully serializable and deserializable object.
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
