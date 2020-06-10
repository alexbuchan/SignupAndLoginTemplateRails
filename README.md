This is a Ruby on Rails API template I wrote with signup, login, and GET /contacts routes that are authenticated with JWT.
I have a matching repository which contains the frontend here: [SignupAndLoginTemplateUI](https://github.com/alexbuchan/SignupAndLoginTemplate-UI)

This project is meant to help me learn how to write a Ruby on Rails API with authentication, which I can then turn into real applications.

# Setup

## Download the repository:

`git clone git@github.com:alexbuchan/SignupAndLoginTemplateRails.git`

## Install the dependencies:

`bundle install`

## Setup the database:

`rake db:create`
`rake db:migrate`

This project uses mysql2 gem as a database. Make sure you have mysql set up and installed on your computer.

## To run the project:

`rails s`

## To run the tests:

`rspec spec/`