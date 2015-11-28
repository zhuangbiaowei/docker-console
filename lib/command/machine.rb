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
      labels = json["HostOptions"]["EngineOptions"]["Labels"]
      @all_machines << {
        "name"=>machine,
        "url"=>"tcp://"+json["Driver"]["IPAddress"]+":2376",
        "labels"=>labels
      }
    end
  end

  def lm(name="*",label="*")
    @machines = []
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
          "num" => num,
          "name" => machine,
          "url" => url,
          "labels" => labels.join(",")
        }
        num = num + 1
      end
    end
    format_machine(@machines)
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
