### This app demonstrates a way of securing an API with Rails.

First clone and start the app:

    rails s
    
Attept to access a secured API endpoint:

    curl -i localhost:3000/api/posts

The `-i` option will show the response headers of the request, otherwise you'll only see the body. Notice that status code `401 Unathorized` is returned.
    
Given a user with email: `jack@humblehumans.com` and password `secret`, login with a POST request using http basic authentication to pass the eamil and password in a header, with an empty body.

    curl -i -X POST localhost:3000/api/signin -u "jack@humblehumans.com:secret"

This time, status code `201 Created` is returned. A session has been created. Note the `Authorization` header returned. The value of the header is the word "Token" and a 64 character authentication token, separated by one space. For example:

    Authorization: Token s1X2YYX5speeR6fFwFHQGkxrArrwW7PyeiMA_4uB_EmtmmUbNGDx-Fzy-_xxv79H

Save the 64 character token, it will be needed for all API requests.

Now we can retry accessing the secured endpoint, this time including the auth token in a request header, using curl's `-H` option.

    curl -i localhost:3000/api/posts -H 'Authorization: Token s1X2YYX5speeR6fFwFHQGkxrArrwW7PyeiMA_4uB_EmtmmUbNGDx-Fzy-_xxv79H'
    
This time, with the correct token included in the request, we receive a `200 OK`
