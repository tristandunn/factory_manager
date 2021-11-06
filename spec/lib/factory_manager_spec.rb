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
end
