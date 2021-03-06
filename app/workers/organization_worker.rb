class OrganizationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'priority'

  def perform(org_id, referral_source_category_name)
    # Do something
    Organization.delay(queue: :priority).seed_generic_data(org_id, referral_source_category_name)
  end
end
