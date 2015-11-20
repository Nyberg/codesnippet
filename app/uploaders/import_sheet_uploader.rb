# encoding: utf-8

class ImportSheetUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    'public/uploads'
  end

  def extension_white_list
    %w(xlsx)
  end
end
