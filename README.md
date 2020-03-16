# Inviter

Inviter implements a customer referral program, in order to acquire new paying customers. Here are the product requirements that we are given:

* An existing user can create a referral to invite people, via a shareable sign-up link that contains a unique code
* When 5 people sign up using that referral, the inviter gets $10.
* When somebody signs up referencing a referral, that person gets $10 on signup. Signups that do not reference referrals do not get any credit.
* Multiple inviters may invite the same person. Only one inviter can earn credit for a particular user signup. An inviter only gets credit when somebody they invited signs up; they do not get credit if they invite somebody who already has an account.

Inviter is implemented as API and doesn't have any UI.

Read more about the process of development in the [process.md]

## Try it Online

Visit [nviter.herokuapp.com](https://nviter.herokuapp.com/) via a browser to touch the [health-check](#health-check) endpoint.

Or use curl:

Signup:

```
curl -X POST -H 'content-type: application/json' \
http://nviter.herokuapp.com/signup \
-d '{name": "Test", "email": "your@email.com", "password": "qwerty"}'
```

Take the token from the response and use it as `Authorization` header:

```
INVITER_JWT=...
curl -X GET -H 'content-type: application/json' -H "Authorization: $INVITER_JWT" \
http://nviter.herokuapp.com/invite
```

## TODO / Roadmap

This project is not production-ready. Check [process.md](process.md/#todo) to read the list of possible improvements.

## Configuration

The project uses `config` [gem](https://github.com/rubyconfig/config). For `development` and `test` environments the gem looks for `development.yml` or `test.yml` inside the `config/settings` directory.

Right now the project has the only setting. The [/invite/:code](#goto-invite) redirects a user to the registration page. The path to this frontend page should be specified in application config.

Since Heroku uses git for deployments, this is a bad idea to keep the `production.yml` under version control. Insted, use `Settings.app.registration_page` environment variable:

```
Settings.app.registration_page=/register
```

The example above shows that the value should be a relative path.

## API

### Health Check

```
GET /
```

This endpoint responds with the following json if the app is running: 

```
200 {"message": "Ok"}
```

### Signup

```
POST /signup
```

This endpoint accepts the following parameters in json payload:

* *email*: email of a user
* *name*: name of a user
* *code*: referral code for receiving a bonus. see also [/invite](#users-invite) and [/invite/:code](#goto-invite)
* *password*: password of a user

In a case of a bad request, the endpoint can respond with `400 Bad Request` with a body like this:

```
400 {
  "error": "Failed to save the user.",
  "details": {
    "email": ["has already been taken", "is invalid"]
  }
}
```

In a case of success, the endpoint responds with a body in the following format:

```
200 {
  "auth_token": "...JWT...",
  "user": {
    "name": "John",
    "email": "j@ohn.com",
    "credits": 10
  }
}
```

Note, that the user above has 10 credits because was registered by a valid referral code.

Now it's possible to use `auth_token` as `Authorization` header for other requests that need authentication like [/info](#user-info) and [/invite](#users-invite) 

### Login

```
POST /login
```

This endpoint allows to issue a new token for an existing user. It accepts the following parameters in json payload:

* *email*: email of a user
* *password*: password of a user

In a case of a bad request, the endpoint can respond with `401 Unauthorized` with a body like this:

```
401 {
  "error": "Failed to authenticate the user.",
  "details": {
    "user_authentication": "invalid credentials"
  }
}
```

## User Info

This endpoint allows to get details about logged user (user who has a valid non-expired token). This method requires `Authorization: $JWT` header. The JWT token can be retrieved by using [/login](#login) or [/signup](#signup) endpoints.

```
GET /info
Authorization: $JWT
```

In a case of success, the endpoint responds with a body in the following format:

```
200 {
  "message": "Ok",
  "user": {
    "name": "John",
    "email": "j@ohn.com",
    "credits": 10
  }
}
```

## User's Invite

To get a link with personal invite code a user should call this endpoint.

```
GET /invite
```

This method requires `Authorization: $JWT` header. The JWT token can be retrieved by using [/login](#login) or [/signup](#signup) endpoints.

```
200 {
  "message": "Ok",
  "invite": {
    "code": "USdmU",
    "used": 7,
    "url": "http://yourdomain.com/invite/aCod3"
  }
}
```

* *code* is the raw value of invite code
* *url* is a link which can be shared to invite people
* *used* is the amount of registrations by this code

## GoTo Invite

```
GET /invite/:code
```

This endpoint handles all visits by invite links. It redirects the user to the registration page. The path to this frontend page should be specified in application config.

For development or test use `app.registration_page` key of `config/settings/development.yml` or `config/settings/test.yml`

Since Heroku uses git for deployments, this is a bad idea to keep the `production.yml` under version control. Insted, use `Settings.app.registration_page` environment variable:

```
Settings.app.registration_page=/register
```

The example above shows that the value should be a relative path.

This endpoint will redirect to specified registration page and set `code` URL parameter:

```
302 /register?code=aCod3
```


