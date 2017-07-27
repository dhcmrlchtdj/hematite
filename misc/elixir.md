# elixir

---

https://elixir-lang.org/getting-started/introduction.html
https://coggle.it/diagram/WXlW7IJGFQAB28Ro

---

elixir
	basic
		type
			number
				integer / `1`
				float / `1.0`
			atom / `:atom`
				boolean / `true / :true`
					`and / or / not`
					`&& / || / !`
				`nil / :nil`
				`:"Elixir.String"`
			reference
			function
				anonymous function
					`(fn x, y -> x + y end).(1, 2)`
				`is_atom(true)`
			port
			pid
			tuple / `{1,2,3}`
			map
				`%{:a => 1, 2 => :b} / %{a: 1, b: 2}`
				`map.a / map[:a] / map[2]`
				`%{map | 2 => "two"} / %{map | a: 3}`
				struct
					structs are extensions built on top of maps that provide compile-time checks and default values
					`defmodule User do defstruct name: "John", age: 27 end`
					`%User{} / %User{name: "Meg"}`
			list
				`[1,2,3] / [1 | [2 | [3 | []]]]`
				a list of printable ASCII numbers will be printed as a char list
				char list / `'hello'`
					a list of code points
				keyword list
					`[{:a, 1}, {:b, 2}]`
					`[a: 1, b: 2] / list[:a]`
					`if(false, [{:do, true}, {:else, false}])`
					`if(false, [  do: true,    else: false])`
					`if false,    do: true,    else: false`
			bitstring
				a bunch of bits
				binary / `<<1,2,3>>`
					a binary is a bitstring where the number of bits is divisible by 8
					string / `"string"`
						a string is a UTF-8 encoded binary
		`number < atom < reference < function < port < pid < tuple < map < list < bitstring`
		`case / cond / if / do,end / raise`
		pattern match
			`[hd | tl] = [1,2,3]`
			`[hd | _] = [1,2,3]`
			`^x = 1`
		`defmodule / def / defp`
			capturing
				`&(&1 + 1) / fn x -> x + 1 end`
				`&List.flatten(&1, &2) / fn(list, tail) -> List.flatten(list, tail) end`
			default arguments
				`def join(a, b \\ nil, sep \\ " ")`
		`Enum / Stream`
		process
			`spawn / spawn_link / self / send / receive / inspect`
			`receive do ... after 0 -> "timeout after 0 ms`
			when a message is sent to a process, the message is stored in the process mailbox
			receive will block current process, send will not
			a failure in a process will never crash or corrupt the state of another process
			expect supervisors to properly restart systems
			`Task`
		macro
			`alias Foo.Bar`
				`alias Foo.Bar, as: Bar`
				alias the module so it can be called as Bar instead of Foo.Bar
			`require Foo`
				require the module in order to use its macros
			`import Foo`
				`import List, only: [duplicate: 2]`
				`import Integer, only: :functions`
				import functions from Foo so they can be called without the `Foo.` prefix
			`use Foo`
				Invokes the custom code defined in Foo as an extension point
		protocol
			`defprotocol Size do def size(data) end`
			`defimpl Size, for: BitString do def size(string), do: byte_size(string) end`
			`Size.size("foo")`
			structs require their own protocol implementation
			`defimpl Size, for: Any do def size(_), do: 0 end`
			`defprotocol Size do @fallback_to_any true; def size(data) end`
			`@derive` vs `@fallback_to_any true`
		comprehension
			`for n <- [1, 2, 3, 4], do: n * n`
			`for n <- 1..4, do: n * n`
			`for {:good, n} <- values, do: n * n`
			`for n <- 0..5, multiple_of_3?.(n), do: n * n`
			discard all elements for which the filter expression returns false or nil
			allow multiple generators and filters to be given
			`for i <- [:a, :b, :c], j <- [1, 2], do:  {i, j}`
			`for <<r::8, g::8, b::8 <- pixels>>, do: {r, g, b}`
			`for {key, val} <- %{"a" => 1, "b" => 2}, into: %{}, do: {key, val * val}`
		sigil
			regex
				`~r/foo|bar/i`
				`"foo" =~ ~r/foo|bar/i`
				`sigil_r(<<"foo|bar">>, 'i')`
			string / `~s(hello)`
			char list / `~c(hello)`
			word list / `~w(hello world)`
		error
			exception / error
				`raise "oops"`
				`defmodule MyError do defexception message: "default message" end`
				`try do raise "oops" rescue e in RuntimeError -> e end`
				we avoid using try/rescue because we don’t use errors for control flow
			throw
				`try do throw(1) catch x -> x end`
				throw value and catch later
				interfacing with libraries that do not provide a proper API
			exit
				a process can also die by explicitly sending an exit signal
				`spawn_link fn -> exit(1) end`
				`try do exit "exiting" catch :exit, _ -> "hhh" end`
				once an exit signal is received, the supervision strategy kicks in and the supervised process is restarted.
			after
				`try do raise "oops" after IO.puts "cleanup" end`
			else
				`try do 1 rescue _ -> 2 else _ -> 3 end`
		typespec
			`@spec round(number) :: integer`
			`@type number_with_remark :: {number, String.t}`
			dialyzer uses typespecs to perform static analysis of code
		behaviour
			a set of function signatures that a module has to implement
			`@callback parse(String.t) :: any`
			`@behaviour Parser`
