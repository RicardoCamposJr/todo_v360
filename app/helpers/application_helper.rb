module ApplicationHelper
  def status_label(status)
    case status
    when "to_do"
      "A Fazer"
    when "in_progress"
      "Pendente"
    when "done"
      "Concluída"
    else
      status.humanize
    end
  end
end
