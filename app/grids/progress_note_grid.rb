class ProgressNoteGrid
  include Datagrid

  scope do
    ProgressNote.includes(:client, :progress_note_type, :location, :material, :interventions, :assessment_domains).order(:created_at)
  end

  filter(:date, :date, range: true, header: -> { I18n.t('datagrid.columns.progress_notes.date') })

  filter(:progress_note_type_id, :enum, select: :progress_note_type_select_options, header: -> { I18n.t('datagrid.columns.progress_notes.progress_note_type') })

  def progress_note_type_select_options
    ProgressNoteType.joins(:progress_notes).map{ |t| [t.note_type, t.id] }.uniq
  end

  filter(:location_id, :enum, select: :location_select_options, header: -> { I18n.t('datagrid.columns.progress_notes.location') })

  def location_select_options
    Location.joins(:progress_notes).map{ |l| [l.name, l.id] }.uniq
  end

  filter(:interventions_action, :enum, multiple: true, select: :interventions_options, header: -> { I18n.t('datagrid.columns.progress_notes.interventions') }) do |action, scope|
    if interventions ||= Intervention.action_like(action)
      scope.joins(:interventions).where(interventions: { id: interventions.ids })
    else
      scope.joins(:interventions).where(interventions: { id: nil })
    end
  end

  def interventions_options
    Intervention.joins(:progress_notes).pluck(:action).uniq
  end

  filter(:material_id, :enum, select: :material_select_options, header: -> { I18n.t('datagrid.columns.progress_notes.material') })

  def material_select_options
    Material.joins(:progress_notes).map{ |m| [m.status, m.id] }.uniq
  end

  filter(:assessment_domains_goal, :enum, multiple: true, select: :assessment_domains_options, header: -> { I18n.t('datagrid.columns.progress_notes.goals_addressed') }) do |goal, scope|
    if assessment_domains ||= AssessmentDomain.goal_like(goal)
      scope.joins(:assessment_domains).where(assessment_domains: { id: assessment_domains.ids })
    else
      scope.joins(:assessment_domains).where(assessment_domains: { id: nil })
    end
  end

  def assessment_domains_options
    AssessmentDomain.joins(:progress_notes).pluck(:goal).uniq
  end

  column(:date, html: true, header: -> { I18n.t('datagrid.columns.progress_notes.date') }) do |object|
    link_to object.decorate.date, client_progress_note_path(object.client, object)
  end

  column(:date, html: false, header: -> { I18n.t('datagrid.columns.progress_notes.date') }) do |object|
    object.decorate.date
  end

  column(:child, order: proc { |scope| scope.joins(:client).reorder('clients.first_name') }, header: -> { I18n.t('datagrid.columns.progress_notes.child') }) do |object|
    object.client.name.blank? ? 'Unknown' : object.client.name
  end

  column(:staff, order: proc { |scope| scope.joins(:user).reorder('users.first_name') }, header: -> { I18n.t('datagrid.columns.progress_notes.staff') }) do |object|
    object.user.name
  end

  column(:progress_note_type, order: proc { |scope| scope.includes(:progress_note_type).reorder('progress_note_types.note_type') }, header: -> { I18n.t('datagrid.columns.progress_notes.progress_note_type') }) do |object|
    object.decorate.progress_note_type
  end

  column(:location, order: proc { |scope| scope.includes(:location).reorder('locations.name') }, header: -> { I18n.t('datagrid.columns.progress_notes.location') }) do |object|
    object.decorate.location
  end

  column(:material, order: proc { |scope| scope.includes(:material).reorder('materials.status') }, header: -> { I18n.t('datagrid.columns.progress_notes.material') }) do |object|
    object.decorate.material
  end

  column(:interventions, order: false, header: -> { I18n.t('datagrid.columns.progress_notes.interventions') }) do |object|
    object.interventions.pluck(:action).join(', ')
  end

  column(:goals_addressed, order: false, header: -> { I18n.t('datagrid.columns.progress_notes.goals_addressed') }) do |object|
    object.assessment_domains.pluck(:goal).join(', ')
  end

  column(:manage, html: true, class: 'text-center', header: -> { I18n.t('datagrid.columns.progress_notes.manage') }) do |object|
    render partial: 'progress_notes/actions', locals: { object: object }
  end
end
