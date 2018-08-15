class ClientHistory
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in database: ->{ Organization.current.mho? ? ENV['MHO_HISTORY_DATABASE_NAME'] : ENV['HISTORY_DATABASE_NAME'] }
  default_scope { where(tenant: Organization.current.try(:short_name)) }

  field :object, type: Hash
  field :tenant, type: String, default: ->{ Organization.current.short_name }

  embeds_many :agency_client_histories
  embeds_many :sponsor_histories
  embeds_many :case_client_histories
  embeds_many :case_worker_client_histories
  embeds_many :client_custom_field_property_histories
  embeds_many :client_family_histories
  embeds_many :client_quantitative_case_histories

  after_save :create_sponsor_history, if: 'object.key?("donor_ids")'
  after_save :create_agency_client_history, if: 'object.key?("agency_ids")'
  after_save :create_case_worker_client_history, if: 'object.key?("user_ids")'
  after_save :create_client_quantitative_case_history, if: 'object.key?("quantitative_case_ids")'
  after_save :create_case_client_history,   if: 'object.key?("case_ids")'
  after_save :create_client_family_history, if: 'object.key?("family_ids")'
  after_save :create_client_custom_field_property_history, if: 'object.key?("custom_field_property_ids")'

  def self.initial(client)
    attributes = client.attributes
    attributes = attributes.merge('quantitative_case_ids' => client.quantitative_case_ids) if client.quantitative_case_ids.any?
    attributes = attributes.merge('agency_ids' => client.agency_ids) if client.agency_ids.any?
    attributes = attributes.merge('case_ids' => client.case_ids) if client.case_ids.any?
    attributes = attributes.merge('family_ids' => client.family_ids) if client.family_ids.any?
    attributes = attributes.merge('custom_field_property_ids' => client.custom_field_properties.ids) if client.custom_field_properties.any?
    attributes = attributes.merge('user_ids' => client.user_ids) if client.user_ids.any?
    create(object: attributes)
  end

  private

  def create_client_quantitative_case_history
    object['quantitative_case_ids'].each do |quantitative_case_id|
      quantitative_case = QuantitativeCase.find_by(id: quantitative_case_id).try(:attributes)
      client_quantitative_case_histories.create(object: quantitative_case)
    end
  end

  def create_agency_client_history
    object['agency_ids'].each do |agency_id|
      agency = Agency.find_by(id: agency_id).try(:attributes)
      agency_client_histories.create(object: agency)
    end
  end

  def create_sponsor_history
    object['donor_ids'].each do |donor_id|
      donor = Donor.find_by(id: donor_id).try(:attributes)
      sponsor_histories.create(object: donor)
    end
  end

  def create_case_client_history
    object['case_ids'].each do |case_id|
      c_case = Case.find_by(id: case_id).try(:attributes)
      case_client_histories.create(object: c_case)
    end
  end

  def create_case_worker_client_history
    object['user_ids'].each do |user_id|
      case_worker = User.find_by(id: user_id).try(:attributes)
      case_worker['current_sign_in_ip'] = case_worker['current_sign_in_ip'].to_s
      case_worker['last_sign_in_ip'] = case_worker['last_sign_in_ip'].to_s
      case_worker_client_histories.create(object: case_worker)
    end
  end

  def create_client_custom_field_property_history
    object['custom_field_property_ids'].each do |ccfp_id|
      custom_field_property               = CustomFieldProperty.find_by(id: ccfp_id).try(:attributes)
      custom_field_property['properties'] = format_custom_field_property(custom_field_property)
      client_custom_field_property_histories.create(object: custom_field_property)
    end
  end

  def create_client_family_history
    object['family_ids'].each do |family_id|
      family = Family.find_by(id: family_id).try(:attributes)
      client_family_histories.create(object: family)
    end
  end

  def format_custom_field_property(custom_field_property)
    mappings = {}
    custom_field_property['properties'].each do |k, v|
      mappings[k] = k.gsub(/(\s|[.])/, '_')
    end
    custom_field_property['properties'].map {|k, v| [mappings[k].downcase, v] }.to_h
  end
end
