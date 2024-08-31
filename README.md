# Timelines
I use this `Ephemeral` pattern frequently across projects to have a simple pattern for tracking the lifecycle of a record, whether it is currently active/ended/draft, and soft-deleting records to keep an audit trail.

## Usage
For an ActiveRecord model that has `started_at` and `ended_at` columns (datetime), include `Ephemeral` to give it ephemeral behavior.

```ruby
include Timelines::Ephemeral
```

This gives you the following Instance methods:
```ruby
# Returns an AuditTrail object containing the resource and any associated events, in chronological order
.audit_trail

# Returns an AuditTrail object containing the resource and any associated events, in reverse order
.audit_trail(reverse: true)

# Returns a boolean indicating whether the record is currently active
.active?

# Returns a boolean indicating whether the record was active at a given date
.active_at?(date)

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

Enables defining conditions for automated logging of events for a record's many lifecycle events, which are logged through an ActiveJob adapter.

The parameters are an optional `on:` param (which defaults to `before_save`), and 4 procs that define the resource, actor, event, and conditions for logging the event. Conditions can be used to ensure an event only fires on a new record, or on a record that has been updated in a specific way/meets certain criteria to be eligible to log the event.
```ruby
include Timelines::TracksEvents
tracks_timelines_event :create_event,
  resource: ->(instance) { instance },
  on: :before_create,
  actor: ->(instance) { instance.created_by },
  event: ->(instance) { "instance::create" },
  conditions: ->(instance) { instance.new_record? }
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "timelines"
```

## Migrations
Run this command to create a `timelines_events` table in your project:
```ruby
bin/rails generate timelines:install
```

Then you can call [whatever method] to get events attached to the record.

## Contributing
Pull requests/issues are welcome on GitHub

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
