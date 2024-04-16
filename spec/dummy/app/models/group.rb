class Group < ApplicationRecord
  include Timelines::HasEvents
  include Timelines::Ephemeral
end
