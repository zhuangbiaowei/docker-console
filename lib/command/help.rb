module Help
  def help
    puts "cm: connect machine\n"+
    "lm: list machines\n"+
    "li: list images\n"+
    "lc: list containers\n"+
    "lca: list all containers\n"+
    "sm: search machines with name label\n"+
    "run: run image with cmd\n"+
    "run_rm: run iamge with --rm"
    return nil
  end
end
