# Pragmatic QL

[PragmaticQL](https://github.com/Pobble/pragmatic_ql) simple gem for building constructive/query based JSON API using GET requests.

[![Build Status](https://travis-ci.org/Pobble/pragmatic_ql.svg?branch=master)](https://travis-ci.org/Pobble/pragmatic_ql)

PragmaticQL is more a pragmatic tool and **philosophy** of how to write JSON API where
Frontend constructs what data it needs using GET query.

Gem is not a comprehensive API solution for [Ruby on Rails](https://rubyonrails.org), but we will show you how you
can build one in your Rails application using this gem.


Example of API endpoints

```
GET /student/123?include=student.name,student.dob
GET /student/123?include=student.name,student.work.title,student.work_list
GET /student/123?include=student.name,student.work.title,student.work_list.page.2
GET /student/123?include=student.name,student.work.title,student.work_list.page.2.limit.10
GET /student/123?include=student.name,student.work.title,student.work_list.page.2,student.work_list.limit.10
GET /student/123?include=student.name,student.work.title,student.work_list.page.2,student.work_list.limit.10,student.work_list.order.desc


GET /students?include=student.name,student.dob
GET /students?include=student.name,student.work.title,student.work_list

```

> So the gem tries to do what GraphQL for obtaining data but obviously gem solution has less features ...but at the same time more pragmatic.


> todo:  gem is ready I'm just writing up documentation, pls come back
> soon


#### why don't you use GraphQL ?

We love [GraphQL](https://graphql.org) and recommending to use it
instead of [PragmaticQL](https://github.com/Pobble/pragmatic_ql). 

But Sometimes you are dealing with legacy REST API and you want to slowly
introduce query language to the application API and you don't have the luxury of switching
the entire project to GraphQL. This is where PragmaticQL may come in handy.
You may slowly transition your API to query/constructive based API and then maybe
make it GraphQL (but I doubt it as you will end up loving it :wink:)

Another benefit of PragmaticQL is that it's job is only to help you to GET
/retrieve data. PragmaticQL is not imposing any way how to
create/update/delete your data. That is up to you to decide how to do it
(REST is pretty good in this actually)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pragmatic_ql'
```

And then execute:

    $ bundle

## Usage

This is quite comprehensive topic. Pls read up section in `/docs`:

* [01 really simple example](https://github.com/Pobble/pragmatic_ql/blob/master/docs/01_stupid_simple_implementation.md)
* [02 serializer implementation](https://github.com/Pobble/pragmatic_ql/blob/master/docs/02_serializer_example.md)



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Pobble/pragmatic_ql. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PragmaticQL project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Pobble/pragmatic_ql/blob/master/CODE_OF_CONDUCT.md).
