describe CustomField, 'associations' do
  it { is_expected.to have_many(:custom_field_properties).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:clients).through(:custom_field_properties).source(:custom_formable) }
  it { is_expected.to have_many(:families).through(:custom_field_properties).source(:custom_formable) }
  it { is_expected.to have_many(:partners).through(:custom_field_properties).source(:custom_formable) }
  it { is_expected.to have_many(:users).through(:custom_field_properties).source(:custom_formable) }
end

describe CustomField, 'validations' do
  it { is_expected.to validate_presence_of(:entity_type) }
  it { is_expected.to validate_presence_of(:form_title) }
  it { is_expected.to validate_uniqueness_of(:form_title).case_insensitive.scoped_to(:entity_type) }
  it { is_expected.to validate_inclusion_of(:entity_type).in_array(CustomField::ENTITY_TYPES) }
  it 'validates presence of fields' do
    custom_field = CustomField.new
    custom_field.save
    expect(custom_field.errors[:fields]).to include("can't be blank")
  end
  it 'validates time of frequency value if frequency' do
    custom_field = CustomField.new(frequency: 'Day')
    custom_field.save
    expect(custom_field.errors[:time_of_frequency]).to include('must be greater than or equal to 1')
  end
  it 'validates time of frequency value data type if frequency' do
    custom_field = CustomField.new(frequency: 'Day', time_of_frequency: 1.1)
    custom_field.save
    expect(custom_field.errors[:time_of_frequency]).to include('must be an integer')
  end
  it 'validates field label must be uniq' do
    custom_field_unit = CustomField.new(fields: "[\r\n\t{\r\n\t\t\"type\": \"text\",\r\n\t\t\"label\": \"Text Field\",\r\n\t\t\"subtype\": \"text\",\r\n\t\t\"className\": \"form-control\",\r\n\t\t\"name\": \"text-1493090904302\"\r\n\t},\r\n\t{\r\n\t\t\"type\": \"text\",\r\n\t\t\"label\": \"Text Field\",\r\n\t\t\"subtype\": \"text\",\r\n\t\t\"className\": \"form-control\",\r\n\t\t\"name\": \"text-1493090904547\"\r\n\t}\r\n]")
    custom_field_unit.save
    expect(custom_field_unit.errors[:fields]).to include('field label must be uniq')
  end
  # it "validates remove fields if fields haven't used" do
  #   client = FactoryGirl.create(:client, given_name: 'Jonh')
  #   custom_field_textarea = FactoryGirl.create(:custom_field, entity_type: 'Client', form_title: 'Spec', fields: "[\r\n\t{\r\n\t\t\"type\": \"textarea\",\r\n\t\t\"label\": \"Text Area\",\r\n\t\t\"className\": \"form-control\",\r\n\t\t\"name\": \"textarea-1493086701693\"\r\n\t}\r\n]")
  #   client_custom_field = client.custom_field_properties.create(properties: '{"Text Area":"Spec"}', custom_field_id: custom_field_textarea.id)
  #   custom_field_textarea.update(fields: '[]')
  #   expect(custom_field_textarea.errors[:fields]).to include('Text Area cannot be removed/updated since it is already in use. ')
  # end
end

describe CustomField, 'scopes' do
  context 'find custom forms by form title' do
    let!(:custom_field) { create(:custom_field, entity_type: 'Client', form_title: 'Health Record') }
    let!(:other_custom_field) { create(:custom_field, entity_type: 'Client', form_title: 'Prison Record') }
    subject { CustomField.by_form_title('health record') }
    it 'should include custom form like the given form title' do
      is_expected.to include(custom_field)
    end
    it 'should not include custom form unlike the given form title' do
      is_expected.not_to include(other_custom_field)
    end
  end

  context 'client forms' do
    let!(:custom_field) { create(:custom_field, entity_type: 'Client') }
    let!(:other_custom_field) { create(:custom_field, entity_type: 'Partner') }
    subject { CustomField.client_forms }
    it 'should include forms with client entity type' do
      is_expected.to include(custom_field)
    end
    it 'should not include forms without client entity type' do
      is_expected.not_to include(other_custom_field)
    end
  end

  context 'family forms' do
    let!(:custom_field) { create(:custom_field, form_title: 'Health Record', entity_type: 'Family') }
    let!(:other_custom_field) { create(:custom_field, form_title: 'Prison Record', entity_type: 'Partner') }
    subject { CustomField.family_forms }
    it 'should include forms with family entity type' do
      is_expected.to include(custom_field)
    end
    it 'should not include forms without family entity type' do
      is_expected.not_to include(other_custom_field)
    end
  end

  context 'partner forms' do
    let!(:custom_field) { create(:custom_field, form_title: 'Health Record', entity_type: 'Partner') }
    let!(:other_custom_field) { create(:custom_field, form_title: 'Prison Record', entity_type: 'Client') }
    subject { CustomField.partner_forms }
    it 'should include forms with parnter entity type' do
      is_expected.to include(custom_field)
    end
    it 'should not include forms without parnter entity type' do
      is_expected.not_to include(other_custom_field)
    end
  end

  context 'user forms' do
    let!(:custom_field) { create(:custom_field, form_title: 'Health Record', entity_type: 'User') }
    let!(:other_custom_field) { create(:custom_field, form_title: 'Prison Record', entity_type: 'Partner') }
    subject { CustomField.user_forms }
    it 'should include forms with user entity type' do
      is_expected.to include(custom_field)
    end
    it 'should not include forms without user entity type' do
      is_expected.not_to include(other_custom_field)
    end
  end
end

describe CustomField, 'CONSTANTS' do
  it 'FREQUENCIES' do
    expect(CustomField::FREQUENCIES).to eq(['Daily', 'Weekly', 'Monthly', 'Yearly'])
  end
  it 'ENTITY_TYPES' do
    expect(CustomField::ENTITY_TYPES).to eq(['Client', 'Family', 'Partner', 'User'])
  end
end

describe CustomField, 'callbacks' do
  let!(:frequency_custom_field) { create(:custom_field, entity_type: 'Client', frequency: 'Day', time_of_frequency: 12) }
  let!(:no_frequency_custom_field) { create(:custom_field, entity_type: 'Client', frequency: '', form_title: 'Health Care') }
  context 'set_time_of_frequency' do
    it 'any frequency is chosen then it should have time of frequency' do
      expect(frequency_custom_field.time_of_frequency).to eq(12)
    end
    it 'no frequency is chosen then it should not have time of frequency' do
      expect(no_frequency_custom_field.time_of_frequency).to eq(0)
    end
  end
end
