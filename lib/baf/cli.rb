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

      def run arguments, stdout: $stdout, stderr: $stderr
        cli = new env(stdout), option_parser, arguments
        cli.parse_arguments!
        cli.run
      rescue ArgumentError => e
        stderr.puts e
        exit EX_USAGE
      rescue StandardError => e
        stderr.puts "#{e.class.name}: #{e}"
        stderr.puts e.backtrace.map { |l| '  %s' % l }
        exit EX_SOFTWARE
      end

    protected

      Option = Struct.new('Option', :short, :long, :arg, :desc)

      def env output = nil
        @env ||= Env.new(output)
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
      setup_default_options option_parser
    end

    def parse_arguments!
      option_parser.parse! arguments
    rescue OptionParser::InvalidOption
      raise ArgumentError, option_parser
    end

    def run
    end

  protected

    def setup_default_options option_parser
      option_parser.separator ''
      option_parser.separator 'options:'
      option_parser.on_tail '-h', '--help', 'print this message' do
        env.print option_parser
      end
    end
  end
end