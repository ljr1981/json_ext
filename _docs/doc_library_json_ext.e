note
	description: "[
		Documentation for JSON Extension library.
		]"
	before_you_begin: "[
		(1) Place this class into Clickable-view (Control + Shift + C)
		(2) Pick-and-drop class and feature references to the:
			(2a) Class tool: Choose Clickable-view to see class notes documentation.
			(2b) Feature tool: 
		]"
	synopsis: "[
		This library extends the JSON library (see libraries in Groups tool) by
		providing a simpler API for declaring typical Eiffel classes as being
		{JSON_SERIALIZABLE} (able to be serialized to JSON as a string) and 
		{JSON_DESERIALIZABLE} (able to be deserialized from JSON as a string).
		
		STEPS
		=====
		
		Step 1
		------
		Classes that you want to serialize and deserialize to and from JSON
		simply need to inherit from {JSON_SERIALIZABLE} to be serializable
		and inherit from {JSON_DESERIALIZABLE} to be deserializable.
		
		Step 2
		------
		Once the classes inherit (as stated above), the last step is to
		declare which features (Basic Types or Reference Types) are participating
		in the JSON serialize/deserialize process through the facilities of
		the primary classes mentioned above. One makes this declaration by
		setting references to the participating features into an array called
		{JSON_TRANSFORMABLE}.convertible_features
		
		Example: {MOCK_PERSON} found in the test-target under "mocks" cluster.
		]"

deferred class
	DOC_LIBRARY_JSON_EXT

feature {NONE} -- Primary classes

	serializer: detachable JSON_SERIALIZABLE
			-- Primary class responsible for serialization of Eiffel class objects.

	deserializer: detachable JSON_DESERIALIZABLE
			-- Primary class responsible for deserialization of Eiffel class objects.

end
