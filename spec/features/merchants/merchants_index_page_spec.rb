require 'rails_helper'

RSpec.describe "All users can see a merchants index page", type: :feature do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:inactive_merchant)
  end

  context 'as any kind of user on the system' do
    it 'shows all merchants in the system except disabled ones' do

      visit merchants_path

      within "#merchant-#{@merchant_1.id}" do
        expect(page).to have_link(@merchant_1.name, href: merchant_path(@merchant_1))
        expect(page).to have_content(@merchant_1.city)
        expect(page).to have_content(@merchant_1.state)
        expect(page).to have_content(@merchant_1.created_at)
      end

      within "#merchant-#{@merchant_2.id}" do
        expect(page).to have_link(@merchant_2.name, href: merchant_path(@merchant_2))
        expect(page).to have_content(@merchant_2.city)
        expect(page).to have_content(@merchant_2.state)
        expect(page).to have_content(@merchant_2.created_at)
      end

      expect(page).to_not have_css("#merchant-#{@merchant_3.id}")
    end
  end

  context 'as an admin' do
    it "shows all merchants including disabled ones with proper links" do
      admin = create(:admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit merchants_path

      within "#merchant-#{@merchant_1.id}" do
        expect(page).to have_link(@merchant_1.name, href: admin_merchant_path(@merchant_1))
        expect(page).to have_content(@merchant_1.city)
        expect(page).to have_content(@merchant_1.state)
        expect(page).to have_content(@merchant_1.created_at)
        expect(page).to have_link("Disable")
      end

      within "#merchant-#{@merchant_2.id}" do
        expect(page).to have_link(@merchant_2.name, href: admin_merchant_path(@merchant_2))
        expect(page).to have_content(@merchant_2.city)
        expect(page).to have_content(@merchant_2.state)
        expect(page).to have_content(@merchant_2.created_at)
        expect(page).to have_link("Disable")
      end

      within "#merchant-#{@merchant_3.id}" do
        expect(page).to have_link(@merchant_3.name)
        expect(page).to have_content(@merchant_3.city)
        expect(page).to have_content(@merchant_3.state)
        expect(page).to have_content(@merchant_3.created_at)
        expect(page).to have_link("Enable")
      end
    end

    it 'should take admin to admin merchant show from merch index links' do
      admin = create(:admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit merchants_path
      click_link(@merchant_1.name)
      expect(current_path).to eq(admin_merchant_path(@merchant_1))
    end

    it 'should enable/disable a merchant after corrisponding button has been clicked' do
      admin = create(:admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit merchants_path
      within "#merchant-#{@merchant_1.id}" do
        item_1 = create(:item)
        @merchant_1.items << item_1
        click_link 'Disable'
        expect(current_path).to eq(merchants_path)
        #link should now be to enable to the account
        expect(page).to have_link("Enable")
        @merchant_1.reload
        expect(@merchant_1.enabled).to eq(false)
        expect(@merchant_1.items.last.enabled).to eq(false)
      end
      #flash message isnt occuring within css tag
      expect(page).to have_content("#{@merchant_1.name} is now disabled")

      within "#merchant-#{@merchant_2.id}" do
        item_1 = create(:item)
        @merchant_2.items << item_1
        click_link 'Disable'
        expect(current_path).to eq(merchants_path)
        #link should now be to enable to the account
        expect(page).to have_link("Enable")
        @merchant_2.reload
        expect(@merchant_2.enabled).to eq(false)
        expect(@merchant_2.items.last.enabled).to eq(false)
      end
      #flash message isnt occuring within css tag
      expect(page).to have_content("#{@merchant_2.name} is now disabled")

      within "#merchant-#{@merchant_3.id}" do
        item_1 = create(:inactive_item)
        @merchant_3.items << item_1
        click_link 'Enable'
        expect(current_path).to eq(merchants_path)
        #link should now be to disable to the account
        expect(page).to have_link("Disable")
        @merchant_3.reload
        expect(@merchant_3.enabled).to eq(true)
        expect(@merchant_3.items.last.enabled).to eq(true)
      end
      #flash message isnt occuring within css tag
      expect(page).to have_content("#{@merchant_3.name} is now enabled")
    end
  end

  context 'as a merchant' do
    describe 'attempts to login' do
      it 'should prevent login if disabled' do
        merchant = create(:inactive_merchant)
        visit login_path
        fill_in "email", with: merchant.email
        fill_in "password", with: merchant.password
        click_button "Log In"
        expect(current_path).to eq(login_path)
      end
    end
  end

end
