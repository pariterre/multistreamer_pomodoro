# MultiStreamer

## Installation

Il est important de suivre les étapes suivante suite au clonage de ce dépôt git afin de pouvoir compiler sans problème :  

### Firebase

1. Installer le [CLI Firebase](https://firebase.google.com/docs/cli#setup_update_cli). La façon la plus rapide, si Node.js est déjà installé, est avec `npm` :    

        npm install -g firebase-tools

2. Installer le [CLI FlutterFire](https://pub.dev/packages/flutterfire_cli) à l'aide de `dart`.

        dart pub global activate flutterfire_cli

3. Se connecter avec un compte ayant accès au projet Firebase et configurer le projet avec les paramètres par défaut.

        firebase login
        flutterfire configure --project=multi-twitch-streamers

Pour plus d'informations, visitez [cette page](https://firebase.google.com/docs/flutter/setup).
