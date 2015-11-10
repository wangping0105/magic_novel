module UserDestroyable
  extend ActiveSupport::Concern
  
  included do
    def self.acts_as_paranoid(options={})
      alias :really_destroyed? :destroyed?
      alias :really_delete :delete

      alias :destroy_without_paranoia :destroy
      def really_destroy!
        dependent_reflections = self.class.reflections.select do |name, reflection|
          reflection.options[:dependent] == :destroy
        end
        if dependent_reflections.any?
          dependent_reflections.each do |name, reflection|
            association_data = self.send(name)
            # has_one association can return nil
            # .paranoid? will work for both instances and classes
            if association_data && association_data.paranoid?
              if reflection.collection?
                association_data.with_deleted.each(&:really_destroy!)
              else
                association_data.really_destroy!
              end
            end
          end
        end
        write_attribute(paranoia_column, current_time_from_proper_timezone)
        destroy_without_paranoia
      end

      include Paranoia
      class_attribute :paranoia_column, :paranoia_sentinel_value

      self.paranoia_column = (options[:column] || :deleted_at).to_s
      self.paranoia_sentinel_value = options.fetch(:sentinel_value) { Paranoia.default_sentinel_value }
      def self.paranoia_scope
        where(paranoia_column => paranoia_sentinel_value)
      end
      default_scope { paranoia_scope } unless options[:default_scope] == false

      before_restore {
        self.class.notify_observers(:before_restore, self) if self.class.respond_to?(:notify_observers)
      }
      after_restore {
        self.class.notify_observers(:after_restore, self) if self.class.respond_to?(:notify_observers)
      }
    end

    acts_as_paranoid default_scope: false

    attr_accessor :to_staff_id

    delegate :want_check_entity_names, to: "self.class"

    before_destroy do
      push_sign_out_to_igetui("你的帐号已被删除，本地已经下线", transmission_type = 0)
    end
  end

  def can_destroy_this?
    is_all_alone? || is_entity_clear?
  end

  def is_entity_clear?
    want_check_entity_names.all?{|entity_name| send(entity_name).empty?}
  end

  def is_all_alone?
    self.organization.users.with_deleted.where.not(id: id).empty?
  end

  def transfer_entities_to(operator, to_user = nil)
   if self.id != to_user.id
      want_check_entity_names.all?{|entity_name|
        _klass_name = send(entity_name).klass
        _klass_name.mass_transfer(send(entity_name), operator, to_user)
      }
    end
  end

  module ClassMethods
    def want_check_entity_names
      @want_check_entity_names ||= %w(leads customers opportunities contracts)
    end
  end
end
