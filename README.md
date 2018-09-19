# JSON Extension Library
The json_ext library written in Eiffel for Eiffel object serialization and deserialization.

Purpose
=======
Use this library for two purposes: Serialization of Eiffel objects (and object graphs) into well-formed JSON -AND- Deserialization of JSON to Eiffel objects and object graphs.

Video Examples
==============
Example #1: Simple Serialization and Deserialization—we want to see how to take an Eiffel object and serialize it into a JSON string. We then want to take our JSON string and get our Eiffel object back from it by deserializing it.

<a href="http://www.youtube.com/watch?feature=player_embedded&v=G9AiHaYdqzU" target="_blank"><img src="http://img.youtube.com/vi/G9AiHaYdqzU/0.jpg" alt="Examples" width="240" height="180" border="10" /></a>

Example #2: Example of JSON to HTML Conversion—we want to convert a JSON string to a simple HTML table.

<a href="http://www.youtube.com/watch?feature=player_embedded&v=kyw7eFFvIM0" target="_blank"><img src="http://img.youtube.com/vi/kyw7eFFvIM0/0.jpg" alt="JSON-to-HTML" width="240" height="180" border="10" /></a>

Example #3: Recursive Serialization and Deserialization—like the Example #1 (above), but we want to add a layer of recursion—that is—we want JSON_OBJECT things that have subordinate (or contained) JSON_OBJECTs in them. We want the library to smartly recurse our specified object features, detect when it finds an subordinate JSON_OBJECT and serialize it—recursively walking down the object graph.

<a href="http://www.youtube.com/watch?feature=player_embedded&v=_SloGPXGOow" target="_blank"><img src="http://img.youtube.com/vi/_SloGPXGOow/0.jpg" alt="JSON-to-HTML" width="240" height="180" border="10" /></a>

Serialization
=============
Objects that you want to serialize to JSON inherit from **JSON_SERIALIZABLE**. The class has one deferred feature, which you must implement:

  convertible_features (a_current: ANY): ARRAY [STRING]

For example:

	convertible_features (a_object: ANY): ARRAY [STRING]
			-- <Precursor>
		once
			Result := <<"name", "truck_id", "sms_device">>
		end

This ARRAY specifies the features that you want to be serialized to JSON from the existing object at run-time. In this case, the features are (for example) defined as:

	name: STRING
			-- `name' of Current.
		attribute
			create Result.make_empty
		end

	truck_id: detachable STRING
			-- Optional or Assignable `truck' for Current.

	sms_device: detachable STRING

If an object you want to serialize at run-time is `l_my_object` and the local variable is of type **JSON_SERIALIZABLE**, then to get the JSON string representation of `l_my_object` is as simple as: `l_json := l_my_object.out`

Deserialization
===============
The process of setting up for deserialization is more involved.

First--you must inherit from **JSON_DESERIALIZABLE**. When you do, you must define several deferred features:

	convertible_features (a_current: ANY): ARRAY [STRING_8]
	make_from_json (a_json: STRING_8)

For `convertible_features`see **JSON_SERIALIZABLE** (above). If your class is both serializable and deserializable, then you only need provide an implementation for `convertible_features` one time thanks to Multiple Inheritance!

Second--you must implement the `make_from_json` creation procedure. This procedure must perform some basic steps. For example: Let's look at the `make_from_json` for the class having the `name`, `truck_id`, and `sms_device` features (above).

```
	make_from_json (a_json: STRING)
			-- <Precursor>
		require else											-- This must be here because the ancestor is False.
			True												    --	Leaving it False, will cause this to fail.
		local
			l_object: detachable JSON_OBJECT					        -- You must have one of these because ...
			l_any: detachable ANY
		do
			l_object := json_string_to_json_object (a_json)		-- ... the `a_json' STRING is parsed to a JSON_OBJECT.
			check attached_object: attached l_object end		  -- This proves that our JSON parsing was okay.

			name := json_object_to_json_string_representation_attached ("name", l_object)
			truck_id := json_object_to_json_string_representation ("truck_id", l_object)
			sms_device := json_object_to_json_string_representation ("sms_device", l_object)
		end
