module Puppet::Parser::Functions
  newfunction(:fluffy_build_rules, :type => :rvalue, :doc => <<-EOS
Return a ordered list of Fluffy rules
EOS
  ) do |arguments|

    raise Puppet::ParseError, "fluffy_build_rules():  Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size < 1

    rules = arguments[0]

    ret = []
    ordered_rules = rules.keys
    rules.each do |name, rule|
      if rule['before_rule']
        if rules[rule['before_rule']]
          ordered_rules.delete(name)
          ordered_rules.insert(ordered_rules.index(rule['before_rule']), name)
        else
          raise Puppet::ParseError, "fluffy_build_rules(): Failed to look up rule #{rule['before_rule']}"
        end
      elsif rule['after_rule']
        if rules[rule['after_rule']]
          ordered_rules.delete(name)
          ordered_rules.insert(ordered_rules.index(rule['after_rule']) + 1, name)
        else
          raise Puppet::ParseError, "fluffy_build_rules(): Failed to look up rule #{rule['after_rule']}"
        end
      end
    end

    ordered_rules.each_with_index do |rule, index|
      ret << rules[rule].merge({'index' => index}).reject { |k| ['before_rule', 'after_rule'].include?(k) }
    end

    return ret
  end
end
