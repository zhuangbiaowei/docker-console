module Image
  def li
    list = Docker::Image.all
    format_image(list)
    return "Total #{list.count} images."
  end
end
