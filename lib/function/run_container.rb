def run_container(img,cmd=[])
  if cmd.class == String
    cmd = [cmd]
  end
  if cmd.include?("--rm")
    rm=true
    cmd.delete("--rm")
  end
  container = Docker::Container.create('Image' => img, 'Cmd' => cmd)
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
