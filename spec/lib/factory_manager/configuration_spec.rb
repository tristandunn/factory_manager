# frozen_string_literal: true

require "spec_helper"

describe FactoryManager::Configuration do
  let(:instance) { described_class.new }

  describe "#alias_name" do
    subject { instance.alias_name }

    it { is_expected.to eq(:alias) }
  end

  describe "#alias_name=" do
    it "converts value to a symbol" do
      instance.alias_name = "custom_alias_name"

      expect(instance.alias_name).to eq(:custom_alias_name)
    end
  end
end
