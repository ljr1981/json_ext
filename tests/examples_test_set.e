note
	description: "[
		Library Examples
	]"
	testing: "type/manual"
	EIS: "name=example_video", "src=https://youtu.be/G9AiHaYdqzU"

class
	EXAMPLES_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end


feature -- Example routines

	simple_serialization_only_example
			-- Example show a simple object being serialzed to
			-- JSON and then deserialized back to object.
		do
			assert_strings_equal ("bugs_bunny_serialized_to_JSON", bugs_bunny_json, bugs_bunny.json_out)
		end

	simple_deserialization_example
			-- Example showing a simple object being serialized and then deserialized.
		local
			l_elmer: MOCK_PERSON_FOR_BOTH_SERIALIZATION_AND_DESERIALIZATION
		do
				-- Serialization
			assert_strings_equal ("elmer_fudd_serialized_to_JSON", elmer_fudd_json, elmer_fudd.json_out)
				-- Deserialization
			create l_elmer.make_from_json (elmer_fudd_json)
			assert_strings_equal ("name", "Elmer Fudd", l_elmer.name)
			assert_integers_equal ("age", 81, l_elmer.age)
			assert_strings_equal ("dob", "01/01/1937", l_elmer.date_of_birth.out)
		end

	simple_recurive_example
			-- Simple recursive example.
		note
			description: "[
				Create a parent class which has a list of people, where each person
				object is JSON serializable and deserializable.
				]"
		local
			l_people: MOCK_PEOPLE_FOR_BOTH_SERIALIZATION_AND_DESERIALIZATION
		do
				-- Serialization of complex (recursive) object.
			assert_strings_equal ("people_serializaed", people_json, people.json_out)
				-- Deserialization ...
			create l_people.make_from_json (people_json)
			assert_integers_equal ("people_count_2", 2, l_people.people.count)
				-- Person 1
			assert_strings_equal ("elmer_name", elmer_fudd.name, 				l_people.people [1].name)
			assert_integers_equal ("elmer_age", elmer_fudd.age,					l_people.people [1].age)
			assert_strings_equal ("elmer_dob", 	elmer_fudd.date_of_birth.out, 	l_people.people [1].date_of_birth.out)
				-- Person 2
			assert_strings_equal ("porky_name", "Porky Pig", 	l_people.people [2].name)
			assert_integers_equal ("porky_age", 83, 			l_people.people [2].age)
			assert_strings_equal ("porky_dob", 	"03/02/1935", 	l_people.people [2].date_of_birth.out)
		end

feature {NONE} -- Objects

	bugs_bunny: MOCK_PERSON_FOR_SERIALIZATION_ONLY
			-- A mock `bugs_bunny' "PERSON" for use in testing.
			-- Uses the class set up just for serialization to JSON only.
		note
			EIS: "name=bugsy_birthday", "src=https://en.wikipedia.org/wiki/Bugs_Bunny"
		once
			create Result
			Result.set_name ("Bugs Bunny")
			Result.set_date_of_birth (create {DATE}.make (1938, 4, 30))
			Result.set_age (2018 - Result.date_of_birth.year)
		end

	elmer_fudd: MOCK_PERSON_FOR_BOTH_SERIALIZATION_AND_DESERIALIZATION
			--
		note
			EIS: "name=bugsy_birthday", "src=https://en.wikipedia.org/wiki/Elmer_Fudd"
		once
			create Result
			Result.set_name ("Elmer Fudd")
			Result.set_date_of_birth (create {DATE}.make (1937, 1, 1))
			Result.set_age (2018 - Result.date_of_birth.year)
		end

	porky_pig: MOCK_PERSON_FOR_BOTH_SERIALIZATION_AND_DESERIALIZATION
			--
		note
			EIS: "name=bugsy_birthday", "src=https://en.wikipedia.org/wiki/Elmer_Fudd"
		once
			create Result
			Result.set_name ("Porky Pig")
			Result.set_date_of_birth (create {DATE}.make (1935, 3, 2))
			Result.set_age (2018 - Result.date_of_birth.year)
		end

	people: MOCK_PEOPLE_FOR_BOTH_SERIALIZATION_AND_DESERIALIZATION
		note

		once
			create Result
			Result.people.force (elmer_fudd)
			Result.people.force (porky_pig)
		end

feature {NONE} -- JSON Outputs

	bugs_bunny_json: STRING = "[
{"name":"Bugs Bunny","date_of_birth":"1938/4/30","age":80}
]"

	elmer_fudd_json: STRING = "[
{"name":"Elmer Fudd","date_of_birth":"1937/1/1","age":81}
]"

	people_json: STRING = "[
{"people":[{"name":"Elmer Fudd","date_of_birth":"1937/1/1","age":81},{"name":"Porky Pig","date_of_birth":"1935/3/2","age":83}]}
]"

end


