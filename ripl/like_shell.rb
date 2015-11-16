module Ripl::Readline
  def get_input
    input = Readline.readline prompt, true
    if input.include?(" ")
      arr = input.split(" ")
      return arr[0]+" "+arr[1..-1].collect{|k| "\"#{k}\""}.join(",")
    else
      return input
    end
  end
end

Ripl::Shell.include Ripl::Readline
