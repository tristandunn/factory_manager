# factory_manager [![Build Status](https://github.com/tristandunn/factory_manager/workflows/CI/badge.svg)](https://github.com/tristandunn/factory_manager/actions?query=workflow%3ACI)

A factory manager of factory bots.

#### Why?

Creating a deeply nested set of records for seeding or testing can be difficult.
factory_manager creates a DSL based on available [factory_bot][] factories,
allowing deeply nested records to be created easily.

## Example

Create a forum, with a single category, a first post for the category, post with
a sequence generated title, an administrative user, and one-hundred approved
posts by the administrator. Then create a featured category with a single post.

```ruby
result = FactoryManager.create do |locals|
  forum do
    category(name: "News") do
      post(title: "First!")
      post(title: generate(:title))

      locals.administrator = user(:admin)

      post(100, :approved, user: locals.administrator)
    end

    featured_category do
      post
    end
  end
end

result.administrator
# => User(id: 1, name: "DHH", admin: true)
result.administrator.posts.count
# => 100
result.administrator.forum.categories.first.posts.count
# => 102
```

<details>
  <summary>View the factories for the example.</summary>

```ruby
FactoryBot.defined do
  factory :forum do
    name { "Ruby on Rails" }
  end

  factory :category do
    association :forum

    name { "Announcements" }

    factory :featured_category do
      featured { true }
    end
  end

  factory :user do
    association :forum

    name { "DHH" }

    trait :admin do
      admin { true }
    end
  end

  factory :post do
    association :category
    association :user

    title { "How to install Ruby." }

    trait :approved do
      approved { true }
    end
  end

  sequence(:seed) { "Title ##{rand}" }
end
```
</details>

<details>
  <summary>View the example with inline comments.</summary>

```ruby
# Starts a manager that will create records. Alternatively user
# +FactoryManager.build+ to build records.
result = FactoryManager.create do |locals|
  # Creates a +Forum+ record using the default attributes from the factory.
  forum do
    # Creates a +Category+ record with the default attributes but overrides the
    # name. The +category.forum+ association will automatically be set to the
    # +Forum+ record created above.
    category(name: "News") do
      # Create a +Post+ record with a custom title, automatically setting the
      # +post.category+ association to the news category created above.
      post(title: "First!")

      # Create a +Post+ record with a sequence generated title, also automatically
      # setting the # +post.category+ association to the news category created above.
      post(title: generate(:title))

      # Create a +User+ record using the +:admin+ trait. The +user.forum+
      # association will automatically be set to the +Forum+ created above but
      # a category will not be assigned. The +locals.administrator+ assignment
      # will result in the user being available on the +result+ object.
      locals.administrator = user(:admin)

      # Create one-hundred +Post+ records using the +:approved+ trait setting
      # the +post.user+ association to the administrator user created above and
      # the +post.category+ to the news category created above.
      post(100, :approved, user: locals.administrator)

      # Create a +Category+ using the +featured_category+ factory and it
      # automatically knows the parent factory is a +category+ to correctly
      # associate child records, such as the single post created in it.
      featured_category do
        post
      end
    end
  end
end
```
</details>

## License

factory_manager uses the MIT license. See LICENSE for more details.

[factory_bot]: https://github.com/thoughtbot/factory_bot
