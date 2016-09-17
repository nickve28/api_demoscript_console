# API Demoscript Console

This project helps setting up an API demo in an easy and consistent manner.

## Features

- Potential state sharing between examples (but can be overridden if required).
- Separate data from code.
- Separate authentication from the demo scenario's.
- Don't crash on unexpected API timeouts, or other errors.

## API Support
Currently the demoscript only supports Basic Auth and OAuth Token Bearer API's.

## Requirements

We'll only discuss installation using docker here. Using it on your own systems works fine if you have ruby and the neccessary gems installed, but I won't go into details about that.

### Docker
Docker is required to host the API demoscript in, you can download it at https://docs.docker.com/engine/installation/.

## Creating a Demoscript

In order to create a working API Demo, you need to provide the necessary authentication handlers and a collection of demo scenarios, written in YAML, to the demo.rb. This can be done as follows:

### Run the generate_skeleton.sh

This will create a skeleton with a YAML file, authentication module and a runner module. These can be filled in by the user. We'll discuss all files.

### scenarios.yml (YAML)

The first file created is the scenarios.yml. It contains the Demo script that will be executed. A skeleton example is provided to give the user a rough estimate how to use it.

The scenarios file is structured as follows:

```
---
authentication_token: #Contains all bearer token custom authentication handlers
  test: #The name used for this authentication scenario
    action: api_test #The method in the auth handler that will be called

urls: #Contains all base urls used in the examples
  api: http://api_example:8080/api #Example url mapped to a name


actions: #Contains all actions that will be run
  -
    description: get products #The description for this action that will be printed
    actions: #The actions belonging to this flow
      -
        type: print #Can be print/prompt. Print prints data and prompt will ask the user for data.
        value:  get products - authenticated #The value that will be printed
        domain: api #The base url to be used
        method: get #HTTP Method type
        url: /products #The url to call on the domain
        options: #Additional request options
          auth_type: authentication_token #specifies the authentication type.
          auth_user: wrong_test #What user profile specified above will run this step
          expect_error: true #Use this if you expect an API error.
```

### auth.rb (Ruby authentication handlers)

This module contains a set of function that contain authentication handlers. This can vary from hard coding a token to using webdrivers to log in users with a GUI. As long as it returns a valid token.

### main.rb

This file will be used to start the API demoscript.

### Starting the script.

Starting can be done by running build.sh and start.sh

### examples

The example folder contains an example API and runner to give a rough overview of how it will look.
