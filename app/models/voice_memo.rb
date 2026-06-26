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

  # Only still-running memos are rendered on page load. Completed/failed states are
  # delivered live via Turbo Streams and are transient (gone on the next reload).
  scope :in_progress, -> { where(status: %i[pending processing]) }

  after_update_commit :broadcast_status_change, if: :saved_change_to_status?

  private

  def broadcast_status_change
    broadcast_replace_to(user, :voice_memos)
  end
end
