class TranscribeVoiceMemoJob < ApplicationJob
  queue_as :default

  def perform(voice_memo_id)
    memo = VoiceMemo.find(voice_memo_id)
    return if memo.completed?

    memo.processing!

    transcript = AudioTranscriber.new(memo.audio).call
    attributes = ExpenseExtractor.new(user: memo.user).call(transcript)
    expense = memo.user.expenses.create!(attributes)

    memo.update!(status: :completed, transcript: transcript, expense: expense)
    memo.audio.purge # the audio is only needed for transcription; drop it to keep storage cheap
  rescue StandardError => e
    memo&.update(status: :failed, error_message: e.message)
    raise
  end
end
