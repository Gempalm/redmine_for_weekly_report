require_dependency 'issue'

module RedmineForWeeklyReport
  module Issue
    def self.included(base)
      base.class_eval do
        alias_method_chain :recalculate_attributes_for, :more
      end
    end

    def recalculate_attributes_for_with_more(issue_id)
    end
  end
end
