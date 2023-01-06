Basic example, pure dart

This can:

    - create an account

    - login with "Resource Owner Password Grant"

    - login with MFA

    - show/delete/add factors

    - enable/disable MFA in user_metadata (if you use the corresponding rule)
    
You have to change variables in .env:

AUTH0_DOMAIN, AUTH0_CLIENT_ID, AUTH0_SECRET, TWILIO_TOKEN

![demo](https://github.com/khomin/flutter-oauth2-example/blob/dev/demo.png)