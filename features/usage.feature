Feature: Program usage

  Scenario: prints the usage when unknown option switch is given
    Given the following baf program:
      """
      Baf::CLI.run(ARGV)
      """
    When I run the program with option --unkwnown-option
    Then the exit status must be 64
    And the output must contain exactly:
      """
      Usage: baf [options]
      """

  Scenario: prints the usage when -h option switch is given
    Given the following baf program:
      """
      Baf::CLI.run(ARGV)
      """
    When I run the program with option -h
    Then the exit status must be 0
    And the output must contain exactly:
      """
      Usage: baf [options]
      """
