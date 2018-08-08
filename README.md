Rails Test Apps
===============

This is a collection of simple test applications for the purpose of mastering
the Ruby on Rails framework.

The version of Ruby instlled for this project was version 5.1.6  as
recommended by [railstutorial.org](http://version.railstutorial.org/) using
the gem installer as follows:

`gem install rails -v 5.1.6`

The initial app, "hello_app," was then created with the command:
`rails _5.1.6_ new hello_app`

Gemfiles within the applcation can then install dependencies using:
`bundle install --without production`
Although the exclution of production may not be needed by those with to run
natively.

To run the application, run `rails server` or `rails s`.  If running within
an online IDE, you will likely have to set your binding address and
port number like so:
`rails server -b $IP - $PORT`

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
Creating tropical-tundra-4905... done, stack is cedar
http://tropical-tundra-4905.herokuapp.com | git@heroku.com:tropical-tundra-4905.git
Git remote heroku added

$ git push heroku master
```
*Note that heroku does not support sqlite which is the default db for some*
*rails applcations. Instead it is recommended to use postgreSQL.  More*
*information on the proper configuration can be found* 
[here](https://devcenter.heroku.com/articles/sqlite3)