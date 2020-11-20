class
	JSE_HASH_HANDLER [G -> detachable ANY, K -> HASHABLE]

feature -- Operations

	fill_from_hash (a_hash: detachable HASH_TABLE [detachable ANY, HASHABLE]): HASH_TABLE [G, K]
			-- `fill_from_hash' into Result with incoming `a_hash'
		note
			question: "Why is this needed?"
			explanation: "[
				The serialization and deserialization of HASH_TABLEs is designed to accomodate
				ANY type of value (including NULL) with any HASHABLE key. However, target hashes
				will most likely be something other than ANY and HASHABLE. In this example,we have
				used STRING for value and INTEGER_64 for the key. So, we receive an [ANY, HASHABLE]
				argument that we must iterate and validate as [STRING, INTEGER_64].
				]"
		do
			if attached a_hash then
				across
					a_hash as ic
				from
					create Result.make (a_hash.count)
				loop
					if
						attached {G} ic.item as al_value and then
						attached {K} ic.key as al_key
					then
						Result.force (al_value, al_key)
						check Result.same_keys (al_key, al_key) end
					end
				end
			else
				create Result.make (0)
			end
		ensure
			same_count: attached a_hash as al_hash implies Result.count = al_hash.count
		end

end
