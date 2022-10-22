# frozen_string_literal: true

RSpec.describe AwesomeErrors do
  it "has a version number" do
    expect(AwesomeErrors::VERSION).not_to be_nil
  end

  describe ".included" do
    subject(:instance) { test_class.new }

    let(:test_class) do
      Class.new do
        include AwesomeErrors
      end
    end

    it "adds errors to the included class" do
      expect(instance.errors).to be_a(AwesomeErrors::Errors)
      expect(instance.errors).to be_empty

      instance.errors.add("attr1")

      expect(instance.errors).not_to be_empty
    end
  end
end
