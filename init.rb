require 'redmine'
require_dependency 'issue_patch'
require_dependency 'issues_helper_patch'
require_dependency 'issues_show_description_hook'
require_dependency 'pdf_patch'
require_dependency 'version_patch'
require_dependency 'view_versions_show_bottom_hook'

Issue.send(:include, RedmineForWeeklyReport::Issue)
IssuesHelper.send(:include, RedmineForWeeklyReport::IssuesHelper)
Redmine::Export::PDF.send(:include, RedmineForWeeklyReport::PDF)
Version.send(:include, RedmineForWeeklyReport::Version)

Redmine::Plugin.register :redmine_for_weekly_report do
  name 'Redmine For Weekly Report plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
