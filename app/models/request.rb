class Request < ApplicationRecord
	validates :participants, presence: true, inclusion: 1..4
	validates :contents, presence: true, length: { minimum: 5 }
end
