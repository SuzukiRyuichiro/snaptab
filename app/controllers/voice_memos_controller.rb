class VoiceMemosController < ApplicationController
  def create
    @voice_memo = Current.user.voice_memos.new
    @voice_memo.audio.attach(params[:audio]) if params[:audio].present?
    authorize @voice_memo

    if @voice_memo.save
      TranscribeVoiceMemoJob.perform_later(@voice_memo.id)
      # Back to the New page so the user can immediately record the next expense;
      # this memo's status streams in at the top of that page.
      redirect_to new_expense_path, status: :see_other
    else
      redirect_to new_expense_path, alert: t("voice_memos.create.error"), status: :see_other
    end
  end
end
