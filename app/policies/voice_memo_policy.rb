class VoiceMemoPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      user.voice_memos.all
    end
  end

  def create?
    true
  end
end
