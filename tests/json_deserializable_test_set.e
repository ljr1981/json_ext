note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date: 2014-06-03 15:05:12 -0400 (Tue, 03 Jun 2014) $"
	revision: "$Revision: 9293 $"
	testing: "type/manual"

class
	JSON_DESERIALIZABLE_TEST_SET

inherit
	TEST_SET_HELPER
		redefine
			on_prepare
		end

	JSON_SERIALIZABLE
		undefine
			default_create
		end

	JSON_DESERIALIZABLE
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			Precursor
			make_from_json (current_representation)
		end

	initialize_from_json_object (a_object: JSON_OBJECT)
			-- <Precursor>
		do
			elmer_net_wowth := json_object_to_decimal_attached ("elmer_net_wowth", a_object)
			name := json_object_to_attached_string ("name", a_object)
--			check valid_void_name: json_object_to_json_string_representation ("void_name", l_object) = Void end
			void_name := json_object_to_detachable_string ("void_name", a_object)
			immutable_name := json_object_to_attached_immutable_string ("immutable_name", a_object)
			hunts_wabbits := json_object_to_boolean ("hunts_wabbits", a_object)
			has_beard := json_object_to_boolean ("has_beard", a_object)
			first_appeawance_date := json_object_to_date ("first_appearance_date", a_object)
			first_appeawance_date_time := json_object_to_date_time ("first_appearance_date_time", a_object)
			first_appeawance_runtime := json_object_to_time ("first_appearance_runtime", a_object)
			number_of_actors_pwaying_elmer := json_object_to_decimal_attached ("number_actors_playing_elmer", a_object)
--			check valid_void_decimal: json_object_to_decimal ("void_decimal", l_object) = Void end
			void_decimal := json_object_to_decimal ("void_decimal", a_object)
			number_of_years_pwayed_by_bryan := json_object_to_integer ("number_of_years_played_by_bryan", a_object)
			year_bwyan_started := json_object_to_natural_16 ("year_bryan_started", a_object)
			years_pwayed_by_mel_bwanc := json_object_to_natural_32 ("years_pwayed_by_mel_blanc", a_object)
			years_pwayed_by_fwank_welker := json_object_to_natural_64 ("years_pwayed_by_frank_welker", a_object)
			nemesis_count := json_object_to_natural_8 ("nemesis_count", a_object)
			height_to_headwidth_watio := json_object_to_real_64 ("height_to_headwidth_ratio", a_object)
			elmers_fwiends := set_elmers_friends (json_object_to_tuple_as_json_array ("elmers_friends", a_object))
		end

feature -- Test routines

	test_deserialization
			-- Test deserialization of `current_representation'
		do
			assert_strings_equal ("elmer_net_wowth", "0.01", elmer_net_wowth.out)
			assert_equals ("name_is_elmer_fudd", "Elmer Fudd", name)
			assert_strings_equal ("has_immutable_name", "my_immutable_name", immutable_name)
			assert ("hunts_wabbits", hunts_wabbits)
			assert ("has_no_beard", not has_beard)
			assert_equals ("first_appearance_date", "11/29/1937", first_appeawance_date.out)
			assert_equals ("first_appearance_date_time", "11/29/1937 7:15:15.000 AM", first_appeawance_date_time.out)
			assert_equals ("first_appearance_runtime", "12:07:00.000 AM", first_appeawance_runtime.out)
			assert_equals ("seven_actors_as_fudd", "[0,7,0]", number_of_actors_pwaying_elmer.out_tuple)
			check attached_void_decimal: attached void_decimal as al_decimal then
				assert_equals ("void_decimal", "[0,sNaN]", al_decimal.out_tuple)
			end
			assert_equals ("years_by_bryan", 19, number_of_years_pwayed_by_bryan)
			assert_equals ("year_bryan_started", (1939).to_natural_16, year_bwyan_started)
			assert_equals ("years_pwayed_by_mel_blanc", (15).to_natural_32, years_pwayed_by_mel_bwanc)
			assert_equals ("years_pwayed_by_frank_welker", (1).to_natural_64, years_pwayed_by_fwank_welker)
			assert_equals ("nemesis_count", (1).to_natural_8, nemesis_count)
			assert_equals ("height_to_headwidth_ratio", 0.36619718309859162, height_to_headwidth_watio)
			assert_equals ("elmers_friends_bugs", "Bugs Bunny", elmers_fwiends.item (1))
			assert_equals ("elmers_friends_daffy", "Daffy Duck", elmers_fwiends.item (2))
		end

feature {NONE} -- Implementation: Access

	elmer_net_wowth: DECIMAL
			-- Test a penny price on a deciaml
		attribute
			create Result.make_zero
		end

	name: STRING
			-- Test string feature for Current.

	void_name: detachable STRING
			-- Test a Void string to ensure it does not come back as just "null".
		attribute
			Result := "null"
		end

	immutable_name: IMMUTABLE_STRING_32
			-- Test of an immutable string Vs. a mutable STRING_Nn.

	hunts_wabbits: BOOLEAN
			-- Test boolean for Current.

	has_beard: BOOLEAN
			-- Test boolean for Current.

	first_appeawance_date: DATE
			-- Test date for Current.

	first_appeawance_date_time: DATE_TIME
			-- Test date-time for Current.

	first_appeawance_runtime: TIME
			-- Test time for Current.

	number_of_actors_pwaying_elmer: DECIMAL
			-- Test decimal for Current.

	void_decimal: detachable DECIMAL
			-- Test void decimal for Current.
			-- The initial value is attached, and creation is responsible for voiding it.
		attribute
			create Result.make_from_string ("0.00")
		end

	number_of_years_pwayed_by_bryan: INTEGER
			-- Test integer for Current.

	year_bwyan_started: NATURAL_16
			-- Test natural 16 for Current.

	years_pwayed_by_mel_bwanc: NATURAL_32
			-- Test natural 32 for Current.

	years_pwayed_by_fwank_welker: NATURAL_64
			-- Test natural 64 for Current.

	nemesis_count: NATURAL_8
			-- Test natural 8 for Current.

	height_to_headwidth_watio: REAL_64
			-- Test real_64 for Current.
			--| Ratio of Elmer Fudd's height to width of his head (52 / 142)

	elmers_fwiends: ARRAY [STRING_8]
			-- Test array for Current.

	set_elmers_friends (a_json_array: JSON_ARRAY): ARRAY [STRING_8]
			-- Sets `elmers_fwiends' from  `a_json_array'.
		local
			i: INTEGER
		do
			create Result.make_empty
			from i := 1
			until i > a_json_array.count
			loop
				Result.force (remove_double_quotes (a_json_array.i_th (i).representation.twin), i)
				i := i + 1
			end
		end

	convertible_features (a_object: ANY): ARRAY [STRING]
			-- <Precursor>
		once ("object")
			Result := <<"elmer_net_wowth",
						"name",
						"void_name",
						"hunts_wabbits",
						"has_beard",
						"first_appeawance_date",
						"first_appeawance_date_time",
						"first_appeawance_runtime",
						"number_of_actors_pwaying_elmer",
						"void_decimal",
						"number_of_years_pwayed_by_bryan",
						"year_bwyan_started",
						"years_pwayed_by_mel_bwanc",
						"years_pwayed_by_fwank_welker",
						"nemesis_count",
						"height_to_headwidth_watio",
						"elmers_fwiends">>
		end

