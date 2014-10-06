require "rails_helper"

RSpec.describe "kakao auth process", type: :feature do
  before(:each) do
    @user = FactoryGirl.create(:user)
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

  it "lets me fail to kakao log in" do
    pending("not implemented feature, see issue #201. If you resolve issue #201, then remove pending")

    OmniAuth.config.mock_auth[:kakao] = :invalid_credentials
    visit("/")
    find("#login-form a").click
  end

  context "when try to log in w/kakao" do
    before(:each) do
      visit("/")
      find("#login-form a").click
    end

    it "leads me to email verification page at first log in" do
      expect(page).to have_content("John Doe")
      expect(page).to have_selector("#account_activation_email")
    end

    context "when try to activate an account w/ invalid email" do
      it "show me error message when I submitted an invalid email" do
        fill_in 'account_activation_email', with: "invalid email"
        click_button "인증 메일 보내기"

        expect(page).to have_content("등록된 이메일이 아닙니다.")
      end
    end

    context "when try to activate an account w/ valid email" do
      before(:each) do
        @mail_receiver = nil
        @activation_url = nil
        allow_any_instance_of(UserActivator).to receive(:send_ticket_mail) do |activator, user, url|
          @mail_receiver = user
          @activation_url = url
        end

        fill_in 'account_activation_email', with: @user.email
        click_button "인증 메일 보내기"
      end

      it "sends activation ticket to me" do
        expect(@mail_receiver).to eq(@user)

        url = URI(@activation_url)
        expect(url.path.split("/")[1]).to eq("activations")

        expect(page).to have_content("인증 메일이 전송되었습니다.")
      end

      it "shows me error message when I clicked an invalid activation link" do
        visit(@activation_url + "invalid")
        expect(page).to have_content("카카오톡 인증에 실패하였습니다.")
      end

      it "sends activation ticket whenever I requested a ticket" do
        activation_url_original = @activation_url

        find("#login-form a").click
        fill_in 'account_activation_email', with: @user.email
        click_button "인증 메일 보내기"

        expect(page).to have_content("인증 메일이 전송되었습니다.")
        expect(activation_url_original).not_to eq(@activation_url)
      end

      it "lets me correct connection between kakao account and email" do
        activation_url_original = @activation_url
        another_user = FactoryGirl.create(:user, username: "Mary")

        find("#login-form a").click
        fill_in 'account_activation_email', with: another_user.email
        click_button "인증 메일 보내기"

        expect(page).to have_content("인증 메일이 전송되었습니다.")
        expect(@mail_receiver).to eq(another_user)
        expect(activation_url_original).not_to eq(@activation_url)
      end

      context "when user is activated" do
        before(:each) do
          visit(@activation_url)
        end

        it "lets me activate my account to click activation link" do
          # need actual test, because need auth hash to activate an account actually.
          expect(page).to have_content("카카오톡 인증에 성공하였습니다.")
        end

        context "when user logged in" do
          it "leads me to not auth page when I logged in" do
            find("#login-form a").click

            visit("/")
            expect(current_path).to eq("/")
          end
        end
      end
    end
  end
end