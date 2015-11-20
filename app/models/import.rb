class Import < ActiveRecord::Base
  mount_uploader :import_sheet, ImportSheetUploader
end
