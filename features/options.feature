Feature: Options declaration

  Scenario: supports simple option flag
    Given the following baf program:
      """
      Class.new(Baf::CLI) do
        flag :f, :foo
        flag :b, :bar

        def run
          puts env.foo?
          puts env.bar?
        end
      end.run(ARGV)
      """
    When I run the program with option -f
    Then the output must contain exactly "true\nfalse\n"

  Scenario: supports option with argument
    Given the following baf program:
      """
      Class.new(Baf::CLI) do
        option :f, :foo, 'VALUE', 'set foo to VALUE'

        def run
          puts env.foo
        end
      end.run(ARGV)
      """
    When I run the program with option -f bar
    Then the output must contain exactly "bar\n"

  Scenario: supports built-in verbose option flag
    Given the following baf program:
      """
      Class.new(Baf::CLI) do
        flag_verbose

        def run
          puts env.verbose?
        end
      end.run(ARGV)
      """
    When I run the program with option -v
    Then the output must contain exactly "true\n"
