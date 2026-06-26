class VoiceMemosController < ApplicationController
  def create
    @voice_memo = Current.user.voice_memos.new
    @voice_memo.audio.attach(params[:audio]) if params[:audio].present?
    authorize @voice_memo

    if @voice_memo.save
      TranscribeVoiceMemoJob.perform_later(@voice_memo.id)
      redirect_to expenses_path, notice: t("voice_memos.create.processing"), status: :see_other
    else
      redirect_to new_expense_path, alert: t("voice_memos.create.error"), status: :see_other
    end
  end
end
