def human_size(size)
  if size>1000*1000
    return "#{(size/1000.0/1000.0*10).to_i/10.0} MB"
  elsif size>1000
    return "#{(size/1000.0*10).to_i/10.0} KB"
  else
    return "#{size} B"
  end
end

def format_text(str,len)
  str = str[0..len-3]+".." if str.length > len
  str+" "*(len-str.length)
end

def format_image(list)
  puts "#{format_text("ID",8)}\t#{format_text("Image",16)}\t#{format_text("Tag",16)}\t#{format_text("VSize",20)}"
  list.each do |img|
    img.info["RepoTags"].each do |rt|
      repo,tag = rt.split(":")
      repo=format_text(repo,16)
      tag=format_text(tag,16)
      puts img.id[0..11]+"\t"+repo+"\t"+tag+"\t"+human_size(img.info["VirtualSize"])+"\n"
    end
  end
end

def format_container(list)
  puts "#{format_text("ID",8)}\t#{format_text("Image",20)}\t#{format_text("Name",20)}\t#{format_text("Command",30)}\t#{format_text("Status",20)}\tPort"
  list.each do |con|
    id = format_text(con.id[0..7],8)
    img = format_text(con.info["Image"],20)
    cmd = format_text(con.info["Command"],30)
    status = format_text(con.info["Status"],20)
    name = con.info["Names"][0]
    name = format_text(name,20)
    ports = con.info["Ports"]
    if ports.size>0
      ports.each do |port|
        port_str = "#{port["IP"]}:#{port["PrivatePort"]}->#{port["PublicPort"]}/#{port["Type"]}"
        puts id+"\t"+img+"\t"+name+"\t"+cmd+"\t"+status+"\t"+port_str
      end
    else
      puts id+"\t"+img+"\t"+name+"\t"+cmd+"\t"+status
    end
  end
end
