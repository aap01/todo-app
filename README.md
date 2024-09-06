# Todo Application
[![Deploy Web](https://github.com/aap01/todo-app/actions/workflows/firebase-hosting-merge.yml/badge.svg)](https://github.com/aap01/todo-app/actions/workflows/firebase-hosting-merge.yml)
[![Format Analyze Test](https://github.com/aap01/todo-app/actions/workflows/format-analyze-test.yml/badge.svg)](https://github.com/aap01/todo-app/actions/workflows/format-analyze-test.yml)

[![Watch Web Version](http://img.youtube.com/vi/UaIvo9WInn8/0.jpg)](https://youtu.be/UaIvo9WInn8)
[![Watch Mobile Version](http://img.youtube.com/vi/feGklKr6Tg0/0.jpg)](https://youtu.be/feGklKr6Tg0)

Organize and access your todos from anywhere, anytime
See the live web application:
# [https://todo-app-6ff79.web.app](https://todo-app-6ff79.web.app)

## Features
- Organize todos
- Access from anywhere anytime

## Technical Aspects
- [Localization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- Store todos offline and sync with firebase database every 6 hours
- Integration tests 
- Automatic deploy


## Caveats
- No user specific separation
    - So your todo is my todo and mine is yours
- No firebase integration for web
    - As todos can be sent to firebase via background services every 6 hours; web does not support background service

## Caution
- Testing background services on IOS is one messy job :/


## Run
```bash
flutter gen-l10n # Generate localization files
flutter run # For Chrome
# And of course, get the credentials from me first :)
```
