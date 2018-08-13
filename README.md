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

Remember that your database will need to be migrated within production as well.
In Heroku, this can be done as follows:
`heroku run rake db:migrate`

If this fails, you may need to manually add the postgres addon:
`heroku addons:create heroku-postgresql`

However, in development you will more likely wish to generate controllers from 
which you can begin development of new pages rather than generating scaffolds 
that directly link to your database (that'd be a crazying thing to do in 
production). This can be done using the following command:

`rails generate controller [controller_name] [template_name]`

New models can be generated using the following example (Note that models
are automatically created with an integer ID field):

`rails generate model User name:string email:string`

### Testing

Tests can be run using `rails test` or to be safe `bundle exec rake test`.  
**Note that you may have to instantiate your database and configure the 
database.yml to use template0 or change template1 to use unicode or the tests 
to run**.

Individual tests can be run using the following command as an example:

`rails test:integration`.

In addition to this, the guard-minitest gem is set up for installation in the
sample_app. Running the `guard` command opens the guard cli where test will
automatically be run based on the configuraiton of the Guardfile.

Now guard tests can be created using the command 
`rails generate integration_test [test_name]`.  From there, test will be placed
in `/test/integration` to be modified to your particular needs. Controller tests
can be found in `/test/cotrollers`.

When testing the contents and configuration of the database, it helps to not
have to worry about any test values or features used during development. For
this purpose, you can run `rails console --sandbox` so that any models are first
created in memory before you push any changes to the database and any changes
are rolledback when exiting the console.

  * Create a empty model: `myvar = modelname.new`
  * Check if a model is valid: `myvar.valid?`
  * Insert model into database: `myvar.save`

*The guard file may leave behind a number of spring processes which no longer*
*are needed once testing is done.  Search for these processes using*
`ps aux | grep spring` *and kill them if need be. First try* `spring stop`.
*If this fails, run* `pkill -9 -f spring` *to kill any lingering processes.*