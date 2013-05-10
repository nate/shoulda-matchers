module Shoulda # :nodoc:
  module Matchers
    module ActiveRecord # :nodoc:
      module AssociationMatchers
        class ThroughMatcher
          attr_accessor :missing_option

          def initialize(through, name)
            @through = through
            @name = name
            @missing_option = ''
          end

          def description
            " through #{through}"
          end

          def matches?(subject)
            self.subject = ModelReflector.new(subject, name)
            through.nil? || (through_association_exists? && through_association_correct?)
          end

          def through_association_exists?
            if through_reflection.nil?
              missing_option = "#{name} does not have any relationship to #{through}"
              false
            else
              true
            end
          end

          def through_reflection
            through_reflection ||= subject.reflect_on_association(through)
          end

          def through_association_correct?
            if through.to_s == subject.option_string(:through)
              true
            else
              self.missing_option = "Expected #{name} to have #{name} through #{through}, " +
                "but got it through #{subject.option_string(:through)}"
              false
            end
          end

          private
          attr_accessor :through, :name, :subject
        end
      end
    end
  end
end
