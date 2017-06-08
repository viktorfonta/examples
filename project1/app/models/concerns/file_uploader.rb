module FileUploader
  extend ActiveSupport::Concern

  def create_file(data)
    create(file: data[:file], owner_id: data[:owner_id], owner_type: data[:owner_type])
  end

  def create_from_crop(data)
    image = Paperclip.io_adapters.for(data[:file])
    image.original_filename = data[:filename]
    create(file: image, owner_id: data[:owner_id], owner_type: data[:owner_type])
  end

end
