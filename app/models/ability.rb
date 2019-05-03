# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    set_aliases

    guest_abilities
    can :create, [Question, Answer, Comment]
    can :modify, [Question, Answer, Comment], author: user
    can :set_best, Answer, question: { author: user }
    #author: !user
    can :vote, [Question, Answer] do |resource|
      !user.author_of?(resource)
    end

    can :sign_out, User
  end

  def admin_abilities
    can :manage, :all
  end

  def set_aliases
    alias_action :update, :destroy, to: :modify
    alias_action :upvote, :downvote, to: :vote
  end
end
