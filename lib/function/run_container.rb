def run_container(img,cmd=[])
  if cmd.class == String
    cmd = [cmd]
  end
  if cmd.include?("--rm")
    rm=true
    cmd.delete("--rm")
  end
  port_index = cmd.index("-p")
  if port_index
    port = cmd[port_index+1]
    cmd.delete("-p")
    cmd.delete(port)
  end
  if port
    host_config={"PortBindings"=>{}}
    port.split(",").each do |port_pair|
    publish_port,inner_port = port_pair.split(":")
      host_config["PortBindings"]["#{publish_port}/tcp"]=[{"HostPort"=>"#{inner_port}"}]
    end
  end
  container = Docker::Container.create('Image' => img, 'Cmd' => cmd, "HostConfig"=>host_config)
  container.start
  if rm==true
    while container.info["State"]==nil
      sleep 1
      container = Docker::Container.get(container.id)
    end
    while container.info["State"]["Status"]=="running"
      sleep 1
      container = Docker::Container.get(container.id)
    end
    puts container.logs(stdout: true,stderr: true)
    container.stop
    container.kill
    container.delete(:force => true)
  end
end
