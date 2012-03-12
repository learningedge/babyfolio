class Attachment < ActiveRecord::Base
belongs_to :media
belongs_to :moment
end
