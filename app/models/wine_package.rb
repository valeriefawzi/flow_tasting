class WinePackage < ActiveRecord::Base
  belongs_to :wine
  belongs_to :tasting_package
  scope :wine_list, ->(tasting_package_id) { where("tasting_package_id = ?", tasting_package_id)
                                             .joins(:wine)
                                             .order(:wine_tasting_code)
                                             .select("wines.*, wine_packages.wine_tasting_code") 
                                           }
end