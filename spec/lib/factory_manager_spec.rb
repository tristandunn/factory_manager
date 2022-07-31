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

    context "with a registered manager" do
      subject(:build) { described_class.build(name) }

      let(:name) { :example }

      let(:manager) do
        proc do |locals|
          locals.user = user
        end
      end

      before do
        described_class.register(name, &manager)
      end

      it "creates a generator with a build strategy" do
        build

        expect(described_class::Generator).to have_received(:new)
          .with(strategy: :build)
      end

      it "generates with the registered manager block" do # rubocop:disable RSpec/MultipleExpectations
        build

        expect(generator).to have_received(:generate) do |&passed_block|
          expect(passed_block).to eq(manager)
        end
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

    context "with a registered manager" do
      subject(:create) { described_class.create(name) }

      let(:name) { :example }

      let(:manager) do
        proc do |locals|
          locals.user = user
        end
      end

      before do
        described_class.register(name, &manager)
      end

      it "creates a generator with a create strategy" do
        create

        expect(described_class::Generator).to have_received(:new)
          .with(strategy: :create)
      end

      it "generates with the registered manager block" do # rubocop:disable RSpec/MultipleExpectations
        create

        expect(generator).to have_received(:generate) do |&passed_block|
          expect(passed_block).to eq(manager)
        end
      end
    end
  end

  describe ".register" do
    subject(:register) { described_class.register(name, &block) }

    let(:block)     { -> {} }
    let(:generator) { instance_double(described_class::Generator) }
    let(:name)      { :example }

    before do
      allow(generator).to receive(:generate)
      allow(described_class::Generator).to receive(:new).and_return(generator)
    end

    it "registers the manager" do
      register

      expect(described_class.managers).to eq(name => block)
    end

    context "with a duplicate manager" do
      it "raises an ArgumentError" do
        register

        expect { described_class.register(name, &block) }.to raise_error(
          ArgumentError,
          %("#{name}" manager is already registered.)
        )
      end
    end
  end
end
