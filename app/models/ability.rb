class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  protected
    def admin_abilities
      can :manage, :all
    end

    def user_abilities
      guest_abilities
      can [:read, :me], User
      can :create, [Question, Answer, Comment]
      can [:update, :destroy], [Question, Answer], user_id: @user.id

      can :vote, [Question, Answer]
      cannot :vote, [Question, Answer], user_id: @user.id

      can :switch_promotion, Answer, question: { user_id: @user.id }

      can :destroy, Attachment, attachable: { user_id: @user.id }
    end

    def guest_abilities
      can :read, [Answer, Comment, Question]
    end
end
