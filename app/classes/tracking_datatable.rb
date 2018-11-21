class TrackingDatatable < ApplicationDatatable
  def initialize(view)
    @view = view
    @fetch_trackings =  fetch_trackings
  end

  def as_json(options = {})
    {
      recordsFiltered: total_entries,
      data: column_program_streams
    }
  end

  private

  def sort_column
    column = columns[params[:order]['0'][:column].to_i]
    if column == 'program_stream_name'
      'program_streams.name'
    else
      'trackings.name'
    end
  end

  def fetch_trackings
    Tracking.unscoped.includes(:client_enrollments, :program_stream).where(client_enrollments: { status: 'Active' }).order("lower(#{sort_column}) #{sort_direction}").page(page).per(per_page)
  end

  def columns
    %w(program_stream_name name copy)
  end

  def column_program_streams
    @fetch_trackings.map{ |t| [t.program_stream.name, t.name, link_program_stream(t)] }
  end

  def link_program_stream(tracking)
    link_to(new_multiple_form_tracking_client_tracking_path(tracking)) do
      fa_icon('external-link')
    end
  end

  def total_entries
    @fetch_trackings.total_count
  end
end
