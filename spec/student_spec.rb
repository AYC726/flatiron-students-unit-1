describe Student do
  context "database operations" do
    before(:each) do
      Student.reset_all
      @student = Student.new.tap { |s| s.name = "Anything But Scott Oh Nevermind" }
    end

    describe ".insert" do
      it "persists the student to the database" do
        @student.should respond_to(:insert)
        @student.insert.should eq(true)
      end
    end

    describe ".update" do
      it "updates the student in the database" do
        @student.insert
        @student.name = "Catherine"
        @student.update.should eq(true)
      end
    end

    describe ".save" do
      it "chooses the right thing on first save" do
        @student.should_receive(:insert)
        @student.save
      end
      it "chooses the right thing after saving" do
        @student.save
        @student.name = "Steven"
        @student.should_receive(:update)
        @student.save
      end
    end

    describe "::find" do
      it "finds the student from the database" do
        @student.save
        loaded = Student.find(@student.id)
        loaded.name.should eq(@student.name)
        loaded.id.should eq(@student.id)
        @student.name = "new name"
        @student.save
        updated = Student.find(@student.id)
        updated.name.should eq(@student.name)
      end

    end

  end
end


describe "Student" do

  before(:each) do
    Student.reset_all
  end

  it "can be instantiated" do
    Student.new.should be_an_instance_of(Student)
  end

  # These tests are pretty abstract, feel free to 
  # hardcode them if you don't want to design your model
  # as abstractly.
  describe "student properties" do
    let(:student) { Student.new }

    context 'creating a new student' do
      it 'has properties based on an attributes hash' do
        Student.attributes_for_db.each do |attribute|
          student.send("#{attribute}=", "Testing #{attribute}")
        end
        student.save

        test_student = Student.find(student.id)

        Student.attributes_for_db.each do |attribute|
          test_student.send(attribute).should eq("Testing #{attribute}")
        end
      end
    end

    context 'update a student' do
      it 'has properties based on an attributes hash' do
        Student.attributes_for_db.each do |attribute|
          student.send("#{attribute}=", "Original #{attribute}")
        end
        student.save

        Student.attributes_for_db.each do |attribute|
          student.send("#{attribute}=", "Updated #{attribute}")
        end
        student.save

        test_student = Student.find(student.id)

        Student.attributes_for_db.each do |attribute|
          test_student.send(attribute).should eq("Updated #{attribute}")
        end
      end
    end
  end

  describe "::all" do
    it "keeps track of the students that have been created" do
      Student.reset_all

      ('a'..'c').each do |l|
        s = Student.new
        s.name = l
        s.save
      end

      Student.all.count.should eq(3)
      Student.all.collect { |s| s.name }.should include('a')
    end
  end

  describe "::reset_all" do
    it "resets the set of created students" do
      10.times do
        Student.new
      end

      Student.reset_all
      Student.all.count.should eq(0)
    end
  end

  context "with an ID" do
    let(:student) { Student.new }

    before(:each) do
      Student.reset_all
    end

    it "has an ID" do
      student.should respond_to(:id)
    end

    it "auto-assigns an id" do
      student.name = "Becky"
      student.save
      student.id.should eq(1)

      s2 = Student.new
      s2.save
      s2.id.should eq(2)
    end

    describe "::delete" do
      it "can be deleted" do
        student.name = "Steve"
        5.times do
          Student.new.tap { |s| s.name = "Clara" }
        end

        student.delete
        Student.all.collect { |s| s.name }.should_not include("Steve")
      end
    end
  end
end

# These tests are pretty abstract, feel free to 
# hardcode them if you don't want to design your model
# as abstractly.
describe "Student", "finders" do
  let(:student){Student.new}
  
  before(:each) do
    Student.reset_all
  end

  it 'has a finder for every attribute' do
    Student.attributes.each do |attribute|
      Student.should respond_to("find_by_#{attribute}")
    end
  end

  it 'finds a student by every attribute' do
    Student.attributes_for_db.each do |attribute|
      student.send("#{attribute}=", "Find #{attribute}")
    end
    student.save
    
    Student.attributes_for_db.each do |attribute|
      Student.send("find_by_#{attribute}", "Find #{attribute}").first.should eq(student)
    end
  end
end