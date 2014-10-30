require "rails_helper"

RSpec.describe User, :type => :model do
  it "should remove dashes in phone_number before save" do
    user = FactoryGirl.build(:user)
    user.phone_number = "010-1234-1234"
    user.save!

    expect(user.phone_number).to eq("01012341234")

    user.phone_number = "010-123-1234"
    user.save!

    expect(user.phone_number).to eq("0101231234")
  end

  it "should strip columns before save" do
    user = FactoryGirl.build(:user)
    user.phone_number = "  010-1234-1234  "
    user.username = " user name "
    user.email = " test @ test.com "
    user.save!

    user.strip!
    expect(user.phone_number).to eq("01012341234")
    expect(user.username).to eq("user name")
    expect(user.email).to eq("test @ test.com")
  end

  describe "#responsed_to?" do
    it "should return whether users responsed to notice" do
      user = FactoryGirl.create(:user)
      notice = FactoryGirl.create(:notice)

      expect(user.responsed_to?(notice)).to eq(false)

      response = Response.create!(user: user, notice: notice, status: "yes")
      expect(user.responsed_to?(notice)).to eq(true)
    end
  end

  describe "#response_status" do
    context "user didn't response to notice" do
      it "should return status, users responsed to notice" do
        user = FactoryGirl.create(:user)
        notice = FactoryGirl.create(:notice)

        expect(user.response_status(notice)).to eq("not")
      end
    end

    context "user responsed 'go' to notice" do
      it "should return satus, users responsed to notice" do
        user = FactoryGirl.create(:user)
        notice = FactoryGirl.create(:notice)
        response = Response.create!(user: user, notice: notice, status: "go")
        expect(user.response_status(notice)).to eq("go")
      end
    end

    context "user responsed 'go' to notice but he/she had to be 'wait'" do
      it "should return satus, users responsed to notice" do
        user = FactoryGirl.create(:user)
        notice = FactoryGirl.create(:notice)
        response = Response.create!(user: user, notice: notice, status: "wait")
        expect(user.response_status(notice)).to eq("wait")
      end
    end
  end


  describe "#activated?" do
    context "user not attempted to sign in" do
      it "should return false for user not attempted to sign in" do
        user = FactoryGirl.create(:user)
        expect(user.activated?).to eq(false)
      end
    end

    context "user attempted to sign in" do
      before(:each) do
        @user = FactoryGirl.create(:user)
      end

      it "should return false for user not activated" do
        expect(@user.activated?).to eq(false)
      end

      it "should return true for activated user" do
        out = Authenticates::CreateInvitationService.new.execute(nil, @user)
        out = Authenticates::ActivateUserService.new.execute(@user, out[:code])
        @user.reload
        expect(@user.activated?).to eq(true)
      end
    end
  end

  describe "#generation_sorted_desc" do
    it "should sort generation descending" do
      user1 = FactoryGirl.create(:user, generation_id: 1)
      user2 = FactoryGirl.create(:user, generation_id: 3)
      user3 = FactoryGirl.create(:user, generation_id: 2)

      expect(User.generation_sorted_desc).to eq([user2, user3, user1])
    end
  end

  describe "#responsed_to_notice" do
    it "should fetch who responsed to notice" do
      notice1 = FactoryGirl.create(:notice)
      notice2 = FactoryGirl.create(:notice)

      user = FactoryGirl.create(:user)
      Response.create!(user: user, notice: notice1, status: "yes")

      expect(User.responsed_to_notice(notice1)).to contain_exactly(user)
      expect(User.responsed_to_notice(notice2)).to be_empty
    end
  end

  describe "#responsed_[Response::STATUSES]" do
    it "should fetch who responsed to notice with given status" do
      notice1 = FactoryGirl.create(:notice)
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      user3 = FactoryGirl.create(:user)

      Response.create!(user: user1, notice: notice1, status: "yes")
      Response.create!(user: user2, notice: notice1, status: "no")
      Response.create!(user: user3, notice: notice1, status: "yes")

      expect(User.responsed_yes(notice1)).to contain_exactly(user1, user3)
      expect(User.responsed_no(notice1)).to contain_exactly(user2)
    end
  end

  describe "#responsed_not_to_notice" do
    it "should fetch who did not response to notice" do
      notice1 = FactoryGirl.create(:notice)
      notice2 = FactoryGirl.create(:notice)

      user = FactoryGirl.create(:user)
      Response.create!(user: user, notice: notice1, status: "yes")

      expect(User.responsed_not_to_notice(notice1)).to be_empty
      expect(User.responsed_not_to_notice(notice2)).to contain_exactly(user)
    end
  end

  describe "#order_by_responsed_at" do
    it "should sort responsed_at ascending" do
      notice1 = FactoryGirl.create(:notice)
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      user3 = FactoryGirl.create(:user)

      Response.create!(user: user1, notice: notice1, status: "yes")
      Response.create!(user: user3, notice: notice1, status: "yes")
      Response.create!(user: user2, notice: notice1, status: "yes")

      expect(User.responsed_yes(notice1).order_by_responsed_at).to eq([user1, user3, user2])
    end
  end

  describe "#order_by_read_at" do
    it "should sort read_at descending" do
      notice1 = FactoryGirl.create(:notice)
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      user3 = FactoryGirl.create(:user)

      user1.read!(notice1)
      user3.read!(notice1)
      user2.read!(notice1)

      expect(notice1.readers.order_by_read_at).to eq([user2, user3, user1])
    end
  end
end