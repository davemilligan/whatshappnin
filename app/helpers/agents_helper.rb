module AgentsHelper


private

  def save(image_url)
    File.open("venues/#{image_url}", "w") { |f| f.write(image_url.read) }
  end 
  
end
