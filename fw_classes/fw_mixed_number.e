note
	description: "Representation of a mixed number."

class
	FW_MIXED_NUMBER

inherit
	NUMERIC
		redefine
			out, is_equal, default_create
		end

	COMPARABLE
		redefine
			out, is_equal, default_create
		end

	HASHABLE
		redefine
			is_hashable, out, is_equal, default_create
		end

	REFACTORING_HELPER
		redefine
			out, is_equal, default_create
		end

create
	make,
	make_from_integer_32,
	make_from_integer_64,
	default_create

convert
	make_from_integer_32 ({INTEGER_32}),
	make_from_integer_64 ({INTEGER_64})

feature {NONE} -- Initialization

	make (a_is_negative: BOOLEAN; a_whole: NATURAL_64; a_numerator, a_denominator: NATURAL_32)
			-- Initialize current with `a_whole' as `whole_part', `a_numerator' as `numerator'
			-- and `a_denominator' as `denominator'.
		require
			positive_denominator: a_denominator > 0
		do
			is_negative := a_is_negative
			whole_part := converted_whole (a_whole, a_numerator, a_denominator)
			numerator := converted_numerator (a_numerator, a_denominator)
			denominator := a_denominator
		ensure
			whole_part_set: whole_part = converted_whole (a_whole, a_numerator, a_denominator)
			numerator_set: numerator = converted_numerator (a_numerator, a_denominator)
			denominator_set: denominator = a_denominator
		end

	make_from_integer_32 (a_value: INTEGER_32)
			-- Initialize current with a zero proper fraction and `a_value' as `whole_part'.
		do
			make_from_integer_64 (a_value.as_integer_64)
		ensure
			a_value_negative_implies_is_negative: a_value < 0 implies is_negative
			whole_part_set: whole_part = a_value.abs.as_natural_64
			numerator_set: numerator = 0
			denominator_set: denominator = 1
		end

	make_from_integer_64 (a_value: INTEGER_64)
			-- Initialize current with a zero proper fraction and `a_value' as `whole_part'.
		do
			default_create
			whole_part := a_value.abs.as_natural_64
			is_negative := a_value < 0
		ensure
			a_value_negative_implies_is_negative: a_value < 0 implies is_negative
			whole_part_set: whole_part = a_value.abs.to_natural_64
			numerator_set: numerator = 0
			denominator_set: denominator = 1
		end

	default_create
			-- Initialize a 0 mixed number.
		do
			denominator := 1
		ensure then
			not_negative: not is_negative
			whole_part_set: whole_part = 0
			numerator_set: numerator = 0
			denominator_set: denominator = 1
		end

	make_from_real (a_value: REAL_64; a_denominator: NATURAL_32)
			-- Initialize current from `a_value' with a base `a_denominator'.
		local
			l_decimal_denominator, l_gcd: NATURAL_32
			l_value: REAL_64
		do
			l_value := ((a_value - a_value.abs) * 10000)
			l_decimal_denominator := l_value.floor.as_natural_32

			l_gcd := gcd (l_decimal_denominator, a_denominator)

			fixme ("To be continued!")
		end

feature -- Access

	is_negative: BOOLEAN
			-- Is Current negative?

	whole_part: NATURAL_64
			-- Whole part of current.

	numerator: NATURAL_32
			-- Numerator of proper fraction part of current.

	denominator: NATURAL_32
			-- Denominator of proper fraction part of current.

	proper_fraction_part: REAL_64
			-- Proper fraction part of current.
		do
			Result := numerator / denominator
		ensure
			no_greater_than_one: Result <= 1.0
		end

	hash_code: INTEGER
			-- Hash code value
		do
			-- Result := (whole_part.hash_code + numerator.hash_code).hash_code
			Result := whole_part.bit_shift_left (10).bit_or (numerator.bit_xor (denominator)).hash_code
		end

	sign: INTEGER
			-- Sign value (0, -1 or 1)
		do
			if is_negative and (whole_part > 0 or numerator > 0) then
				Result := -1
			elseif Current > zero then
				Result := 1
			end
		ensure
			three_way: Result = three_way_comparison (zero)
		end

	one: like Current
			-- Neutral element for "*" and "/"
		do
			create Result.make (False, 1, 0, 1)
		end

	zero: like Current
			-- Neutral element for "+" and "-"
		do
			create Result.default_create
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is `other' greater than current real?
		do
			Result := to_double < other.to_double
		end

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object of the same type
			-- as current object and identical to it?
		do
			Result := to_double = other.to_double
		end

feature -- Status report

	divisible (other: FW_MIXED_NUMBER): BOOLEAN
			-- May current object be divided by `other'?
		do
			Result := not (other.is_equal (zero))
		end

	exponentiable (other: NUMERIC): BOOLEAN
			-- May current object be elevated to the power `other'?
		do
			-- For the first release we won't implement.
		end

	is_hashable: BOOLEAN
			-- May current object be hashed?
		do
			Result := True
		end

	has_same_denominator (other: like Current): BOOLEAN
			-- Does current and other share the same `denominator'?
		do
			Result := denominator = other.denominator
		end

	is_whole_number: BOOLEAN
			-- True if current has no fractional part.
		do
			Result := numerator = 0
		end

	improper_numerator: NATURAL_64
				-- The `numerator' when expressed as an improper fraction
		do
			Result := (whole_part * denominator) + numerator
		end

feature -- Conversion

	to_double: REAL_64
			-- Current seen as a double
		do
			Result := (whole_part + proper_fraction_part)
			if is_negative then
				Result := Result * -1
				--| Can't use feature `sign' because it depends on `is_less'
				--| And `is_less' depends on `to_double'
			end
		end

	converted_whole (a_whole: NATURAL_64; a_numerator: NATURAL_32; a_denominator: NATURAL_32): NATURAL_64
			-- Express `whole_part' of a mixed number with a possibly improper fractional part based on the improper fraction.
		do
			Result := (a_whole + ( a_numerator // a_denominator ))
		end

	converted_numerator (a_numerator: NATURAL_32; a_denominator: NATURAL_32): NATURAL_32
			-- Express `a_numerator' as a conversion of a possibly improper fraction.
		do
			Result := (a_numerator.as_natural_32 \\ a_denominator)
		end

