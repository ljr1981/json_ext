note
	testing: "type/manual"

class
	JSON_DESERIALIZABLE_TEST_SET

inherit
	TEST_SET_SUPPORT
		redefine
			on_prepare
		end

	JSE_AWARE
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

	make_from_json (a_json: STRING)
			-- <Precursor>
		require else
			True
		local
			l_object: detachable JSON_OBJECT
			l_any: detachable ANY
		do
			l_object := json_string_to_json_object (a_json)
			check attached_object: attached l_object as al_object then
				elmer_net_wowth := json_object_to_decimal_attached ("elmer_net_wowth", al_object)
				name := json_object_to_json_string_representation_attached ("name", al_object)

				l_any := json_object_to_json_string_representation ("void_name", al_object)
				check valid_void_name: not attached l_any end

				void_name := json_object_to_json_string_representation ("void_name", al_object)
				immutable_name := json_object_to_json_immutable_string_representation_attached ("immutable_name", al_object)
				hunts_wabbits := json_object_to_boolean ("hunts_wabbits", al_object)
				has_beard := json_object_to_boolean ("has_beard", al_object)
				first_appeawance_date := json_object_to_date_attached ("first_appearance_date", al_object)
				first_appeawance_date_time := json_object_to_date_time_attached ("first_appearance_date_time", al_object)
				first_appeawance_runtime := json_object_to_time ("first_appearance_runtime", al_object)
				number_of_actors_pwaying_elmer := json_object_to_decimal_attached ("number_actors_playing_elmer", al_object)
				check valid_void_decimal: json_object_to_decimal ("void_decimal", al_object) = Void end
				void_decimal := json_object_to_decimal ("void_decimal", al_object)
				number_of_years_pwayed_by_bryan := json_object_to_integer ("number_of_years_played_by_bryan", al_object)
				year_bwyan_started := json_object_to_natural_16 ("year_bryan_started", al_object)
				years_pwayed_by_mel_bwanc := json_object_to_natural_32 ("years_pwayed_by_mel_blanc", al_object)
				years_pwayed_by_fwank_welker := json_object_to_natural_64 ("years_pwayed_by_frank_welker", al_object)
				nemesis_count := json_object_to_natural_8 ("nemesis_count", al_object)
				height_to_headwidth_watio := json_object_to_real_64 ("height_to_headwidth_ratio", al_object)
				elmers_fwiends := set_elmers_friends (json_object_to_tuple_as_json_array ("elmers_friends", al_object))
				elmers_things := fill_elmers_things (json_object_to_tuple_as_json_array ("elmers_things", al_object))
			end
		end

