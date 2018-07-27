class GovernmentFormDecorator < Draper::Decorator
  delegate_all

  def interview_district_name
    find_district_name(interview_district_id)
  end

  def interview_province_name
    find_province_name(interview_province_id)
  end

  def case_worker_name
    client.users.find_by(id: case_worker_id).try(:name)
  end

  def case_worker_phone
    client.users.find_by(id: case_worker_id).try(:mobile)
  end

  def primary_carer_district_name
    find_district_name(primary_carer_district_id)
  end

  def primary_carer_province_name
    find_province_name(primary_carer_province_id)
  end

  def assessment_district_name
    find_district_name(assessment_district_id)
  end

  def assessment_province_name
    find_province_name(assessment_province_id)
  end

  def find_province_name(province_id)
    Province.find_by(id: province_id).try(:name)
  end

  def find_district_name(district_id)
    District.find_by(id: district_id).try(:name)
  end
end
