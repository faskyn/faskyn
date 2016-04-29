require "rails_helper"
#require "pry"

describe StaticPagesController do

  context "home" do
    before do
      get :home
    end
 
    it { is_expected.to respond_with 200 }
    it { is_expected.to render_template :home }
  end

  context "about" do
    before do
      get :about
    end
 
    it { is_expected.to respond_with 200 }
    it { is_expected.to render_template :about }
  end

  context "privacy policy" do
    before do
      get :privacypolicy
    end
 
    it { is_expected.to respond_with 200 }
    it { is_expected.to render_template :privacypolicy }
  end

  context "help" do
    before do
      get :help
    end
 
    it { is_expected.to respond_with 200 }
    it { is_expected.to render_template :help }
  end
end
