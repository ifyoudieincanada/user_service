# UserService

The UserService handles storage and management of Users. The required tables are
as follows:

  * Users
      The Users table contains important information about the User such as
      `email` and `username`.
  * Genders
      The Genders table contains a set of genders that are dynamically-creatable
      by a User. The columns for the Genders table are as follows:
      `name`, the name of the gender, can be NULL
      `nominative`, the Nominative pronoun, He/She/Ae
      `accusative`, the Accusative pronoun, Him/Her/Aer
      `pronomial_possessive`, the Pronomial Possessive pronoun, His/Her/Aer
      `predicative_possessive`, the Predicative Possessive pronoun, His/Hers/Aers
      `reflexive`, the Reflexive pronoun, Himself/Herself/Aerself

By allowing users to create their own genders, we will get submissions such as
`Apache Attack Helicopter`, and `FuckGender`. This is fine by me tbh.

To start your Phoenix app:

  * Run `setup.sh` to create the required `postgresql` users
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
