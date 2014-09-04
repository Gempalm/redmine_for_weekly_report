module RedmineForWeeklyReports
  class ViewVersionsShowBottomHook < Redmine::Hook::ViewListener

    def view_versions_show_bottom(context={ })

      html = ''
      html << "<style type=\"text/css\">\n"
      html << "  <!-- \n"
      html << "    #custom_field { float:left; width:48%; margin-left: 16px; margin-bottom: 16px; background-color: #fff; }\n"
      html << "  --> \n"
      html << "</style>\n"

      project = Project.find(context[:version].project_id)
      issues = Issue.where(["fixed_version_id = ?", context[:version].id])

      issues_ids = Array.new
      issues.each do |issue|
        issues_ids.push(issue.id)
      end

      # custom_fields.field_format == "list"
      custom_fields = CustomField.where(["type = ? and field_format = ?", "IssueCustomField", "list"])
      custom_fields.sort! {|a, b| a.possible_values.size <=> b.possible_values.size }

      custom_fields.each do |custom_field|
        html << "<div id=\"custom_field\">\n"
        html << "\n<table class=\"list related-issues\">\n"
        html << "<caption>#{custom_field.name}</caption>\n"

        custom_field.possible_values.each do |possible_value|
          html << "  <tr class=\"issue hascontextmenu\"><td  class=\"subject\">"
          html << possible_value
          html << "</td><td>"

          count = CustomValue.count(:all, 
                                    :conditions => ["customized_type = ? and customized_id in (?) and custom_field_id = ? and value = ?",
                                      "Issue",
                                      issues_ids,
                                      custom_field.id,
                                      possible_value])

          if count == 0
            html << count.to_s
          else
            sym = ("cf_" + custom_field.id.to_s).to_sym
            html << link_to(count.to_s,
                            "/redmine" + project_issues_path(project.identifier,
                            :set_filter => 1,
                            :status_id => '*',
                            :fixed_version_id => context[:version].id,
                            sym => possible_value))
          end

          html << "</td></tr>\n"
        end

        html << "</table>\n"
        html << "</div>\n"
      end

      html
    end

  end
end
