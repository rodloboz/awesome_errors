# frozen_string_literal: true

RSpec.describe AwesomeErrors::Error do
  describe "#initialize" do
    it "initializes with a key keyword arg and default values for code, message, and metadata" do
      e = described_class.new(key: "attr_key")

      expect(e.key).to eq("attr_key")
      expect(e.code).to eq(:invalid)
      expect(e.message).to eq("is invalid")
      expect(e.metadata).to eq({})
    end

    it "initializes with key, code, message, and metadata keyword args" do
      e = described_class.new(
        key: "attr_key",
        code: :blank,
        message: "cannot be blank",
        metadata: { "key" => "value" }
      )

      expect(e.key).to eq("attr_key")
      expect(e.code).to eq(:blank)
      expect(e.message).to eq("cannot be blank")
      expect(e.metadata).to eq({ "key" => "value" })
    end

    it "raises an error when initialized with a code that is neither a Symbol or an Integer" do
      expect { described_class.new(key: "attr_key", code: "error_code") }.to raise_error(ArgumentError)
      expect { described_class.new(key: "attr_key", code: 422) }.not_to raise_error
    end
  end

  describe "#full_message" do
    subject(:error) { described_class.new(key: :attr_key, code: :invalid, message: message) }

    let(:message) { "not a valid attribute" }
    let(:key_and_message) { "attr_key not a valid attribute" }

    it "returns the expected message" do
      expect(error.full_message).to eq(key_and_message)
    end

    context "when include_key is set to false" do
      it "returns the message without the key" do
        expect(error.full_message(include_key: false)).to eq(message)
      end
    end
  end

  describe "#to_hash" do
    it "returns an Hash representation of the error" do
      e = described_class.new(
        key: "attr_key",
        code: :blank,
        message: "cannot be blank",
        metadata: { "key" => "value" }
      )
      expected = {
        key: "attr_key",
        code: :blank,
        message: "cannot be blank",
        metadata: { "key" => "value" }
      }

      expect(e.to_hash).to eq(expected)
    end

    context "with full_messages argument set to true" do
      it "returns an Hash representation of the error with the full message" do
        e = described_class.new(
          key: "attr_key",
          code: :blank,
          message: "cannot be blank",
          metadata: { "key" => "value" }
        )
        expected = {
          key: "attr_key",
          code: :blank,
          message: "attr_key cannot be blank",
          metadata: { "key" => "value" }
        }

        expect(e.to_hash(full_message: true)).to eq(expected)
      end
    end
  end

  describe "#==" do
    subject(:error) do
      described_class.new(
        key: :attr_key,
        code: :too_long,
        message: "is too long",
        metadata: { "a_key" => "a_value" }
      )
    end

    it "returns false when other is not of the same kind" do
      expect(error == "Object").to be(false)
    end

    it "returns false when one of key, code, message, or metadata is not equal" do
      other = described_class.new(
        key: :attr_key,
        code: :too_long,
        message: "is too long",
        metadata: { "a_key" => "a_different_value" }
      )
      expect(error == other).to be(false)
    end

    it "returns true when key, code, message, or metadata are equal" do
      other = described_class.new(
        key: :attr_key,
        code: :too_long,
        message: "is too long",
        metadata: { "a_key" => "a_value" }
      )
      expect(error == other).to be(true)
    end
  end
end
