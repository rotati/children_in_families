namespace :client_exit_date do
  desc 'Update client exit_date when status include Exit and exit_date nil'
  task update: :environment do
    Organization.all.each do |org|
      Organization.switch_to org.short_name

      client_ids = Client.where(exit_date: nil, status: Client::EXIT_STATUSES).pluck(:id)

      client_ids.each do |id|
        client = Client.find(id)
        exit_note = client.status

        versions = []
        Client::EXIT_STATUSES.each do |status|
          version = PaperTrail::Version.where(item_type: 'Client', item_id: id, event: 'update').where_object_changes(status: status)
          versions << version if version.any?
        end

        if versions.empty?
          exit_date = client.updated_at || client.created_at
        else
          exit_date = versions.flatten.sort_by{ |v| v.created_at }.last.created_at
        end
        
        client.update(exit_date: exit_date, exit_note: exit_note)
      end
    end
  end
end
