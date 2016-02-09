module Baf
  class CLI
    ArgumentError = Class.new(ArgumentError)

    EX_USAGE    = 64
    EX_SOFTWARE = 70

    class << self
      def flag *args, registrant: OptionRegistrant
        registrant.register_flag env, option_parser, *args
      end

      def option *args, registrant: OptionRegistrant
        registrant.register_option env, option_parser, Option.new(*args)
      end

      def run arguments, stderr: $stderr
        cli = new env, option_parser, arguments
        cli.parse_arguments!
        cli.run!
      rescue ArgumentError => e
        stderr.puts e
        exit EX_USAGE
      rescue StandardError => e
        stderr.puts "#{e.class.name}: #{e}"
        stderr.puts e.backtrace.map { |l| '  %s' % l }
        exit EX_SOFTWARE
      end

    private

      Option = Struct.new('Option', :short, :long, :arg, :desc)

      def env
        @env ||= Env.new
      end

      def option_parser
        @option_parser ||= OptionParser.new
      end
    end

    attr_reader :arguments, :env, :option_parser

    def initialize env, option_parser, arguments
      @env            = env
      @option_parser  = option_parser
      @arguments      = arguments
    end

    def parse_arguments!
      option_parser.parse! arguments
    rescue OptionParser::InvalidOption
      raise ArgumentError, option_parser
    end

    def run!
    end
  end
end
