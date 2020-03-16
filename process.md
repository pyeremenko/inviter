# Inviter. Development Process

This project uses some ideas from [rails-jwt-auth-tutorial](https://github.com/hggeorgiev/rails-jwt-auth-tutorial) project. 

The project uses `simple_command` gem which allows to move the business logic to a single place inside the application. This allows keep controllers and models cleaner.

The `base62` gem was used for generating invitation codes, because it makes human-friendly symbols and it looks as a fastest way of generating alphanumeric random values.

## TODO

There are a lot improvements for future development:

- Add more specs. I don't have time for writing more tests but feel insecure without them.
- Use [CAPTCHA](https://en.wikipedia.org/wiki/CAPTCHA) to prevent automated generation of new users.
- Use validation emails to ensure emails are real.
- Increase the balance after email confirmation instead of doing this immediatelly after signup.
- Use payment records to persist all operations with users' balance (credits). 
- Move the api to `/v1` namespace to allow version future releases.
- Use more canonical REST routes.