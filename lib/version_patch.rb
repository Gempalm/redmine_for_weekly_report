require_dependency 'version'

module RedmineForWeeklyReport
  module Version
    def self.included(base)
      base.class_eval do
        alias_method_chain :estimated_hours, :more
      end
    end

    def estimated_hours_with_more
      @estimated_hours ||= fixed_issues.sum(:estimated_hours).to_f
    end
  end
end
