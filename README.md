# README

This README would normally document whatever steps are necessary to get the application up and running.

# Things you may want to cover:

### 1. Ruby version

```bash
 ruby-3.0.0
```
### 2. System dependencies
```bash
 redis
```

### 3. Configuration
```bash
  bundle install
```
### 4. make sure you have the database.yml creds according your local machine.

### 5. Database creation and initialization
```ruby
 rake db:create
 rake db:migrate
```
### 6. Start sidekiq from the root of your Rails application so the jobs will be processed:
```ruby
  bundle exec sidekiq
```
### 7. Once the above steps are successful, you can check the available jobs for Issuing Rewards Rules on url:
```ruby
  /sidekiq
```
### 8. How to run the test suite
```ruby
 bundle exec rspec
```
