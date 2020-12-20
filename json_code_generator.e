note
	description: "Facilities that generate possible `make_from_json' and other code."
	purpose: "[
		Without experience, one may wonder what {JSON_DESERIALIZABLE} functions to use in a
		class inheriting from {JSE_AWARE} or {JSON_DESERIALIZABLE}. This class helps offer a
		guide and answers of where to begin (leaving you to figure out precise details).
		Therefore, the code "generated" by the features of this class are on suggestions and
		may not work in your particular case. However, they could be close enough to point
		you in the right direction.
		
		The heart of the matter (so far) is converting JSON-strings --> Eiffel-objects. So, this
		code will provide those types of suggestions.
		]"
	how_it_works: "[
		There are two functions below (so far): `generated_make_from_json_code' and `generated_conversion_code'.
		The first one is responsible for building out an entire `make_from_json' code suggestion. The second
		one is responsible for producing each suggested line of conversion code (e.g. JSON --> Eiffel)
		
		The `generated_conversion_code' is responsible fo each Eiffel attribute needing to be 
		parse-and-converted. See the feature itself (below) for more information.
		]"
	warning: "[
		See the `generated_conversion_code' for warnings about its use.
		]"


class
	JSON_CODE_GENERATOR

feature -- Basic Operations

	generated_make_from_json_code (a_object: JSE_AWARE): STRING
			-- Generate possible `make_from_json' code for `a_object'
		local
			l_reflector: INTERNAL
		do
			create l_reflector
			Result := "check attached json_string_to_json_object (a_json) as al_object then%N"
			across
				a_object.convertible_features (a_object) as ic_field_name
			loop
				across
					(1 |..| l_reflector.field_count (a_object)) as ic_rfield
				loop
					if l_reflector.field_name (ic_rfield.item, a_object).same_string (ic_field_name.item) and then
						attached generated_conversion_code (l_reflector.field (ic_rfield.item, a_object), ic_field_name.item) as al_code
					then
						if not al_code.is_empty and not al_code.has ('%N') then
							Result.append_string_general ("%Tset_" + ic_field_name.item + " (" + al_code + ")%N")
						elseif not al_code.is_empty and al_code.has ('%N') then
							Result.append_string_general (al_code + "%N")
						else
							Result.append_string_general ("%T-- set_" + ic_field_name.item + " (" + al_code + ")%N")
						end
					end
				end
			end
			Result.append_string_general ("end%N")
		end

	generated_conversion_code (a_field: detachable separate ANY; a_key: STRING): detachable STRING
			-- Convert `a_field' with field-name of `a_key' into `make_from_json' line-of-code.
		note
			basic_design: "[
				Each basic input data-type of `a_field' is tested for with an attachment-test
				(e.g. "if attached ______ as _____ then ... end"). The {INTEGER} data-type is
				a great example because it starts generically by testing for {INTEGER} and
				then progressively tests for variants of {INTEGER} (e.g. 8/16/32/64).
				]"
			warning: "[
				Not every input data-type has been coded-out (e.g. `a_field'). These will be
				filled in as-needed (or as-requested).
				]"
		local
			l_gen_type: separate TYPE [detachable separate ANY]
		do
			if attached a_field as al_field then
				l_gen_type := al_field.generating_type
			end
			create Result.make_empty
			if attached {JSON_SERIALIZABLE} a_field as al_convertible then
				-- Result := al_convertible.eiffel_object_to_json_object (al_convertible)
			elseif attached {ARRAY [detachable ANY]} a_field as al_array then
				-- Result := eiffel_array_to_json_array (al_array)
			elseif attached {ARRAYED_LIST [detachable ANY]} a_field as al_array then
				if attached {ARRAYED_LIST [STRING]} a_field then
					Result := "fill_arrayed_list_of_strings (%"" + a_key + "%", al_object)"
				end
			elseif attached {FW_MIXED_NUMBER} a_field as al_mixed_number then
				-- Result := eiffel_mixed_number_json_array (a_key, al_mixed_number)
			elseif attached {TUPLE [detachable ANY]} a_field as al_tuple then
				Result := tuple_code_pattern.twin
				Result.replace_substring_all ("<<FIELD_NAME>>", a_key)
			elseif attached {DECIMAL} a_field as al_decimal then
				-- Result := eiffel_decimal_to_json_string (a_key, al_decimal)
			elseif attached {DATE} a_field as al_date then
				-- Result := eiffel_date_to_json_string (a_key, al_date)
			elseif attached {TIME} a_field as al_time then
				-- Result := eiffel_time_to_json_string (a_key, al_time)
			elseif attached {DATE_TIME} a_field as al_date_time then
				-- Result := eiffel_date_time_to_json_string (a_key, al_date_time)
			elseif attached {FW_MIXED_NUMBER} a_field as al_mixed_number then
				-- Result := eiffel_mixed_number_json_array (a_key, al_mixed_number)
			elseif attached {DECIMAL} a_field as al_decimal then
				-- Result := eiffel_decimal_to_json_string (a_key, al_decimal)
			elseif attached {HASH_TABLE [detachable ANY, HASHABLE]} a_field as al_hash_table then
				-- Result := eiffel_hash_table_to_json_object (a_key, al_hash_table)
			elseif attached {INTEGER} a_field as al_integer_field then
				if attached {INTEGER_8} al_integer_field then
					Result := "json_object_to_integer_8 (%"" + a_key + "%", al_object)"
				elseif attached {INTEGER_16} al_integer_field then
					Result := "json_object_to_integer_16 (%"" + a_key + "%", al_object)"
				elseif attached {INTEGER_32} al_integer_field then
					Result := "json_object_to_integer_32 (%"" + a_key + "%", al_object)"
				elseif attached {INTEGER_64} al_integer_field then
					Result := "json_object_to_integer_64 (%"" + a_key + "%", al_object)"
				end
			elseif attached {ANY} a_field as al_field then
				-- Result := eiffel_any_to_json_value (a_key, al_field)
			else
				Result := "no_conversion"
			end
		end

	tuple_code_pattern: STRING = "[
	if attached {like <<FIELD_NAME>>} json_array_to_eiffel_tuple (json_object_to_tuple_as_json_array ("<<FIELD_NAME>>", al_object)) as al_tuple then
		set_<<FIELD_NAME>> (al_tuple)
	end

]"

end
