# UserService

The UserService handles storage and management of Users. The required tables are
as follows:

  * Users
      The Users table contains important information about the User such as
      `email`, `username`, and `password`. The Users table also has a
      `belongs_to` relationship with the Gender table.

      The Users table has a unique constraint on both `username` and `email` to
      ensure that we don't have name conflicts and that each user can only make
      one account. This can be circumvented by creating additional emails to
      register more accounts, but who really cares tbh.

      Users `has_many` Permissions.
  * Genders
      The Genders table contains a set of genders that are dynamically-creatable
      by a User. The columns for the Genders table are as follows:

      `name`, the name of the gender, can be NULL
      `nominative`, the Nominative pronoun, He/She/Ae
      `accusative`, the Accusative pronoun, Him/Her/Aer
      `pronomial_possessive`, the Pronomial Possessive pronoun, His/Her/Aer
      `predicative_possessive`, the Predicative Possessive pronoun, His/Hers/Aers
      `reflexive`, the Reflexive pronoun, Himself/Herself/Aerself

      The Genders table has a `has_many` relationship with the Users table.

      The Genders table has a unique constraint across all the keys, so there
      cannot be duplicate genders.

      By allowing users to create their own genders, we will get submissions such as
      `Apache Attack Helicopter`, and `FuckGender`. This is fine by me tbh.
  * Permissions
      Permissions should be a list of named permissions that other services will
      recognize and be able to adapt to.

      Initially, the Permissions table will be pre-loaded with `admin` which
      will be assigned to the first User to create an account. the `admin` User
      will be able to alter the permissions of other Users.

      Columns:
      `name`, the name of the permission
      `description`, a detailed description of the permission so developers of
      other services will be able to use these permissions effectively.

      Permissions `has_many` Users.
      

The UserService is also responsible for signing User Tokens that other services
can relay to the UserService in order to ensure a User is who they say they are.

Endpoints:

  * POST /users/create
      The URL used to create Users.
  * GET /users/:username
      The URL to get information about a specific User.
  * POST /users/authenticate
      The URL that verifies a User is real with a `username` and `password` and
      returns a signed UserToken.
  * GET /users/:user?permission=":permission"
      When provided with a `permission` in the payload, it provides whether a user
      has this permission.
  * GET /users/:user/permissions
      Lists all permissions owned by the user
  * GET /genders
      A list of all created Genders without references to Users.
  * POST /genders/create
      The URL used to create Genders.
  * GET /permissions
      A list of all available permissions and their descriptions.
  * POST /permissions/create
      The URL used to create permissions

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
