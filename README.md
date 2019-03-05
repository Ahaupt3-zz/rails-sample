# Ruby on Rails Tutorial sample application

## License

All source code in the [Ruby on Rails Tutorial](https://www.railstutorial.org/)
is available jointly under the MIT License and the Beerware License. See
[LICENSE.md](LICENSE.md) for details.

## Live Sample

https://www.rubypost.live | https://alex-ror-003.herokuapp.com/

### Test Credentials

Email | test@test.com

Password | Testing

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

We also need to install NPM packages:
```
$ npm install
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```

If you are using Heroku for production, set Heroku ENV Variables for AWS:

```
$ heroku config:set <variable>=<value>
```

```
...set S3_ACCESS_KEY=<access_key>
...set S3_BUCKET=<bucket_name>
...set S3_REGION=<bucket_region>
...set S3_SECRET_KEY=<secret_key>
```
