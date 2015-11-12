class Profile < ActiveRecord::Base
  belongs_to :user

  mount_uploader :avatar, AvatarUploader

  validates :first_name, :presence => { :message => "can not be blank" },
                   length: { maximum: 50 }
  validates :last_name, :presence => { :message => "can not be blank" },
                   length: { maximum: 50 }
  validates :company, :presence => { :message => "can not be blank" },
                   length: { maximum: 50 }
  validates :job_title, presence: true,
                   length: { maximum: 50 }

  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||',
      Arel::Nodes::InfixOperation.new('||',
        parent.table[:first_name], Arel::Nodes.build_quoted(' ')
      ),
      parent.table[:last_name]
    )
  end
end