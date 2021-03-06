Feature: Built-in version option flag declaration

  Scenario: supports built-in version option flag
    Given the following baf program:
      """
      Class.new Baf::CLI do
        def setup
          flag_version '0.13.42'
        end
      end.run ARGV
      """
    When I successfully run the program with option -V
    Then the output must contain exactly "0.13.42\n"

  Scenario: describes the flag in usage options summary after a separator
    Given the following baf program:
      """
      Class.new Baf::CLI do
        def setup
          flag_verbose
          flag_version '0.13.42'
        end
      end.run ARGV
      """
    When I successfully run the program with option -h
    Then the output must match /verbose mode\n\n.*-V.+--version.+print version/m
    And the output must match /--help.*--version/m

  Scenario: prevents running the program when -V option is given
    Given the following baf program:
      """
      Class.new Baf::CLI do
        def setup
          flag_version '0.13.42'
        end

        def run
          fail
        end
      end.run ARGV
      """
    When I run the program with option -V
    Then the exit status must be 0
