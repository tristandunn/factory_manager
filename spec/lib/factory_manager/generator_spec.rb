# frozen_string_literal: true

require "spec_helper"

describe FactoryManager::Generator do
  describe "#generate, with a build strategy" do
    context "with a valid factory" do
      it "builds a record" do
        result = build do |locals|
          locals.user = user
        end

        expect(result.user).to be_a(User)
      end

      it "does not persist the record" do
        result = build do |locals|
          locals.user = user
        end

        expect(result.user).not_to be_persisted
      end
    end

    context "with a factory trait" do
      it "builds a record using the trait" do
        result = build do |locals|
          locals.user = user(:admin, name: "Admin")
        end

        expect(result.user).to have_attributes(name: "Admin", admin: true)
      end
    end

    context "with a number" do
      it "builds multiple records" do
        result = build do |locals|
          locals.users = user(2, :admin, name: "Admin")
        end

        expect(result.users).to contain_exactly(
          an_object_having_attributes(name: "Admin", admin: true),
          an_object_having_attributes(name: "Admin", admin: true)
        )
      end
    end

    context "with custom attributes" do
      it "forwards the custom attributes to the factory" do
        result = build do |locals|
          locals.user = user(name: "Tester")
        end

        expect(result.user).to have_attributes(name: "Tester")
      end
    end

    context "with a sequence" do
      it "generates a sequence as a local" do
        result = build do |locals|
          locals.uuid = sequence(:uuid)
        end

        expect(result.uuid).to match(/\A[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}\z/i)
      end

      it "generates a sequence as an argument" do
        result = build do |locals|
          locals.post = post(uuid: sequence(:uuid))
        end

        expect(result.post.uuid).to match(/\A[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}\z/i)
      end
    end

    context "with an invalid sequence" do
      it "raises a key error" do
        expect do
          build { sequence(:fake) }
        end.to raise_error(KeyError)
      end
    end

    context "with associations" do
      it "allows nesting of associated records" do
        result = build do |locals|
          locals.user = user do
            locals.post = post(title: "User's Post")
          end
        end

        expect(result.post).to have_attributes(
          user:  result.user,
          title: "User's Post"
        )
      end

      it "allows multiple level nesting of associated records" do
        result = build do |locals|
          locals.user_1 = user do
            locals.user_2 = user do
              locals.post = post(title: "User's Post")
            end
          end
        end

        expect(result).to have_attributes(
          user_1: an_instance_of(User),
          user_2: an_instance_of(User),
          post:   an_object_having_attributes(
            user:  result.user_2,
            title: "User's Post"
          )
        )
      end
    end

    context "with an invalid factory" do
      it "raises a no method error" do
        expect do
          build { fake }
        end.to raise_error(NoMethodError)
      end
    end

    def build(&block)
      described_class.new(strategy: :build).generate(&block)
    end
  end

  describe "#generate, with a create strategy" do
    context "with a valid factory" do
      it "creates a record" do
        create do
          user
        end

        expect(User.count).to eq(1)
      end
    end

    context "with a factory trait" do
      it "creates a record using the trait" do
        create do
          user(:admin, name: "Admin")
        end

        expect(User.all).to contain_exactly(
          an_object_having_attributes(name: "Admin", admin: true)
        )
      end
    end

    context "with a number" do
      it "creates multiple records" do
        create do
          user(2, :admin, name: "Admin")
        end

        expect(User.all).to contain_exactly(
          an_object_having_attributes(name: "Admin", admin: true),
          an_object_having_attributes(name: "Admin", admin: true)
        )
      end
    end

    context "with custom attributes" do
      it "forwards the custom attributes to the factory" do
        create do
          user(name: "Tester")
        end

        expect(User.all).to contain_exactly(
          an_object_having_attributes(name: "Tester")
        )
      end
    end

    context "with associations" do
      it "allows nesting of associated records" do
        create do
          user do
            post(title: "User's Post")
          end
        end

        expect(User.all).to contain_exactly(
          an_object_having_attributes(
            posts: [an_object_having_attributes(title: "User's Post")]
          )
        )
      end

      it "allows multiple level nesting of associated records" do
        create do
          user do
            user do
              post(title: "User's Post")
            end
          end
        end

        expect(User.all).to contain_exactly(
          an_object_having_attributes(
            posts: []
          ),
          an_object_having_attributes(
            posts: [an_object_having_attributes(title: "User's Post")]
          )
        )
      end

      it "supports nested factories" do
        create do
          admin_user do
            post(title: "Admin's Post")
          end
        end

        expect(User.all).to contain_exactly(
          an_object_having_attributes(
            admin: true,
            posts: [an_object_having_attributes(title: "Admin's Post")]
          )
        )
      end

      it "supports factory aliases" do
        create do
          super_admin do
            post(title: "Admin's Post")
          end
        end

        expect(User.all).to contain_exactly(
          an_object_having_attributes(
            admin: true,
            posts: [an_object_having_attributes(title: "Admin's Post")]
          )
        )
      end
    end

    context "with local variables" do
      it "returns an object with local variable assignments" do
        result = create do |locals|
          user do
            locals.admin = user(:admin)

            locals.user = user(name: "Local User") do
              locals.post = post(title: "User's Post")
            end

            locals.announcement = post(user: locals.admin)
          end
        end

        expect(result).to have_attributes(
          admin:        an_object_having_attributes(admin: true),
          announcement: an_object_having_attributes(user: result.admin),
          post:         an_object_having_attributes(title: "User's Post"),
          user:         an_object_having_attributes(name: "Local User")
        )
      end
    end

    context "with an invalid factory" do
      it "raises a no method error" do
        expect do
          create { fake }
        end.to raise_error(NoMethodError)
      end
    end

    def create(&block)
      described_class.new(strategy: :create).generate(&block)
    end
  end
end
