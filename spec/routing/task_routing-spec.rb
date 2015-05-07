require "rails_helper"

RSpec.describe TaskController, type: :routing do
  describe "routing" do
    it "task to #import" do
      expect(:get => "/task/import").to route_to("task#import")
    end

    it "task to #update" do
      expect(:get => "/taks/update").to route_to("task#update")
    end

  end
end
