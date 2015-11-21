module Container
  def lc(cmd=nil)
    all = (cmd=="-a")? true : false
    list = Docker::Container.all(:all=>all)
    format_container(list)
    return "Total #{list.count} containers."
  end
  def rm(id)
    container = Docker::Container.get(id)
    container.kill!
    container.delete
    "Container #{id} Deleted!"
  end
  def run(img,cmd=[])
    run_container(img,cmd)
  end
  def mrun(img,cmd=[])
    url = Docker.url
    @machines.each do |machine|
      ENV["DOCKER_TLS_VERIFY"]="1"
      ENV["DOCKER_HOST"]=machine["url"]
      ENV["DOCKER_CERT_PATH"]=File.expand_path(@docker_machine_data)+"/"+machine["name"]
      ENV["DOCKER_MACHINE_NAME"]=machine["name"]
      Docker.url = machine["url"]
      run_container(img,cmd.clone)
    end
    Docker.url = url
    return "Run command at #{@machines.count} machines."
  end
end
