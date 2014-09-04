module RedmineForWeeklyReport
  class IssuesShowDescriptionHook < Redmine::Hook::ViewListener

    def issue_list(issues, &block)
      ancestors = []
      issues.each do |issue|
        while (ancestors.any? && !issue.is_descendant_of?(ancestors.last))
          ancestors.pop
        end
        yield issue, ancestors.size
        ancestors << issue unless issue.leaf?
      end
    end

    def view_issues_show_description_bottom(context={ })

      html = ''

      # show child description
      if !context[:issue].leaf?
        issue_list(context[:issue].descendants.visible.sort_by(&:lft)) do |child, level|
          unless child.description.to_s.strip.size == 0
            html << '<p><EM>&lt;'
            html << h(child.project) + ' - ' if context[:issue].project_id != child.project_id
            html << h(child)
            html << '&gt;</EM></p>'
            html << '<p>'
            html << textilizable(child, :description, :attachments => child.attachments)
            html << '</p>'
          end
        end
      end

      # show relations description
=begin
      if context[:issue].relations.present?
        context[:issue].relations.each do |relation|
          unless relation.other_issue(context[:issue]).description.to_s.strip.size == 0
            html << '<p><EM>&lt;'
            html << h(relation.other_issue(context[:issue]).project) + ' - ' if !Setting.cross_project_issue_relations?
            html << h(relation.other_issue(context[:issue]))
            html << '&gt;</EM></p>'
            html << '<p>'
            html << textilizable(relation.other_issue(context[:issue]), :description, :attachments => relation.other_issue(context[:issue]).attachments)
            html << '</p>'
          end
        end
      end
=end

    html
    end
  end
end
