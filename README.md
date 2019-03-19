# elixir-identicon

1. Take a pull of the code.

2. Go through this to install :egd which is present in erlang.
You have to run `mix local.rebar --force` to install rebar, then close the terminal and open again.
and run `mix deps.get`

3. Now run `iex -S mix` which will open the shell for elixir.

4. Run `Identicon.main("username")

5. A png file will be created with the name username.png which will be your identicon.
