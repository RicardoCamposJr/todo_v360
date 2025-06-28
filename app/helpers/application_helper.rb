module ApplicationHelper
  def status_label(status)
    case status
    when "to_do"
      "A Fazer"
    when "in_progress"
      "Em Progresso"
    when "done"
      "Concluída"
    else
      status.humanize
    end
  end

  def status_icon_and_label(status)
    case status
    when "to_do"
      raw('<i class="fas fa-clock me-2 text-warning"></i> A Fazer')
    when "in_progress"
      raw('<i class="fas fa-spinner me-2 text-info"></i> Em Progresso')
    when "done"
      raw('<i class="fas fa-check me-2 text-success"></i> Concluída')
    else
      status.humanize
    end
  end
end
