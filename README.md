# Timelines
I use this `Ephemeral` pattern frequently across projects to have a simple pattern for tracking the lifecycle of a record, whether it is currently active/ended/draft, and soft-deleting records to keep an audit trail.

## Usage
For an ActiveRecord model that has `started_at` and `ended_at` columns (datetime), include `Ephemeral` to give it ephemeral behavior.

```ruby
include Timelines::Ephemeral
```

This gives you the following Instance methods:
```ruby
# Returns a boolean indicating whether the record is currently active
.active?

# Sets the record's `started_at` to the current time to indicate that it has started
.start!

# Returns a boolean indicating whether the record has started
.started?

# Sets the record's `ended_at` to the current time to indicate that it has ended
.end!

# Returns a boolean indicating whether the record has ended
.ended?

# Returns a boolean indicating whether the record is currently in a draft state (nil `started_at` and `ended_at`, or `started_at` in the future)
.draft?

# Soft-deletes the record by setting `ended_at` to the current time, removing it from the `.active` scope.
.destroy
```

And the following Class methods:
```ruby
# Soft-deletes all records by setting `ended_at` to the current time, removing them from the `.active` scope.
.self.destroy_all
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "timelines"
```

## Contributing
Pull requests/issues are welcome on GitHub

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
