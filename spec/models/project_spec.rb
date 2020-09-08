require "spec_helper"

RSpec.describe Project, type: :model do
  describe "default scope and draft projects" do
    describe "project.all show no projects on create" do
      it "not visible when created" do
        Project.create(name: "Name 1", note: "Note 1")
        Project.create(name: "Name 2", note: "Note 2")
        
        expect(Project.all.count).to eq(0)
      end

      it "projects are visible when updated and valid" do
        proj1 = Project.create(name: "Name 1", note: "Note 1")
        proj1.name = "Name 11"
        proj1.save
        
        expect(Project.all.count).to eq(1)
      end
    end
  end
end