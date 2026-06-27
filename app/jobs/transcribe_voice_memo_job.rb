class TranscribeVoiceMemoJob < ApplicationJob
  queue_as :default

  def perform(voice_memo_id)
    memo = VoiceMemo.find(voice_memo_id)
    return if memo.completed?

    memo.processing!

    transcript = I18n.with_locale(memo.user.locale || I18n.default_locale) do
      AudioTranscriber.new(memo.audio).call
    end

    # Reuse an expense from a prior partial run so a retry never creates a duplicate.
    # Creation and association happen in one transaction so the memo always points at
    # the expense if the row exists, keeping the job idempotent across retries.
    unless memo.expense
      attributes = ExpenseExtractor.new(user: memo.user).call(transcript)
      ActiveRecord::Base.transaction do
        memo.update!(expense: memo.user.expenses.create!(attributes))
      end
    end

    memo.update!(status: :completed, transcript: transcript)
    memo.audio.purge # the audio is only needed for transcription; drop it to keep storage cheap
  rescue StandardError => e
    memo&.update(status: :failed, error_message: e.message)
    raise
  end
end
