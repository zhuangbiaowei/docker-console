module Ripl::Readline
  def get_input
    input = Readline.readline prompt, true
    if input.include?(" ")
      arr = input.split(" ")
      params = DockerConsole.instance_method(arr[0].to_sym).parameters
      if arr.length-1 > params.length
        return arr[0] + " " + arr[1..params.length-1].collect{|k| "\"#{k}\""}.join(",") +","+ "[#{arr[params.length..-1].collect{|k| "\"#{k}\""}.join(",")}]"
      else
        return arr[0]+" "+arr[1..-1].collect{|k| "\"#{k}\""}.join(",")
      end
    else
      return input
    end
  end
end

Ripl::Shell.include Ripl::Readline
