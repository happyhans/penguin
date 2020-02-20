# Penguin
Penguin is a current WIP re-implementation of my former project [Beat](https://github.com/happyhans/beat-old), a former online, collaborative [music sequencer](https://en.wikipedia.org/wiki/Music_sequencer) with additional social network-like features.

As I continue to work on this project, I hope to demonstrate my learnings in the [Ruby](https://www.ruby-lang.org/en/) programming language, the popular [Ruby on Rails](https://rubyonrails.org/) web framework, and general server-side/backend web development.

### Features
The `server` directory contains a JSON REST API which features:
* CRUD operations for resources such as Users, Albums, Songs, Posts, Comments, Friend Requests, Friendships, Conversations, Messages.
* JWT token-based authentication for accessing protected resources such as a User's friend requests.
* Comprehensive `model` tests to ensure model data and relationship integrity.
* Comprehensive `controller` tests to ensure proper resource access control and the validity of the HTTP responses.
* Email-backed user registration and forgot password functions.
* Time-based caching on resources such as Posts.
* Support for user-uploadable files such as user avatars, album covers, and song covers.

### Built With
* [Ruby](https://www.ruby-lang.org/en/)
* [Ruby on Rails](https://rubyonrails.org/)
* [bcrypt gem](https://rubygems.org/gems/bcrypt) - Used for hashing user passwords.
* [jwt gem](https://rubygems.org/gems/jwt) - Used for encoding & decoding JWT tokens.
* [fast_jsonapi gem](https://rubygems.org/gems/fast_jsonapi) - Used for serializing Rails models into JSON format.
* [factory_bot_rails gem](https://rubygems.org/gems/factory_bot) - Used for generating Rails model factories which are utilized in tests.
* [faker gem](https://rubygems.org/gems/faker) - Used for generating mock data for testing purposes.

### Database Structure
TODO: Add ER diagram here!

### Installation
Clone this repository:
```
git clone https://github.com/happyhans/penguin.git
```

Ensure your Ruby version is at least 2.5.1. I don't have much reason for this requirement other than the fact that this is the Ruby version I'm using in development. I would recommend using [rbenv](https://github.com/rbenv/rbenv) to wrap your `ruby` executable. The server directory contains a `ruby-version` file which will be picked up by rbenv to use the appropriate Ruby version/installation.
```
rbenv install 2.5.1
ruby -v
rbenv version
```

Ensure you have postgresql installed. Create a postgres user and configure your settings in `server/config/database.yml`. Read [How To Set Up Ruby on Rails with Postgres](https://www.digitalocean.com/community/tutorials/how-to-set-up-ruby-on-rails-with-postgres) for more information.

Install [Bundler](https://bundler.io/), a package manager for your Ruby gems.
```
gem install bundler
```

Install the gems
```
cd server
bundle install
```

Setup the database and perform the database migrations
```
rails db:setup
rails db:migrate
```

Run the tests
```
rails test
```

All good? Run the server :)
```
rails server
```

### Basic Usage
For now, the only way to interact with the server is by sending HTTP requests to it. I know, it's a little boring, but I'll work on a real client in the future. For now, here's some example interactions:

Signing up an account:
```curl
curl --request POST \
  --url http://localhost:3000/sign_up \
  --header 'content-type: application/json' \
  --data '{
	"user": {
		"email": "test@test.com",
		"password": "123456"
	}
}'
```

Signing into that account:
```
curl --request POST \
  --url http://localhost:3000/sign_in \
  --header 'content-type: application/json' \
  --data '{
	"email": "test@test.com",
  "password": "123456"
}'
```
Expect the response to look like this:
```json
{
  "jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1ODIxODUyNDUsImlhdCI6MTU4MjE4MTY0NSwidXNlciI6eyJpZCI6MX19.vyYa49uo27q_X2lFnW_g-IMRpnQNhp72IohNdTy6c5w",
  "refresh_token": "FztgoVygqfQNuwMEGYSt11nk"
}
```

List your friend requests:
```curl
curl --request GET \
  --url http://localhost:3000/friend_requests \
  --header 'authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1ODIxODUyNDUsImlhdCI6MTU4MjE4MTY0NSwidXNlciI6eyJpZCI6MX19.vyYa49uo27q_X2lFnW_g-IMRpnQNhp72IohNdTy6c5w'
```

Send a friend request to another user:
```curl
curl --request POST \
  --url http://localhost:3000/friend_requests \
  --header 'authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1ODIxODUyNDUsImlhdCI6MTU4MjE4MTY0NSwidXNlciI6eyJpZCI6MX19.vyYa49uo27q_X2lFnW_g-IMRpnQNhp72IohNdTy6c5w' \
  --header 'content-type: application/json' \
  --data '{
	"user_uuid": "123"
}'
```

### Testing
To test a specific model, run `rails test test/models/<model name>` in the terminal. Example:
```
rails test test/models/user.rb
```

To test a specific controller, run `rails test test/controllers/<controller name>` in the terminal. Example:
```
rails test test/controllers/users_controller.rb
```

To run all tests, run
```
rails test
```

### Future Plans
* Refactor controller tests by implementing test helpers to implement common tasks such as retrieving JWT tokens and forming request headers.
* Create an app/website to interact with the server.
* Host the server on a cloud-computing platform such as Heroku or AWS.