To Read App
===========

A simple [Sinatra](http://www.sinatrarb.com) web app to store your
pending to read links.

It uses `sqlite3` as database. To install follow these steps:

    $ bundle install
    $ rake db:schema:load

To run the web server run:

    $ bundle exec rackup -p 9292 config.ru

That's all for now.
