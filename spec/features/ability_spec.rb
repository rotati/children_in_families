feature 'progress_note' do
  let!(:admin){ create(:user, roles: 'admin') }
  let!(:fc_manager){ create(:user, roles: 'fc manager') }
  let!(:kc_manager){ create(:user, roles: 'fc manager') }
  let!(:client){ create(:client, able_state: Client::ABLE_STATES[0], user: fc_manager) }
  let!(:other_client){ create(:client, able_state: Client::ABLE_STATES[0], user: kc_manager) }
  let!(:progress_note){ create(:progress_note, client: client) }
  let!(:other_progress_note){ create(:progress_note, client: other_client) }

  feature 'List' do
    feature 'logged in as Admin' do
      before do
        login_as(admin)
        visit client_progress_notes_path(progress_note.client)
      end
      scenario 'enabled add button' do
        expect(page).not_to have_css('.btn-add.disabled')
      end
      scenario 'enabled edit button' do
        expect(page).not_to have_css('.btn-edit.disabled')
      end
      scenario 'enabled delete button' do
        expect(page).not_to have_css('.btn-delete.disabled')
      end
    end

    feature 'logged in as FC Manager' do
      before do
        login_as(fc_manager)
        visit client_progress_notes_path(progress_note.client)
      end
      scenario 'disabled add button' do
        expect(page).to have_css('.btn-add.disabled')
      end
      scenario 'disabled edit button' do
        expect(page).to have_css('.btn-edit.disabled')
      end
      scenario 'disabled delete button' do
        expect(page).to have_css('.btn-delete.disabled')
      end
    end

    feature 'logged in as KC Manager' do
      before do
        login_as(kc_manager)
        visit client_progress_notes_path(other_progress_note.client)
      end
      scenario 'disabled add button' do
        expect(page).to have_css('.btn-add.disabled')
      end
      scenario 'disabled edit button' do
        expect(page).to have_css('.btn-edit.disabled')
      end
      scenario 'disabled delete button' do
        expect(page).to have_css('.btn-delete.disabled')
      end
    end
  end
end
