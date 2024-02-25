# ssh-login-msg v1.0
**ssh-login-msg** is a ssh login message tool & logger (uses telegram and/or matrix messenger)

### Dependencies
- [curl](https://github.com/curl/curl)

### Recommended

- telegram

> Get bot token in telegram.app: go to **@BotFather**, enter `/mybots`, press `@your-bot-name`, press `API Token`.

> Get chat id   in telegram.app: `/start` a »trustworthy« bot like **@Olivettis_Bot** or **@MissRose_bot** and send `/id`.

- matrix

> Get token   in matrix.app: go to `Settings` -> `Advanced Settings`, enable `Developer Mode` -> 
                             go down to `Access Token`, press (copy token) and paste into a file.

> Get room id in matrix.app: go to `Room Info` -> `Settings` -> `Advanced`, press `Internal Room ID` (copy id)
                             and paste into a file.

### Installation

- On server

  > 1. [Download & save/unpack ](https://github.com/Olivetti/ssh-login-msg/releases/latest/download/ssh-login-msg.tar.gz)
  > 2. Copy to /etc/profile.d/ `cp ssh-login-msg.sh /etc/profile.d/`
  > 3. Copy env file to ~      `cp ssh-login-msg.env ~/.ssh-login-msg.env`
  > 4. Change file mode        `chmod 600 ~/.ssh-login-msg.env`
  > 5. Edit credentials        `nano ~/.ssh-login-msg.env`

- On webhosting

  > 1. [Download & save/unpack ](https://github.com/Olivetti/ssh-login-msg/releases/latest/download/ssh-login-msg.tar.gz)
  > 2. Copy to /.local/bin/    `cp ssh-login-msg.sh /.local/bin/`
  > 3. Add to ~/.profile       `echo -e "\nsource /.local/bin/ssh-login-msg.sh\n" ~/.profile`
  > 4. Copy env file to ~      `cp ssh-login-msg.env ~/.ssh-login-msg.env`
  > 5. Change file mode        `chmod 600 ~/.ssh-login-msg.env`
  > 6. Edit credentials        `nano ~/.ssh-login-msg.env`

### Usage
- Log into your host (and see log file `~/ssh-login-msg.log`)

## Contributing
Issues can be made in [**GitHub** project](https://github.com/Olivetti/ssh-login-msg)

## Contact
[Mastodon](https://mastodon.social/@Olivetti)
