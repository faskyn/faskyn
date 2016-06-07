require "rails_helper"

describe ApplicationHelper do

  describe "has profile?"

  describe "find links" do

    it "recognizes and returns the link if there is protocol" do
      text = "Check out this site: www.faskyn.com"
      expect(helper.find_links(text)).to eq('Check out this site: <a href="http://www.faskyn.com" target="_blank">www.faskyn.com</a>')
    end

    it "returns the original text if there is no protocol" do
      text = "Check out this site: faskyn.com"
      expect(helper.find_links(text)).to eq("Check out this site: faskyn.com")
    end
  end

  describe "url with protocol" do

    context "with http tag" do

      it "returns the original" do
        url = "http://faskyn.com"
        expect(url_with_protocol(url)).to eq("http://faskyn.com")
      end
    end

    context "without http tag" do
      it "returns a new with http tag" do
        url = "faskyn.com"
        expect(url_with_protocol(url)).to eq("http://faskyn.com")
      end
    end
  end

  describe "bootstrap alert class for flash type" do

    it "returns success type" do
      flash_type = :success
      expect(helper.bootstrap_alert_class_for(flash_type)).to eq("alert-success")
    end
  end
  
  describe "human model name" do  

    it "returns the formatted name" do
      notifiable_type = "ProductCustomer"
      expect(helper.human_model_name(notifiable_type)).to eq("product customer")
    end
  end
end