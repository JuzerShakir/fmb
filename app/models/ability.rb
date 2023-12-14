# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # See the wiki for details:
  # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

  def initialize(user)
    return if user.blank?

    case user.role
    when "admin"
      can :manage, User, id: user.id
      can [:show, :destroy], User
      can :manage, Sabeel
      can :manage, Thaali
      can :manage, Transaction
    when "member"
      can [:show, :update, :destroy], User, id: user.id
      can :manage, Sabeel
      cannot [:create, :destroy], Sabeel
      can :manage, Thaali
      can :manage, Transaction
    when "viewer"
      can [:read, :stats, :active, :inactive], Sabeel
      can [:read, :stats, :complete, :pending, :all], Thaali
      can [:all, :show], Transaction
    end
  end
end
