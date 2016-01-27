class Picture < ActiveRecord::Base
  has_one :agent
  has_one :patron
  has_one :venue
  has_one :event
  validates_format_of :content_type,    
                      :with    => /^image/,    
                      :message => "you can only upload images"
  
  max = Resource.get("venue_max_image_size").to_i/1024
  validates_length_of :data, :maximum => 102400, :message => "less than #{max} KB if you don't mind"

  def uploaded_picture=(image_url)
    self.name   = base_part_of(image_url.original_filename)
    self.content_type = image_url.content_type.chomp
    self.data = image_url.read
  end
  
  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '')
  end
end
