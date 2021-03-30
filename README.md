Customize from [enumize](https://github.com/huacnlee/enumize)

# EnumRender
Extend methods enum to I18n enum in Rails


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'enum_render', "~> 0.2"
```

And then execute:

    $ bundle install

## Usage

```ruby
  # app/model/event.rb
class Event
  enum status: {pending: 0, approved: 1, declined: 2}
end
```

In I18n translate file:
```yaml
# config/locales/en.yml
en:
  enums:
    event:
      status:
        pending: "Pending"
        approved: "Approved"
        declined: "Declined"

# config/locales/ja.yml
ja:
  enums:
    event:
      status:
      pending: "保留中"
      approved: "承認済み"
      declined: "辞退"
```
We have methods: `Event.statuses` and `Event.first.status`

After install we have methods:

```ruby
[2] pry(main)> Event.status_options
[{"key"=>"pending", "value"=>"保留中"}, {"key"=>"approved", "value"=>"承認済み"}, {"key"=>"declined", "value"=>"辞退"}]
```

```ruby
[6] pry(main)> Event.first.status_option
{"key"=>"approved", "value"=>"承認済み"}
```

```ruby
[9] pry(main)> Event.first.status_name
=> "承認済み"
```

```ruby
[8] pry(main)> Event.first.status_value
=> 1
```

```ruby
[10] pry(main)> Event.status_select
=> [["保 留 中 ", "pending"], ["承 認 済 み ", "approved"], ["辞 退 ", "declined"]]
```
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EnumRender project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sangvo/enum_render/blob/master/CODE_OF_CONDUCT.md).
