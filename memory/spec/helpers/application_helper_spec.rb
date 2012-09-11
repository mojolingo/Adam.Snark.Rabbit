require 'spec_helper'

describe ApplicationHelper do
  describe "#twitterized_type" do
    context "with :alert" do
      it "returns 'warning'" do
        helper.twitterized_type(:alert).should be == 'warning'
      end
    end

    context "with :notice" do
      it "returns 'info'" do
        helper.twitterized_type(:notice).should be == 'info'
      end
    end

    context "with :error" do
      it "returns 'error'" do
        helper.twitterized_type(:error).should be == 'error'
      end
    end
  end
end