```

Pay special attention to the `*_attached` feature used for the `name` feature. All of the data-type parsing features generally have an attached and detached version. The detached feature version simply excludes the `_attached` suffix. Therefore, in the example, the `truck_id` and `sms_device` are detached and can be Void. The feature called is coded such that the Result of the feature might be Void. This could mean that the feature is represented in the JSON string, but is set to "null", or it could mean that the feature is not in the JSON string and is (as a consequence) Void. Either way—the Result will be Void. If you expect your JSON to have an attached value (e.g. it is both in the JSON string and is not "null"), then use the `*_attached` version of the call. Otherwise, use the detached version.

NOTE: The line with check attached_object: attached l_object end is there because our code expects the JSON to parse without error. If you are unsure of getting well-formed JSON, which is configured precisely as you expect, then you may want to use an if-then-else-end construct to test for parsing issues and handle them appropriately.

You will find features for many possible standard deserialization of JSON→Eiffel data types. In each case, you need to pass the name of the feature from your `convertible_features` ARRAY (list) along with the `l_object` (e.g. **JSON_OBJECT**, which represents your a_json string as a parsed Eiffel object). For example:

```
JSON → STRING
==============
json_object_to_json_string_representation → detachable STRING
json_object_to_json_string_representation_attached → attached STRING
json_object_to_json_immutable_string_representation → detachable IMMUTABLE_STRING
json_object_to_json_immutable_string_representation_attached → attached IMMUTABLE_STRING
```

The interesting variant on the features above is one that searches through the JSON_OBJECT looking for an attribute at any level in the JSON-object-graph for by name. This is intended to be a "quick-and-dirty" solution and only used on the rarest of occasions. What you will quickly note is that if you have several objects in the JSON with the same attribute name, this will return the first one that it finds. Also, because the Result is attached, your JSON must have the attribute or the code will fail. The variant feature is:

recursive_json_object_to_json_string_representation → attached STRING

```
JSON → BOOLEAN
===============
json_object_to_boolean → BOOLEAN
json_object_to_boolean_attached → attached BOOLEAN
```
```
JSON → INTEGER
================
json_object_to_integer → INTEGER
json_object_to_integer_8 → INTEGER_8
json_object_to_integer_16 → INTEGER_16
json_object_to_integer_32 → INTEGER_32
json_object_to_integer_64 → INTEGER_64
```
*NOTE: The same type of features exist for NATURAL and REAL numbers as well."

There are also features for finding and return **DATE**, **TIME**, and **DATE_TIME** data types, as well as **DECIMAL** and **MIXED_NUMBER** types too.

Finally, you will find a feature that returns a TUPLE from a JSON string, where the TUPLE (in the JSON string) is converted to an ARRAY. There is also a feature for converting JSON array's directly to an Eiffel ARRAY [ANY].

Object Graphs
=============
Many times, you may have Eiffel objects, which reference other subordinate Eiffel objects and you want to store (serialize) and restore (deserialize) them. In either case, the reference feature must be in the `convertible_features` ARRAY. Once there, we can now restore it from a JSON string.

For example: If we have a feature called `requestor: REQUESTOR`, which inherits from **JSON_DESERIALIZABLE**, and the `requestor` is a subordinate child reference, then we want to first extract just the portion of the JSON representing the `requestor` and then hand that JSON string to the `make_from_json` of the **REQUESTOR** class.

We might then write:

```
  local l_key: JSON_STRING
    ...
  create l_key.make_from_string ("requestor")
    ...
  if attached {JSON_OBJECT} json_object_to_json_reference_subobject (l_object, "requestor") as al_object then
    create requestor.make_from_json (al_object.representation)
  end
```

The `json_object_to_json_reference_subject` call attempts to locate the "requestor" subobject reference attribute in the `l_object`. If it finds it, it creates the corresponding **JSON_OBJECT** and returns it as the Result of the call. If we get back an attached object, then we can call the `make_from_json` feature of the REQUESTOR class with the **{JSON_OBJECT}**.`representation` **STRING** Result, which is the JSON string representation of our resulting subordinate **JSON_OBJECT**.

Markdown Reference
==================
[Markdown used for this page](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
