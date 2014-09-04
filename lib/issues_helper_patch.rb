require_dependency 'issues_helper'

module RedmineForWeeklyReport
  module IssuesHelper
    def self.included(base)
      base.class_eval do
        alias_method_chain :render_descendants_tree, :more
      end
    end

    def render_descendants_tree_with_more(issue)
      s = '<form><table class="list issues">'
      issue_list(issue.descendants.visible.sort_by(&:lft)) do |child, level|
        css = "issue issue-#{child.id} hascontextmenu"
        css << " idnt idnt-#{level}" if level > 0
        s << content_tag('tr',
               content_tag('td', check_box_tag("ids[]", child.id, false, :id => nil), :class => 'checkbox') +
               content_tag('td', link_to_issue(child, :truncate => 60, :project => (issue.project_id != child.project_id)), :class => 'subject') +
               content_tag('td', h(child.start_date)) + 
               content_tag('td', h(child.due_date)) +
               content_tag('td', l_hours(child.estimated_hours)) +
               content_tag('td', l_hours(child.total_spent_hours)) + 
#               content_tag('td', link_to_user(child.assigned_to)) +
               content_tag('td', progress_bar(child.done_ratio, :width => '80px', :legend => "#{@issue.done_ratio}%")) + 
               content_tag('td', h(child.status)),
               :class => css)
      end
      s << '</table></form>'
      s.html_safe
    end

  end
end
