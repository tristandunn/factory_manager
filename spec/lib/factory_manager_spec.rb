# frozen_string_literal: true

require "spec_helper"

describe FactoryManager do
  describe ".build" do
    subject(:build) { described_class.build(&block) }

    let(:block)     { -> {} }
    let(:generator) { instance_double(described_class::Generator) }

    before do
      allow(generator).to receive(:generate)
      allow(described_class::Generator).to receive(:new).and_return(generator)
    end

    it "creates a generator with a build strategy" do
      build

      expect(described_class::Generator).to have_received(:new)
        .with(strategy: :build)
    end

    it "generates with the provided block" do # rubocop:disable RSpec/MultipleExpectations
      build

      expect(generator).to have_received(:generate) do |&passed_block|
        expect(passed_block).to eq(block)
      end
    end
  end

  describe ".create" do
    subject(:create) { described_class.create(&block) }

    let(:block)     { -> {} }
    let(:generator) { instance_double(described_class::Generator) }

    before do
      allow(generator).to receive(:generate)
      allow(described_class::Generator).to receive(:new).and_return(generator)
    end

    it "creates a generator with a create strategy" do
      create

      expect(described_class::Generator).to have_received(:new)
        .with(strategy: :create)
    end

    it "generates with the provided block" do # rubocop:disable RSpec/MultipleExpectations
      create

      expect(generator).to have_received(:generate) do |&passed_block|
        expect(passed_block).to eq(block)
      end
    end
  end

  describe ".configure" do
    subject { described_class }

    it "yields the configuration" do
      expect do |block|
        described_class.configure(&block)
      end.to yield_with_args(described_class.configuration)
    end
  end

  describe ".configuration" do
    let(:configuration) { double }

    before do
      described_class.instance_variable_set("@configuration", nil)

      allow(FactoryManager::Configuration).to receive(:new).and_return(configuration)
    end

    after do
      described_class.instance_variable_set("@configuration", nil)
    end

    it "initializes a configuration object" do
      described_class.configuration

      expect(FactoryManager::Configuration).to have_received(:new)
    end

    it "memoizes the configuration" do
      2.times { described_class.configuration }

      expect(FactoryManager::Configuration).to have_received(:new).once
    end

    it "returns the configuration" do
      expect(described_class.configuration).to eq(configuration)
    end
  end
end
