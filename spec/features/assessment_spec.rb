describe "Assessment" do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }
  let!(:manager) { create(:user, :manager) }
  let!(:caseworker) { create(:user, :case_worker) }
  let!(:client) { create(:client, :accepted, users: [user]) }
  let!(:fc_case) { create(:case, case_type: 'FC', client: client) }
  let!(:domain) { create(:domain, name: FFaker::Name.name) }

  before do
    login_as(user)
  end

  feature 'Create' do
    before do
      visit new_client_assessment_path(client)
    end

    def add_tasks(n)
      (1..n).each do |time|
        find('.assessment-task-btn').trigger('click')
        fill_in 'task_name', with: 'ABC'
        fill_in 'task_completion_date', with: Date.strptime(FFaker::Time.date).strftime('%B %d, %Y')
        find('.add-task-btn').trigger('click')
        sleep 1
      end
    end

    def with_tasks(n)
      choose('1')
      expect(page).to have_css('.label-danger')
      expect(page).to have_css('.assessment-task-btn')
      add_tasks(n)
    end

    def without_task
      choose('4')
      expect(page).to have_css('.label-success')
      expect(page).not_to have_css('.label-danger')
      expect(page).not_to have_css('.label-warning')
      expect(page).not_to have_css('.label-info')
      expect(page).not_to have_css('.assessment-task-btn')
    end

    scenario 'valid', js: true do
      with_tasks(1)
      without_task

      fill_in 'Reason', with: FFaker::Lorem.paragraph
      fill_in 'Goal', with: FFaker::Lorem.paragraph

      click_link 'Done'
      sleep 1
      expect(page).to have_content(domain.name)
      expect(page.find('.domain-score')).to have_content('4')
      expect(Task.find_by(name: 'ABC').user_id).to eq(user.id)
    end

    scenario  'invalid', js: true do
      choose('1')
      fill_in 'Reason', with: FFaker::Lorem.paragraph

      click_link 'Done'
      expect(page).to have_content('This field is required')
    end

    context 'assessments editable permission' do
      scenario 'user has editable permission' do
        expect(new_client_assessment_path(client)).to have_content(current_path)
      end

      scenario 'user does not have editable permission' do
        user.permission.update(assessments_editable: false)

        visit new_client_assessment_path(client)
        expect(dashboards_path).to have_content(current_path)
      end
    end
  end

  feature 'List' do
    let!(:assessment){ create(:assessment, client: client) }
    let!(:assessment_domain){ create(:assessment_domain, assessment: assessment, domain: domain) }
    let!(:client_1){ create(:client, :accepted, users: [user]) }
    let!(:client_2){ create(:client, :accepted, users: [user]) }
    # let!(:assessment_1){ create(:assessment, created_at: Time.now - 3.months, client: client_1) }
    # let!(:assessment_2){ create(:assessment, created_at: Time.now - 4.months, client: client_2) }
    let!(:last_assessment_domain){ create(:assessment_domain, assessment: assessment_1, domain: domain) }

    let!(:setting) {create(:setting, :monthly_assessment, max_assessment: 6)}
    let!(:assessment_1){ create(:assessment, created_at: Time.now - 3.months, client: client_1) }
    let!(:assessment_2){ create(:assessment, created_at: Time.now - (setting.max_assessment).months, client: client_2) }

    before do
      visit client_assessments_path(client)
    end

    scenario 'view report' do
      expect(page).to have_link('View Report', href: client_assessment_path(client, assessment))
    end

    scenario 'no new assessment' do
      expect(page).not_to have_link('Add New Assessment', href: new_client_assessment_path(client))
    end

    feature 'new assessment is enable for user to create as often as they like' do
      scenario 'after minimum assessment duration' do
        visit client_assessments_path(client_1)
        expect(page).to have_link('Add New Assessment', href: new_client_assessment_path(client_1))
      end
      scenario 'after maximum assessment duration' do
        visit client_assessments_path(client_2)
        expect(page).to have_link('Add New Assessment', href: new_client_assessment_path(client_2))
      end
    end

    context 'assessments readable permission' do
      scenario 'user has readable permission' do
        expect(client_assessments_path(client)).to have_content(current_path)
      end

      scenario 'user does not have readable permission' do
        user.permission.update(assessments_readable: false)
        visit client_assessment_path(client, assessment)
        expect(dashboards_path).to have_content(current_path)
      end
    end

    let!(:client_3){ create(:client, :accepted, users: [user], date_of_birth: 18.years.ago) }
    scenario 'create assessment button is disable for client whose age is over 18' do
      visit client_assessments_path(client_3)
      expect(page).to have_css('#disabled_assessment_button')
    end

  end

  feature 'Update' do
    let!(:assessment){ create(:assessment, client: client) }

    context 'assessments editable permission' do
      scenario 'user has editable permission' do
        visit edit_client_assessment_path(client, assessment)
        expect(edit_client_assessment_path(client, assessment)).to have_content(current_path)
      end

      scenario 'user does not have editable permission' do
        user.permission.update(assessments_editable: false)

        visit edit_client_assessment_path(client, assessment)
        expect(dashboards_path).to have_content(current_path)
      end
    end
  end

  feature 'Update ability of admin/caseworker/manager', js: true do
    let!(:client_4){ create(:client, :accepted, users: [admin, caseworker, manager]) }
    let!(:assessment_4){ create(:assessment, client: client_4, created_at: Time.now - 3.months) }
    let!(:assessment_5){ create(:assessment, client: client_4) }

    before do
      visit root_path
      find("a[href='#{destroy_user_session_path}']").click
    end

    scenario 'admin can edit assessment forever' do
      login_as(admin)
      visit edit_client_assessment_path(client_4, assessment_4)
      expect(edit_client_assessment_path(client_4, assessment_4)).to have_content(current_path)
    end

    scenario 'caseworker can edit assessment within two weeks of creation' do
      login_as(caseworker)
      visit edit_client_assessment_path(client_4, assessment_5)
      expect(edit_client_assessment_path(client_4, assessment_5)).to have_content(current_path)
    end

    scenario 'manager can edit assessment within two weeks of creation' do
      login_as(manager)
      visit edit_client_assessment_path(client_4, assessment_5)
      expect(edit_client_assessment_path(client_4, assessment_5)).to have_content(current_path)
    end

    scenario 'caseworker cannot edit assessment after two weeks of creation' do
      login_as(caseworker)
      visit edit_client_assessment_path(client_4, assessment_4)
      expect(page).to have_content('You are not authorized to access this page.')
    end

    scenario 'manager cannot edit assessment after two weeks of creation' do
      login_as(manager)
      visit edit_client_assessment_path(client_4, assessment_4)
      expect(page).to have_content('You are not authorized to access this page.')
    end

  end
end
