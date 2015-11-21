module Machine
  def load_machines config_dir
    @docker_machine_data = config_dir
    @all_machines = []
    @machine = []
    machines = `ls #{@docker_machine_data}`.split("\n")
    machines.each do |machine|
      f = File.open(File.expand_path(@docker_machine_data)+"/"+machine+"/config.json","r")
      data = f.read
      json = JSON.parse(data)
      @all_machines << {
        "name"=>machine,
        "url"=>"tcp://"+json["Driver"]["IPAddress"]+":2376"
      }
    end
  end

  def lm(name="*",label="*")
    @machines = []
    puts "Number\t#{format_text("Name",20)}\t#{format_text("URL",30)}\tLabels"
    machines = `ls #{@docker_machine_data}`.split("\n")
    num = 0
    machines.each do |machine|
      f = File.open(File.expand_path(@docker_machine_data)+"/"+machine+"/config.json","r")
      data = f.read
      json = JSON.parse(data)
      labels = json["HostOptions"]["EngineOptions"]["Labels"]
      if (name=="*" || machine.include?(name))  && (label=="*" || labels.include?(label))
        url="tcp://"+json["Driver"]["IPAddress"]+":2376"
        @machines << {
          "name"=>machine,
          "url"=>url
        }
        puts num.to_s+"\t"+format_text(machine,20)+"\t"+format_text(url,30)+"\t"+labels.join(",")
        num = num + 1
      end
    end
    return "Total #{@machines.count} machines."
  end

  def cm(url)
    if url.to_i.to_s==url
      if @machines.empty?
        machine = @all_machines[url.to_i]
      else
        machine = @machines[url.to_i]
      end
      ENV["DOCKER_TLS_VERIFY"]="1"
      ENV["DOCKER_HOST"]=machine["url"]
      ENV["DOCKER_CERT_PATH"]=File.expand_path(@docker_machine_data)+"/"+machine["name"]
      ENV["DOCKER_MACHINE_NAME"]=machine["name"]
      Docker.url=machine["url"]
    else
      @all_machines.each do |machine|
        if machine["name"]==url or machine["url"]==url
          ENV["DOCKER_TLS_VERIFY"]="1"
          ENV["DOCKER_HOST"]=machine["url"]
          ENV["DOCKER_CERT_PATH"]=File.expand_path(@docker_machine_data)+"/"+machine["name"]
          ENV["DOCKER_MACHINE_NAME"]=machine["name"]
          Docker.url=machine["url"]
        end
      end
    end
    "Connected Docker: #{Docker.url}"
  end
end