feature -- Basic operations

	abs: like Current
			-- Absolute value
		do
			if is_equal (- zero) then
				Result := zero
			elseif is_less (zero) then
				Result := - Current
			else
				Result := twin
			end
		ensure
			result_exists: Result /= Void
			same_absolute_value: (Result ~ Current) or (Result ~ - Current)
		end

	plus alias "+" (other: like Current): like Current
			-- Sum with `other'
		local
			l_this_numerator, l_new_numerator, l_this_denominator: INTEGER_32
			l_other_numerator, l_other_denominator: INTEGER_32
			l_common_denominator: INTEGER_32
			l_gcd, l_final_denominator, l_final_numerator: NATURAL_32
			l_this_improper_numerator, l_other_improper_numerator: INTEGER_32
		do
			l_this_improper_numerator := improper_numerator.as_integer_32
			l_this_denominator := denominator.as_integer_32
			l_other_improper_numerator := other.improper_numerator.as_integer_32
			l_other_denominator := other.denominator.as_integer_32
			l_common_denominator := l_this_denominator * l_other_denominator
			l_this_numerator := ((l_this_improper_numerator) * l_other_denominator) * sign
			l_other_numerator := ((l_other_improper_numerator) * l_this_denominator) * other.sign
			l_new_numerator := l_this_numerator + l_other_numerator
			l_gcd := gcd (denominator, other.denominator)
			l_final_denominator := l_common_denominator.as_natural_32 // l_gcd
			l_final_numerator := l_new_numerator.abs.as_natural_32 // l_gcd
			create Result.make ((l_new_numerator < 0), 0, l_final_numerator, l_final_denominator)
		end

	minus alias "-" alias "−" (other: like Current): like Current
			-- Result of subtracting `other'
		do
			Result := plus (- other)
		end

	product alias "*" alias "×" (other: like Current): like Current
			-- Product by `other'
		local
			l_new_numerator, l_new_denominator, l_gcd: NATURAL_32
			l_result_negative: BOOLEAN
		do
			l_new_numerator := (improper_numerator * other.improper_numerator).as_natural_32
			l_new_denominator := (denominator * other.denominator).as_natural_32
			l_gcd := gcd (l_new_numerator, l_new_denominator)
			l_new_numerator := l_new_numerator // l_gcd
			l_new_denominator := l_new_denominator // l_gcd
			l_result_negative := not (is_negative = other.is_negative)
			create Result.make (l_result_negative, 0, l_new_numerator, l_new_denominator)
		end

	quotient alias "/" alias "÷" (other: like Current): like Current
			-- Division by `other'
		local
			l_divisor: FW_MIXED_NUMBER
		do
			create l_divisor.make (other.is_negative, 0, other.denominator, other.improper_numerator.as_natural_32)
			Result := product (l_divisor)
		end

	identity alias "+": like Current
			-- Unary plus
		do
			Result := twin
		end

	opposite alias "-" alias "−": like Current
			-- Unary minus
		do
			create Result.make (not is_negative, whole_part, numerator, denominator)
		end

feature -- Output

	out: STRING
			-- Printable representation of real value
		do
			Result := whole_part.out + " " + numerator.out + "/" + denominator.out
		end

feature {ANY} -- Implementation

	lcm (a, b: NATURAL_32): NATURAL_32
			-- Least Common Multiple of `a' and `b'.
		require
			a_positive: a > 0
			b_positive: b > 0
		do
				-- We are using the formula `(a / gcd (a,b)) * b' from
				-- http://en.wikipedia.org/wiki/Least_common_multiple#Computing_the_least_common_multiple
			Result := (a // gcd (a,b)) * b
		end

	gcd (a, b: NATURAL_32): NATURAL_32
			-- Greatest Common Divisor of `a' and `b'.
		require
			a_positive: a > 0
			b_positive: b > 0
		local
			l_a, l_b:  NATURAL_32
		do
				-- We are using the Euclidean Algorithm from
				-- http://en.wikipedia.org/wiki/Euclidean_algorithm
			if a = 0 then
				Result := b
			else
				from
					l_a := a
					l_b := b
				until
					l_b = 0
				loop
					if l_a > l_b then
						l_a := l_a - l_b
					else
						l_b := l_b - l_a
					end
				end
				Result := l_a
			end
		end

invariant
	-- sign_times_abs: (sign * abs) ~ Current
	-- Too expensive for an invariant.
	is_negative_implies_sign_minus_1: is_negative and (whole_part > 0 or numerator > 0) implies sign = -1
	sign_minus_1_implies_is_negative: sign = -1 implies is_negative
	sign_ge_zero_implies_not_is_negative: sign > 0 implies not is_negative
	not_is_negative_implies_sign_ge_zero: not is_negative implies sign >= 0
	proper_fraction: numerator < denominator
	denominator_definition: denominator > 0

end
