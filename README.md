Rails Test Apps
===============

This is a collection of simple test applications for the purpose of mastering
the Ruby on Rails framework.

The version of Ruby instlled for this project was version 5.1.6  as
recommended by [railstutorial.org](http://version.railstutorial.org/) using
the gem installer as follows:

`gem install rails -v 5.1.6`

The initial app, "hello_app," was then created with the command:
`rails _5.1.6_ new hello_app -d postgresql`

Gemfiles within the applcation can then install dependencies using:
`bundle install --without production`
Although the exclution of production may not be needed by those able to run
natively.

To run the application, run `rails server` or `rails s`.  If running within
an online IDE, you will likely have to set your binding address and
port number like so:
`rails server -b $IP -p $PORT`

These apps were initially developed in *c9.io* and deployed to Heroku.
Apps can be deployed to Heroku using the following commands (assuming
you have an account with Heroku and have initailized and commited to a
git repository):

```
$ heroku login
Enter you Heroku credentials.
Email: youremail@here.com
Password (typing will be hidden):
Authentication successful

$ heroku keys:add
Found existing public key: /home/ubuntu/.ssh/id_rsa.pub
Uploading SSH public key /home/ubuntu/.ssh/id_rsa.pub... done

$ heroku create
Creating app... done, ⬢ mighty-hamlet-84912
https://mighty-hamlet-84912.herokuapp.com/ | https://git.heroku.com/mighty-hamlet-84912.git

$ git push heroku master
```
*Note that heroku does not support sqlite which is the default db for some*
*rails applcations. Instead it is recommended to use postgreSQL.  More*
*information on the proper configuration can be found* 
[here](https://devcenter.heroku.com/articles/sqlite3)

### Development

In some simple learning applications, it may be desirable to use scaffolds to
generate templates for structures within the database. This can be done as such:
`rails generate scaffold mytablename field1:integer field2:text`

This will then generate both the database configuration and a simple interface
where data can be imput from the browser. Remeber to migrate the database
when adding scaffolds or adding models to run  `bundle exec rake db:migrate`

* A database migration can be undone by running `bundle exec rake db:migrate`.
* Remember that your database will need to be migrated within production as well.
In Heroku, this can be done as follows: `heroku run rake db:migrate`
* *If this fails, you may need to manually add the postgres addon:
`heroku addons:create heroku-postgresql`

However, in development you will more likely wish to generate controllers from 
which you can begin development of new pages rather than generating scaffolds 
that directly link to your database (that'd be a crazying thing to do in 
production). This can be done using the following command:

`rails generate controller [controller_name] [template_name]`

New models can be generated using the following example (Note that models
are automatically created with an integer ID field):

`rails generate model User name:string email:string`

Routes can be seen by runing `rails routes`

In testing and development, fake accounts can be seeded into the database
using the code in `db/seeds.rb`.  To create seeded accounts, run:

```
$ rails db:migrate:reset
$ rails db:seed
```

### Testing

Tests can be run using `rails test` or to be safe `bundle exec rake test`.  
**Note that you may have to instantiate your database and configure the 
database.yml to use template0 or change template1 to use unicode or the tests 
to run**.

Individual tests can be run using the following command as an example:
`rails test:integration` to run integration tests.

In addition to this, the guard-minitest gem is set up for installation in the
sample_app. Running the `guard` command opens the guard cli where test will
automatically be run based on the configuraiton of the Guardfile.

Now guard tests can be created using the command 
`rails generate integration_test [test_name]`.  From there, test will be placed
in `/test/integration` to be modified to your particular needs. Controller tests
can be found in `/test/cotrollers` while model tests are in `/test/models/`.

When testing the contents and configuration of the database, it helps to not
have to worry about any test values or features used during development. For
this purpose, you can run `rails console --sandbox` so that models can be
created in memory before you push any changes to the database and any db changes
are rolledback when exiting the console.

  * Create a empty model: `myvar = ModelName.new`
  * Check if a model is valid: `myvar.valid?`
  * Insert memory model into database: `myvar.save`
  * Create a model in the database: `ModelName.create`
  * Destroy a model in the database: `myvar.destroy`
  * Find model object in DB with ID: `ModelName.find(1)`
  * Find model object in DB with field: `ModelName.find_by(name: "field_value")`
  * Find first model: `ModelName.first`
  * Get all rows: `ModelName.all`
  * Save field change to DB: `myvar.reload.field_name`
  * Update multiple models in a hash: `myvar.update_attribute(:name, "new name")`

*The guard file may leave behind a number of spring processes which no longer*
*are needed once testing is done.  Search for these processes using*
`ps aux | grep spring` *and kill them if need be. First try* `spring stop`.
*If this fails, run* `pkill -9 -f spring` *to kill any lingering processes.*

### Deployment

Rails comes with three different environments for your app: *test, development,*
*and production*. By default, the development environment is used.
An environment object is kept by rails and holds various boolean and setter
functions to tell which environment you are in or change the current
environment. Here is how to check or swich the current environment.

```
$ rails console
  Loading development environment
  >> Rails.env
  => "development"
  >> Rails.env.development?
  => true
  >> Rails.env.test?
  => false
  
$ rails console test
  Loading test environment
  >> Rails.env
  => "test"
  >> Rails.env.test?
  => true
```

Rails server also has functionality to set the environment, although it is
syntactically somewhat different.

`$ rails server --environment production`

However, if we want to run a production server, we need to pair it with a
production database like so.

`$ rails db:migrate RAILS_ENV=production`

It should be noted that when pushing changes to production that require a
database migration, it is a good idea to put Heroku into maintenance mode so
that there can be no conflict with an untimely entry by a user.  Do this by
running the following commands:

```
$ heroku maintenance:on
  Enabling maintenance mode for ⬢ will-learns-ruby... done
  
$ git push heroku master
  Counting objects: 25, done.
  Delta compression using up to 8 threads.
  Compressing objects: 100% (24/24), done.
  Writing objects: 100% (25/25), 4.11 KiB | 1.37 MiB/s, done.
  Total 25 (delta 15), reused 0 (delta 0)
  remote: Compressing source files... done.
  remote: Building source:
  ...
  Some more stuff here
  ...
  remote: Verifying deploy... done.
  To https://git.heroku.com/will-learns-ruby.git
   e56fe36..e0a7d3f  master -> master

$ heroku run rake db:migrate
  Running rake db:migrate on ⬢ will-learns-ruby... up, run.8129 (Free)
  ...
  Lots of SQL stuff here
  ...
  
$ heroku maintenance:off
  Disabling maintenance mode for ⬢ will-learns-ruby... done
```

### Other Consideration

Certain functionality of the webapp will have to be reconfigured in order for
a copy of the source code to work.  One example is the email configuration.  
Email account information is stored securely as an environment variable, so it
is not available in source code.  The service used for this particular app is
SendGrid, an extremely use to use application available on Heroku. To configure
SendGrid, all you have to do (after validating your Heroku account with a 
credit card and a text message code) is run:

`$ heroku addons:create sendgrid:starter`

Then using the configuraiton in `config/environments/production.rb`, simply
push your code tp Heroku.  You can access your SendGrid config settings by
running commands such as:

```
$ heroku config:get SENDGRID_USERNAME
$ heroku config:get SENDGRID_PASSWORD
```

Pictures are also configured to be stored on an AWS S3 instance in production
(check `app/uploaders/picture_uploader.rb` and
`config/initializers/carrier_wave.rb` to get a better idea), so you'll have to
set up environment variables for AWS IAM and S3 to get that working (sorry,
this part costs real money in the order of like 5 cents a month).

```
$ heroku config:set S3_ACCESS_KEY=<access key>
$ heroku config:set S3_SECRET_KEY=<secret key>
$ heroku config:set S3_BUCKET=<bucket name>
```

If you're not really familiar with AWS and how to configure it, there is a
really good tutorial for this exact usage case
[right here](https://www.youtube.com/watch?v=afByHGIWKYQ).

Additional Dependencies include (Assume latest versions):
* Rails (v5.1 or above)
* libcurl3
* libcur3-gnutls
* libcurl4-openssl-dev
* ImageMagick
* heroku (if deploying to Heroku)