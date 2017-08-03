module Puppet::Parser::Functions
  newfunction(:fluffy_build_rules, :type => :rvalue, :doc => <<-EOS
Return a ordered list of Fluffy rules
EOS
  ) do |arguments|

    raise Puppet::ParseError, "fluffy_build_rules(): Wrong number of arguments given (#{arguments.size} for 1)" if arguments.size < 1

    ordered_rules = {}
    rules = arguments[0]

    rules_keys = rules.keys
    rules.each do |name, rule|
      if rule['before_rule'] and rule['after_rule']
        raise Puppet::ParseError, "fluffy_build_rules(): 'before_rule' and 'after_rule' cannot be used together in rule #{name}"
      elsif rule['before_rule']
        if rules[rule['before_rule']]
          rules_keys.delete(name)
          rules_keys.insert(rules_keys.index(rule['before_rule']), name)
        else
          raise Puppet::ParseError, "fluffy_build_rules(): Failed to look up before_rule #{rule['before_rule']} in rule #{name}"
        end
      elsif rule['after_rule']
        if rules[rule['after_rule']]
          rules_keys.delete(name)
          rules_keys.insert(rules_keys.index(rule['after_rule']) + 1, name)
        else
          raise Puppet::ParseError, "fluffy_build_rules(): Failed to look up after rule #{rule['after_rule']} in rule #{name}"
        end
      end
    end

    rules_keys.each_with_index do |rule, index|
      ordered_rules[rule] = rules[rule].merge({'index' => index}).reject { |k| ['before_rule', 'after_rule'].include?(k) }
    end

    return ordered_rules
  end
end
