require "rails_helper"

RSpec.describe "user auth process", type: :feature do
  before(:each) do
    @club = FactoryGirl.create(:complete_club)
    @user = @club.users.first
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:kakao, {
      provider: "kakao",
      uid: "1234",
      info: {
        name: "John Doe",
        image: "http://donut-ari.herokuapp.com"
      }
    })
  end

  it "lets me sign in with phone number" do
    visit club_path(@club)
    fill_in :user_phone_number, with: @user.phone_number
    click_button "전화번호로 로그인"

    expect(current_path).to eq(club_path(@club))
  end

  it "shows me an error message when try to sign in with invalid phone number" do
    visit club_path(@club)
    fill_in :user_phone_number, with: "00000000000"
    click_button "전화번호로 로그인"

    expect(page).to have_content("전화번호가 잘못되었습니다.")
  end

  it "lets me fail to kakao log in" do
    skip "Omniauth testing limitation"
    OmniAuth.config.mock_auth[:kakao] = :invalid_credentials
    visit club_path(@club)
    find("#kakao-login-btn").click
    expect(page).to have_content("인증에 실패하였습니다.")
  end

  context "when try to log in w/kakao" do
    before(:each) do
      visit club_path(@club)
      find("#kakao-login-btn").click
    end

    it "leads me to phone_number verification page at first log in" do
      expect(page).to have_content("John Doe")
      expect(page).to have_selector("#user_phone_number")
    end

    context "when try to activate an account w/ invalid phone_number" do
      it "show me error message when I submitted an invalid phone_number" do
        fill_in 'user_phone_number', with: "invalid phone_number"
        click_button "인증 문자 보내기"

        expect(page).to have_content("등록된 전화번호가 아닙니다.")
      end
    end

    context "when try to activate an account w/ valid phone_number" do
      before(:each) do
        @mail_receiver = nil
        @invitation_url = nil
        allow_any_instance_of(Authenticates::CreateInvitationService).to receive(:send_invitation_sms) do |service, user, url|
          @mail_receiver = user
          @invitation_url = url
        end

        fill_in 'user_phone_number', with: @user.phone_number
        click_button "인증 문자 보내기"
      end

      it "sends invitation to me" do
        expect(@mail_receiver.phone_number).to eq(@user.phone_number)

        url = URI(@invitation_url)
        expect(url.path.split("/")[2]).to eq("invitations")

        expect(page).to have_content("인증 문자가 전송되었습니다.")
      end

      it "shows me error message when I clicked an invalid invitation link" do
        invitation_url = URI(@invitation_url)
        invitation_url.path += "invalid"

        visit(invitation_url.to_s)
        find("#kakao-login-btn").click

        expect(page).to have_content("카카오톡 인증에 실패하였습니다.")
      end

      it "lets me correct connection between kakao account and phone_number" do
        invitation_url_original = @invitation_url
        another_user = @club.users.second

        find("#kakao-login-btn").click
        fill_in 'user_phone_number', with: another_user.phone_number
        click_button "인증 문자 보내기"

        expect(page).to have_content("인증 문자가 전송되었습니다.")
        expect(@mail_receiver.phone_number).to eq(another_user.phone_number)
        expect(invitation_url_original).not_to eq(@invitation_url)
      end

      context "when requested a ticket twice+" do
        before(:each) do
          @invitation_url_original = @invitation_url

          find("#kakao-login-btn").click
          fill_in 'user_phone_number', with: @user.phone_number
          click_button "인증 문자 보내기"
        end

        it "sends invitation whenever I requested a ticket" do
          expect(page).to have_content("인증 문자가 전송되었습니다.")
          expect(@invitation_url_original).not_to eq(@invitation_url)
        end

        it "shows me error message when I clicked expired invitation link" do
          visit(@invitation_url_original)
          find("#kakao-login-btn").click

          expect(page).to have_content("카카오톡 인증에 실패하였습니다.")
        end
      end

      context "when user is activated" do
        before(:each) do
          visit(@invitation_url)
        end

        context "when user logged in without remember me" do
          before(:each) do
            find("#kakao-login-btn").click
          end

          it "lets me activate my account to click invitation link" do
            expect(page).to have_content("카카오톡 인증에 성공하였습니다.")
          end

          it "redirects me to redirect_url of invitation link" do
            expect(current_path).to eq(club_path(@club))
          end

          it "lets me sign out" do
            click_link("Logout")
            expect(current_path).to eq(club_sign_in_path(@club))
          end

          context "when user logged in" do
            it "leads me to not auth page when I logged in" do
              visit club_path(@club)
              expect(current_path).to eq(club_path(@club))
            end
          end
        end

        context "when user logged in with remember me" do
          before(:each) do
            find("#remember-me").set(true)
            fill_in(:user_phone_number, with: @user.phone_number)
            click_button("전화번호로 로그인")
          end

          it "keeps me logged in when restarting browser" do
            expire_cookies
            visit club_path(@club)
            expect(current_path).to eq(club_path(@club))
          end

          it "lets me sign out" do
            click_link("Logout")
            expect(current_path).to eq(club_sign_in_path(@club))
          end
        end
      end
    end
  end
end