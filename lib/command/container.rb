module Container
  def lc
    list = Docker::Container.all
    format_container(list)
    return "Total #{list.count} containers."
  end
  def lca
    list = Docker::Container.all(:all=>true)
    format_container(list)
    return "Total #{list.count} containers."
  end
  def rm(id)
    container = Docker::Container.get(id)
    container.kill!
    container.delete
    "Container #{id} Deleted!"
  end
  def run_rm(img,cmd=nil)
    if cmd==nil
      cmd = []
    elsif cmd.class == String
      cmd = [cmd]
    end
    container = Docker::Container.create('Image' => img, 'Cmd' => cmd)
    container.start
    container = Docker::Container.get(container.id)
    while container.info["State"]["Status"]=="running"
      sleep 1
      container = Docker::Container.get(container.id)
    end
    puts container.logs(stdout: true,stderr: true)
    container.stop
    container.kill
    container.delete(:force => true)
  end
  def run(img,cmd=nil)
    if cmd==nil
      cmd = []
    elsif cmd.class == String
      cmd = [cmd]
    end
    container = Docker::Container.create('Image' => img, 'Cmd' => cmd)
    container.start
  end
  def mrun(img,cmd=nil)
    if cmd==nil
      cmd = []
    elsif cmd.class == String
      cmd = [cmd]
    end
    url = Docker.url
    @machines.each do |machine|
      Docker.url = machine["url"]
      container = Docker::Container.create('Image' => img, 'Cmd' => cmd)
      container.start
    end
    Docker.url = url
    return "Run command at #{@machines.count} machines."
  end
end
