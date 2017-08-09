module Puppet::Parser::Functions
  newfunction(:fluffy_build_rules, :type => :rvalue, :doc => <<-EOS
Return a ordered list of Fluffy rules
EOS
  ) do |arguments|

    raise Puppet::ParseError, "fluffy_build_rules(): Wrong number of arguments given (#{arguments.size} for 1)" if arguments.size < 1

    rules = arguments[0]

    # sort the rules by looking up the 'order' field
    sorted_rules = Hash[rules.sort_by { |k, v| v['order'] }]

    ordered_rules = {}
    sorted_rules.keys.each_with_index do |rule, index|
      after_rule = nil
      i = index - 1

      while i > 0
        after_rule = sorted_rules[sorted_rules.keys[i]]
        if after_rule[:ensure] and after_rule[:ensure] == :absent
          i -= 1
        else
          break
        end
      end

      ordered_rules[rule] = rules[rule].merge({
        'after_rule' => (i >= 0) ? sorted_rules.keys[i] : nil
      }).reject { |k, v| k == 'order' }
    end

    ordered_rules
  end
end
