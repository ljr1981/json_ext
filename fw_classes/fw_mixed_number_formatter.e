note
	description: "Helper class that formats MIXED_NUMBER outputs."

deferred class
	FW_MIXED_NUMBER_FORMATTER

inherit
	ANY
		undefine
			default_create, copy
		end

feature -- Formatting

	string_format_for_mixed_number_without_zero_fraction (a_mixed_number: FW_MIXED_NUMBER): IMMUTABLE_STRING_32
			-- Returns a standard formatted string for `a_mixed_number'.
		local
			l_result: STRING_32
		do
			create l_result.make (1)
			if a_mixed_number.is_negative then
				l_result.append_character ('-')
			end
			if a_mixed_number.numerator = 0 then
				l_result.append_string_general (a_mixed_number.whole_part.out)
			else
				l_result.append_string_general (a_mixed_number.out)
			end
			create Result.make_from_string_32 (l_result)
		end

end
