require_relative('./passport.rb')

class PassportParser
  attr_reader :passports

  def initialize(filename)
    text = File.read(File.join(File.dirname(__FILE__), filename))

    @passports = text.split("\n\n").map do |pass_text|
        fields = pass_text.split(/ |\n/).map { |f| f.split(':') }.to_h
        Passport.new(fields)
    end
  end
end