# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # See the wiki for details:
  # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

  def initialize(user)
    return if user.blank?

    can :read, :thaalis
    can :read, :sabeels

    if %w[admin member].include?(user.role)
      can :manage, Sabeel
      can :manage, Thaali
      can :manage, Transaction
    end

    case user.role
    when "admin"
      can :manage, User, id: user.id
      can [:show, :destroy], User
    when "member"
      cannot [:create, :destroy], Sabeel
      can [:show, :update, :destroy], User, id: user.id
    when "viewer"
      can [:read, :active, :inactive], Sabeel
      can [:read, :complete, :pending, :all], Thaali
      can [:read, :all], Transaction
    end
  end
end
