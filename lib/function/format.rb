require 'terminal-table'

def human_size(size)
  if size>1000*1000
    return "#{(size/1000.0/1000.0*10).to_i/10.0} MB"
  elsif size>1000
    return "#{(size/1000.0*10).to_i/10.0} KB"
  else
    return "#{size} B"
  end
end

def format_machine(machines)
  table = Terminal::Table.new do |t|
    t.headings = ['Number','Name','URL','Labels']
    machines.each do |m|
      t << [m["num"],m["name"],m["url"],m["labels"]]
    end
  end
  puts table
end

def format_image(list)
  table = Terminal::Table.new do |t|
    t.headings = ['ID','Image','Tag','VSize']
    list.each do |img|
      img.info["RepoTags"].each do |rt|
        t <<  [img.id[0..11], rt.split(":")[0..-2].join(":"), rt.split(":")[-1],human_size(img.info["VirtualSize"])]
      end
    end
  end
  puts table
end

def format_container(list)
  table = Terminal::Table.new do |t|
    t.headings = ["ID","Image","Name","Command","Status","Port"]
    list.each do |con|
      id = con.id[0..7]
      img = con.info["Image"]
      cmd = con.info["Command"]
      status = con.info["Status"]
      name = con.info["Names"][0]
      ports = con.info["Ports"]
      if ports.size>0
        ports.each do |port|
          port_str = "#{port["IP"]}:#{port["PrivatePort"]}->#{port["PublicPort"]}/#{port["Type"]}"
          t << [id,img,name,cmd,status,port_str]
        end
      else
        t << [id,img,name,cmd,status,""]
      end
    end
  end
  puts table
end
