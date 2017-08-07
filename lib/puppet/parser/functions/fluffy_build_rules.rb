module Puppet::Parser::Functions
  newfunction(:fluffy_build_rules, :type => :rvalue, :doc => <<-EOS
Return a ordered list of Fluffy rules
EOS
  ) do |arguments|

    raise Puppet::ParseError, "fluffy_build_rules(): Wrong number of arguments given (#{arguments.size} for 1)" if arguments.size < 1

    rules = arguments[0]

    indexes = rules.select { |k, v| v['index'] }.map { |k, v| v['index'] }
    duplicates = indexes.count { |i| indexes.count(i) > 1 }
    raise Puppet::ParseError, "fluffy_build_rules(): Found duplicate indexes in rules" if duplicates > 0

    ordered_keys = rules.keys
    rules.each do |name, rule|
      if rule['index']
        raise Puppet::ParseError, "fluffy_build_rules(): Found out of range rule index" if rule['index'] > rules.size

        if ordered_keys[rule['index']] != name
          ordered_keys.delete(name)
          ordered_keys.insert(rule['index'], name)
        end
      end
    end

    ordered_rules = {}
    ordered_keys.each_with_index do |rule, index|
      ordered_rules[rule] = rules[rule].merge({'index' => index})
    end

    ordered_rules
  end
end
