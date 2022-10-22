# frozen_string_literal: true

RSpec.describe AwesomeErrors::Errors do
  subject(:errors) { described_class.new }

  describe "#add" do
    it "adds an error" do
      expect(errors.empty?).to be(true)

      errors.add("attr")

      expect(errors.empty?).to be(false)
    end

    it "adds an error with default :invalid code and message" do
      errors.add("attr")

      expect(errors.first.key).to eq(:attr)
      expect(errors.first.code).to eq(:invalid)
      expect(errors.first.message).to eq("is invalid")
    end

    it "adds an error with a code, a message, and metadata" do
      errors.add("attr", code: :too_long, message: "is too long", metadata: { "attr" => "value" })

      expect(errors.first.key).to eq(:attr)
      expect(errors.first.code).to eq(:too_long)
      expect(errors.first.message).to eq("is too long")
      expect(errors.first.metadata).to eq({ "attr" => "value" })
    end
  end

  describe "#[]" do
    it "returns an array of errors for the given key" do
      errors.add("attr1", code: :invalid, message: "is invalid")
      errors.add("attr2", code: :too_long, message: "is too long")
      errors.add("attr1", code: :too_short, message: "is too short")

      expect(errors[:attr1]).to match_array(["is invalid", "is too short"])
    end
  end

  describe "#merge!" do
    it "merges the errors from other" do
      errors.add("attr1", code: :invalid, message: "is invalid")

      other = described_class.new
      other.add("attr1", code: :too_long, message: "is too long")
      other.add("attr2", code: :too_long, message: "is too long")

      errors.merge!(other)

      expect(errors.size).to eq(3)
      expect(errors.messages_for(:attr1)).to match_array(["is invalid", "is too long"])
    end

    it "doesn't duplicate errors" do
      errors.add("attr1", code: :invalid, message: "is invalid")

      other = described_class.new
      other.add("attr1", code: :invalid, message: "is invalid")
      other.add("attr2", code: :too_long, message: "is too long")

      errors.merge!(other)

      expect(errors.size).to eq(2)
      expect(errors.messages_for(:attr1)).to match_array(["is invalid"])
      expect(errors.messages_for(:attr2)).to match_array(["is too long"])
    end
  end

  describe "#import" do
    it "adds an error" do
      errors.add("attr1", code: :invalid, message: "is invalid")
      error = AwesomeErrors::Error.new(key: :attr1, code: :too_long, message: "is too long")

      errors.import(error)

      expect(errors.size).to eq(2)
      expect(errors.messages_for(:attr1)).to match_array(["is invalid", "is too long"])
    end

    it "doesn't add a duplicate error" do
      errors.add("attr1", code: :invalid, message: "is invalid")
      error = AwesomeErrors::Error.new(key: :attr1, code: :invalid, message: "is invalid")

      errors.import(error)

      expect(errors.size).to eq(1)
      expect(errors.messages_for(:attr1)).to match_array(["is invalid"])
    end
  end

  describe "#messages_for" do
    it "returns an array of messages for the given key" do
      errors.add("attr1", code: :invalid, message: "is invalid")
      errors.add("attr2", code: :too_long, message: "is too long")
      errors.add("attr1", code: :too_short, message: "is too short")

      expect(errors[:attr1]).to match_array(["is invalid", "is too short"])
    end
  end

  describe "#keys" do
    it "returns an array with the keys of the added errors" do
      errors.add("attr1")
      errors.add("attr2")
      errors.add("attr1", code: :too_short, message: "is too short")

      expect(errors.keys).to match_array(%i[attr1 attr2])
    end
  end

  describe "#each" do
    let(:expected_errors) do
      [
        {
          key: :attr1,
          code: :too_long,
          message: "is too long"
        },
        {
          key: :attr2,
          code: :taken,
          message: "is already taken"
        }
      ]
    end

    it "iterates through each error object" do
      errors.add("attr1", code: :too_long, message: "is too long")
      errors.add("attr2", code: :taken, message: "is already taken")

      i = 0
      errors.each do |error|
        expect(error.key).to eq(expected_errors[i][:key])
        expect(error.code).to eq(expected_errors[i][:code])
        expect(error.message).to eq(expected_errors[i][:message])
        i += 1
      end
    end
  end

  describe "#any?" do
    it "returns false if there are no errors" do
      expect(errors.any?).to be(false)
    end

    it "returns true if there are errors" do
      errors.add("attr")

      expect(errors.any?).to be(true)
    end
  end

  describe "#to_hash" do
    it "returns an Hash of keys with an array of their error messages" do
      errors.add("attr1", code: :too_long, message: "is too long")
      errors.add("attr2", code: :taken, message: "is already taken")
      errors.add("attr1", code: :invalid, message: "is invalid")

      expect(errors.to_hash).to eq(
        {
          attr1: ["is too long", "is invalid"],
          attr2: ["is already taken"]
        }
      )
    end

    context "with full_messages argument set to true" do
      it "returns an Hash of keys with an array of their error full messages" do
        errors.add("attr1", code: :too_long, message: "is too long")
        errors.add("attr2", code: :taken, message: "is already taken")
        errors.add("attr1", code: :invalid, message: "is invalid")

        expect(errors.to_hash(full_messages: true)).to eq(
          {
            attr1: ["attr1 is too long", "attr1 is invalid"],
            attr2: ["attr2 is already taken"]
          }
        )
      end
    end
  end

  describe "#messages" do
    it "returns an Hash of keys with an array of their error messages" do
      errors.add("attr1", code: :too_long, message: "is too long")
      errors.add("attr2", code: :taken, message: "is already taken")
      errors.add("attr1", code: :invalid, message: "is invalid")

      expect(errors.messages[:attr1]).to eq(["is too long", "is invalid"])
      expect(errors.messages[:attr2]).to eq(["is already taken"])
    end

    it "returns an empty array for a key that does not exist" do
      expect(errors.messages[:inexisting]).to eq([])
    end
  end
end