feature {NONE} -- Implementation

	creation_objects_anchor: TUPLE [name: like name]
			-- <Precursor>
		do
			create Result
		end

feature {NONE} -- Implementation: Representation Constants

	current_representation: STRING
		once
			Result := "{"
			Result.append (elmer_net_wowth_representation)
			Result.append (",")
			Result.append (name_representation)
			Result.append (",")
			Result.append (void_name_representation)
			Result.append (",")
			Result.append (immutable_name_representation)
			Result.append (",")
			Result.append (hunts_wabbits_representation)
			Result.append (",")
			Result.append (has_beard_representation)
			Result.append (",")
			Result.append (first_appeawance_date_representation)
			Result.append (",")
			Result.append (first_appeawance_date_time_representation)
			Result.append (",")
			Result.append (first_appeawance_runtime_representation)
			Result.append (",")
			Result.append (number_actors_pwaying_elmer_representation)
			Result.append (",")
			Result.append (Void_decimal_representation)
			Result.append (",")
			Result.append (number_of_years_pwayed_by_bwyan_representation)
			Result.append (",")
			Result.append (year_bwyan_started_representation)
			Result.append (",")
			Result.append (nemesis_count_representation)
			Result.append (",")
			Result.append (height_to_headwidth_watio_representation)
			Result.append (",")
			Result.append (elmers_friends_representation)
			Result.append (",")
			Result.append (years_pwayed_by_mel_bwanc_representation)
			Result.append (",")
			Result.append (years_pwayed_by_fwank_welker_representation)
			Result.append ("}")
		end

	elmer_net_wowth_representation: STRING = "%"elmer_net_wowth%":%"[0,1,-2]%""

	name_representation: STRING = "%"name%":%"Elmer Fudd%""

	void_name_representation: STRING = "%"void_name%":%"null%""

	immutable_name_representation: STRING = "%"immutable_name%":%"my_immutable_name%""

	hunts_wabbits_representation: STRING = "%"hunts_wabbits%":true"

	has_beard_representation: STRING = "%"has_beard%":false"

	first_appeawance_date_representation: STRING = "%"first_appearance_date%":%"1937/11/29%""

	first_appeawance_date_time_representation: STRING = "%"first_appearance_date_time%":%"1937/11/29/7/15/15%""

	first_appeawance_runtime_representation: STRING = "%"first_appearance_runtime%":%"0/7/0%""

	number_actors_pwaying_elmer_representation: STRING = "%"number_actors_playing_elmer%":%"[0,7,0]%""

	void_decimal_representation: STRING = "%"void_decimal%":%"null%""

	number_of_years_pwayed_by_bwyan_representation: STRING = "%"number_of_years_played_by_bryan%":19"

	year_bwyan_started_representation: STRING = "%"year_bryan_started%":1939"

	years_pwayed_by_mel_bwanc_representation: STRING = "%"years_pwayed_by_mel_blanc%":15"

	years_pwayed_by_fwank_welker_representation: STRING = "%"years_pwayed_by_frank_welker%":1"

	nemesis_count_representation: STRING = "%"nemesis_count%":1"

	height_to_headwidth_watio_representation: STRING = "%"height_to_headwidth_ratio%":0.36619718309859162"

	elmers_friends_representation: STRING = "%"elmers_friends%":[%"Bugs Bunny%",%"Daffy Duck%"]"

	alternate_representation: STRING = "{%"glossary%": {%"title%": %"example glossary%",%"GlossDiv%": {%"title%": %"S%",%"GlossList%": {%"GlossEntry%": {%"ID%": %"SGML%",%"SortAs%": %"SGML%",%"GlossTerm%": %"Standard Generalized Markup Language%",%"Acronym%": %"SGML%",%"Abbrev%": %"ISO 8879:1986%",%"GlossDef%": {%"para%": %"A meta-markup language, used to create markup languages such as DocBook.%",%"GlossSeeAlso%": [%"GML%", %"XML%"]},%"GlossSee%": %"markup%"}}}}}"

;end


