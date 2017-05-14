authorization do
  role :guest do
    # add permissions for guests here, e.g.
    # has_permission_on :conferences, :to => :read
  end

  role :barista do
    has_permission_on :shifts, to: :manage do
      if_attribute :user => is { user }
    end
    has_permission_on :users, to: [:read_and_update_without_index, :clock_page, :clock_in, :clock_out] do
      if_attribute :id => is { user.id }
    end
  end

  role :manager do
    includes :barista
  end

  role :admin do
    includes :manager
    has_permission_on :shifts, to: :manage
    has_permission_on :users, to: :manage
  end

  role :superuser do
    has_omnipotence
  end
  
  # permissions on other roles, such as
  # role :admin do
  #   has_permission_on :conferences, :to => :manage
  # end
  # role :user do
  #   has_permission_on :conferences, :to => [:read, :create]
  #   has_permission_on :conferences, :to => [:update, :delete] do
  #     if_attribute :user_id => is {user.id}
  #   end
  # end
  # See the readme or GitHub for more examples
end

privileges do
  # default privilege hierarchies to facilitate RESTful Rails apps
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read_and_update, :includes => [:create, :read, :update]
  privilege :read_and_update_without_index, :includes => [:create, :update, :show]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy

end
