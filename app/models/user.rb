class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :users_matieres
  has_many :matieres, through: :users_matieres

  has_many :notes
  accepts_nested_attributes_for :notes, :reject_if => lambda { |b| b[:note].blank? }

	def prenom_et_nom
	  "#{nom} #{prenom}"
	end

	def active_for_authentication? 
    	super && approved? 
  	end 

  	def inactive_message 
    	if !approved? 
      		:not_approved 
   		else 
      		super # Use whatever other message 
    	end 
  	end

     def self.send_reset_password_instructions(attributes={})
      recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
      if !recoverable.approved?
        recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
      elsif recoverable.persisted?
        recoverable.send_reset_password_instructions
      end
      recoverable
    end

end
