defmodule AirbrakeEx.ExceptionParserTest do
  use ExUnit.Case

  test "parses exception" do
    {exception, stacktrace} =
      try do
        IO.inspect("test", [], "")
      rescue
        e -> {e, __STACKTRACE__}
      end

    parsed_exception = AirbrakeEx.ExceptionParser.parse(exception, stacktrace)

    backtrace = parsed_exception[:backtrace]
    message = parsed_exception[:message]
    type = parsed_exception[:type]

    assert type == FunctionClauseError
    assert message == "no function clause matching in IO.inspect/3"

    backtrace_files = Enum.map(backtrace, fn entry -> entry[:file] end)

    assert Enum.member?(backtrace_files, "(Elixir.IO) lib/io.ex")

    assert Enum.member?(
             backtrace_files,
             "(Elixir.AirbrakeEx.ExceptionParserTest) test/airbrake_ex/exception_parser_test.exs"
           )

    assert Enum.member?(backtrace_files, "(timer) timer.erl")
    assert Enum.member?(backtrace_files, "(Elixir.ExUnit.Runner) lib/ex_unit/runner.ex")

    backtrace_functions = Enum.map(backtrace, fn entry -> entry[:function] end)

    assert Enum.member?(backtrace_functions, "inspect(\"test\", [], \"\")")
    assert Enum.member?(backtrace_functions, "test parses exception/1")

    # ExUnit-internal frame names are stable, but their arities shift between
    # Elixir/OTP versions (e.g. exec_test/1 -> /2 on OTP 27). Match by name
    # prefix so the assertion tracks the parser's output, not ExUnit internals.
    assert_frame = fn prefix ->
      assert Enum.any?(backtrace_functions, &String.starts_with?(&1, prefix)),
             "expected a #{prefix}* frame in #{inspect(backtrace_functions)}"
    end

    assert_frame.("exec_test/")
    assert_frame.("tc/")
    assert_frame.("-spawn_test_monitor/4-fun-1-/")
  end
end
