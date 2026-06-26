class VoiceMemo < ApplicationRecord
  belongs_to :user
  belongs_to :expense, optional: true
  has_one_attached :audio

  enum :status, {
    pending: "pending",
    processing: "processing",
    completed: "completed",
    failed: "failed"
  }, default: "pending"

  validates :audio, presence: true

  scope :in_progress_or_failed, -> { where(status: %i[pending processing failed]) }
end