feature -- Test routines

	test_deserialization
			-- Test deserialization of `current_representation'
		do
			assert_strings_equal ("elmer_net_wowth", "0.01", elmer_net_wowth.out)
			assert_equal ("name_is_elmer_fudd", "Elmer Fudd", name)
			assert_strings_equal ("has_immutable_name", "my_immutable_name", immutable_name)
			assert ("hunts_wabbits", hunts_wabbits)
			assert ("has_no_beard", not has_beard)
			assert_equal ("first_appearance_date", "11/29/1937", first_appeawance_date.out)
			assert_equal ("first_appearance_date_time", "11/29/1937 7:15:15.000 AM", first_appeawance_date_time.out)
			assert_equal ("first_appearance_runtime", "12:07:00.000 AM", first_appeawance_runtime.out)
			assert_equal ("seven_actors_as_fudd", "[0,7,0]", number_of_actors_pwaying_elmer.out_tuple)
			assert_equal ("years_by_bryan", 19, number_of_years_pwayed_by_bryan)
			assert_equal ("year_bryan_started", (1939).to_natural_16, year_bwyan_started)
			assert_equal ("years_pwayed_by_mel_blanc", (15).to_natural_32, years_pwayed_by_mel_bwanc)
			assert_equal ("years_pwayed_by_frank_welker", (1).to_natural_64, years_pwayed_by_fwank_welker)
			assert_equal ("nemesis_count", (1).to_natural_8, nemesis_count)
			assert_equal ("height_to_headwidth_ratio", 0.36619718309859162, height_to_headwidth_watio)
			assert_equal ("elmers_friends_bugs", "Bugs Bunny", elmers_fwiends.item (1))
			assert_equal ("elmers_friends_daffy", "Daffy Duck", elmers_fwiends.item (2))
			assert_integers_equal ("one_thing", 1, elmers_things.count)
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

	void_decimal: detachable DECIMAL

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

	elmers_things: ARRAY [STRING_8]
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
				Result.force (strip_json_quotes (a_json_array.i_th (i).representation.twin), i)
				i := i + 1
			end
		end

	fill_elmers_things (a_json_array: JSON_ARRAY): ARRAY [STRING_8]
		local
			i: INTEGER_32
		do
			create Result.make_empty
			from
				i := 1
			until
				i > a_json_array.count
			loop
				Result.force (strip_json_quotes (a_json_array.i_th (i).representation.twin), i)
				i := i + 1
			end
		end

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
		do
			Result := <<
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default
						>>
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
			Result.append (",")
			Result.append ("%"elmers_things%":%"thing_1%"")
			Result.append ("}")
		end

	elmer_net_wowth_representation: STRING = "%"elmer_net_wowth%":%"[0,1,-2]%""
			-- Representation.

	name_representation: STRING = "%"name%":%"Elmer Fudd%""
			-- Representation.

	void_name_representation: STRING = "%"void_name%":null"
			-- Representation.

	immutable_name_representation: STRING = "%"immutable_name%":%"my_immutable_name%""
			-- Representation.

	hunts_wabbits_representation: STRING = "%"hunts_wabbits%":true"
			-- Representation.

	has_beard_representation: STRING = "%"has_beard%":false"
			-- Representation.

	first_appeawance_date_representation: STRING = "%"first_appearance_date%":%"1937/11/29%""
			-- Representation.

	first_appeawance_date_time_representation: STRING = "%"first_appearance_date_time%":%"1937/11/29/7/15/15%""
			-- Representation.

	first_appeawance_runtime_representation: STRING = "%"first_appearance_runtime%":%"0/7/0%""
			-- Representation.

	number_actors_pwaying_elmer_representation: STRING = "%"number_actors_playing_elmer%":%"[0,7,0]%""
			-- Representation.

	void_decimal_representation: STRING = "%"void_decimal%":null"
			-- Representation.

	number_of_years_pwayed_by_bwyan_representation: STRING = "%"number_of_years_played_by_bryan%":19"
			-- Representation.

	year_bwyan_started_representation: STRING = "%"year_bryan_started%":1939"
			-- Representation.

	years_pwayed_by_mel_bwanc_representation: STRING = "%"years_pwayed_by_mel_blanc%":15"
			-- Representation.

	years_pwayed_by_fwank_welker_representation: STRING = "%"years_pwayed_by_frank_welker%":1"
			-- Representation.

	nemesis_count_representation: STRING = "%"nemesis_count%":1"
			-- Representation.

	height_to_headwidth_watio_representation: STRING = "%"height_to_headwidth_ratio%":0.36619718309859162"
			-- Representation.

	elmers_friends_representation: STRING = "%"elmers_friends%":[%"Bugs Bunny%",%"Daffy Duck%"]"
			-- Representation.

	alternate_representation: STRING = "{%"glossary%": {%"title%": %"example glossary%",%"GlossDiv%": {%"title%": %"S%",%"GlossList%": {%"GlossEntry%": {%"ID%": %"SGML%",%"SortAs%": %"SGML%",%"GlossTerm%": %"Standard Generalized Markup Language%",%"Acronym%": %"SGML%",%"Abbrev%": %"ISO 8879:1986%",%"GlossDef%": {%"para%": %"A meta-markup language, used to create markup languages such as DocBook.%",%"GlossSeeAlso%": [%"GML%", %"XML%"]},%"GlossSee%": %"markup%"}}}}}"
			-- Representation.

end


