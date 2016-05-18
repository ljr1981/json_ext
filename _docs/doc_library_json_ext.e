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
		
		{JSON_SERIALIZABLE}
		===================
		To make a class (object) serializable (from Object -> JSON), you will
		need to provide an implementation of `convertible_features':
		
		feature {NONE} -- Implementation: Mock Features

			first_name,
			last_name: STRING

		feature {NONE} -- Implementation

			convertible_features (a_object: ANY): ARRAY [STRING]
					-- <Precursor>
				once
					Result := <<"first_name", "last_name">>
				end

		Each feature of your class that you want to have serialized, must be
		included in the `convertible_features' array. Note that you do NOT
		need to specify any data types. The types will be determined through
		introspection by way of the {INTERNAL} class.

		{JSON_DESERIALIZABLE}
		=====================
		Deserialization is the process of turning JSON text back into an
		Eiffel object. This requires providing an implementation for the
		`make_from_json' feature, after inheriting from {JSON_DESERIALIZABLE}.
		
		The basic feature looks like this:
		
		make_from_json (a_json: STRING)
				-- <Precursor>
			require else											<-- This must be here because the ancestor is False.
				True													Leaving it False, will cause this to fail.
			local
				l_object: detachable JSON_OBJECT					<-- You must have one of these because ...
				l_any: detachable ANY
			do
				l_object := json_string_to_json_object (a_json)		<-- ... the JSON string is parsed to a JSON_OBJECT.
				check attached_object: attached l_object end		<-- This proves that our JSON parsing was okay.
				
					-- {STRING}s
				name := json_object_to_json_string_representation_attached ("name", l_object)
				void_name := json_object_to_json_string_representation ("voidName", l_object)
				immutable_name := json_object_to_json_immutable_string_representation_attached ("immutableName", l_object)
				
					-- {BOOLEAN}
				is_alive := json_object_to_boolean ("isAlive", l_object)
				
					-- {DATE}, {TIME}, {DATE_TIME}
				birth_date := json_object_to_date ("birthDate", l_object)
				current_date_time := json_object_to_date_time ("currentDateTime", l_object)
				current_time := json_object_to_time ("currentTime", l_object)

					-- {DECIMAL}
				net_income := json_object_to_decimal_attached ("dollarAmount", l_object)
				other_income := json_object_to_decimal ("optionalAmount", l_object)

					-- {NUMERIC} (integers, reals, naturals)
				my_int := json_object_to_integer ("myInt", l_object)
				my_int08 := json_object_to_integer_8 ("myInt8", l_object)
				my_int16 := json_object_to_integer_16 ("myInt16", l_object)
				my_int32 := json_object_to_integer_32 ("myInt32", l_object)
				my_int32_recursive := recursive_json_object_to_integer_32 ("myInt32_recursive", l_object)
				my_int64 := json_object_to_integer_64 ("myInt64", l_object)

				my_nat08 := json_object_to_natural_8 ("myNat16", l_object)
				my_nat16 := json_object_to_natural_16 ("myNat16", l_object)
				my_nat32 := json_object_to_natural_32 ("myNat16", l_object)
				my_nat64 := json_object_to_natural_64 ("myNat16", l_object)

				my_real32 := json_object_to_real_32 ("myReal32", l_object)
				my_real64 := json_object_to_real_64 ("myReal64", l_object)

				my_mixed := json_string_to_mixed_number ("myMixed", l_object) <-- {FW_MIXED_NUMBER}

					-- {ARRAY}
				my_list := fill_my_list (json_object_to_tuple_as_json_array ("myList", l_object))
			end

		Other features in the same class for array processing will be (based on the above):

		my_list: ARRAY [STRING_8]
				-- Test array for Current.

		fill_my_list (a_json_array: JSON_ARRAY): ARRAY [STRING_8]
				-- Sets `my_list' from  `a_json_array'.
			local
				i: INTEGER
			do
				create Result.make_empty
				from i := 1
				until i > a_json_array.count
				loop
					Result.force (strip_json_quotes (a_json_array.i_th (i).representation.twin), i)
					i := i + 1
				end
			end

		]"

deferred class
	DOC_LIBRARY_JSON_EXT

feature {NONE} -- Primary classes

	serializer: detachable JSON_SERIALIZABLE
			-- Primary class responsible for serialization of Eiffel class objects.

	deserializer: detachable JSON_DESERIALIZABLE
			-- Primary class responsible for deserialization of Eiffel class objects.

end
