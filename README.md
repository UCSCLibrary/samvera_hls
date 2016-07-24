
## Synopsis

This gem allows a hydra application to create hls derivative media files automatically after uploading audiovisual media files, and to display those to a user through hls adaptive streaming.

## Motivation

Hydra is a promising framework for digital asset management. One Hydra based application - [https://github.com/avalonmediasystem](Avalon Media System) - has relatively robust support for multimedia streaming. However, Avalon is not nearly as flexible or feature rich as [](Sufia) (another Hydra "head") as an asset management system. Avalon also relies on a clunky party transcoding service (Matterhorn) and external streaming server (Red5 or Wowza), creating an unweildly application stack. We wanted the streaming power and flexiblity promised by Avalon, in a mature and flexible asset management system like Sufia. This gem aims to integrate all of the benefits of adaptive bitrate streaming into Sufia's existing simple, efficient system for creating multimedia derivative files. 

## Installation

Add the following to your gem file:

```gem 'hydra_hls'```

then run the following from your rails app root directory:

```
bundle install
rails generate hydra_hls:install

## Update apache config
These instructions assume that you have an apache server running. This apache server can be (but does not need to be) serving your rails app via passenger.
Edit the appropriate configuration file for your apache server. For my setup on CentOS 7 using passenger, I added this code to the file `/etc/httpd/conf.d/10-sufia.conf` inside the VirtualHost directive .
Add the following lines, inserting a random secret key of your own and inserting the absolute path to your rails app.
```
 SetEnv hls_token_secret "PUT_A_SECRET_KEY_HERE"
 RewriteEngine on
 RewriteMap hls_auth "prg:/RAILS_PATH/bin/hls_auth"
 RewriteRule ^/stream/.*\.ts$ "${hls_auth:%{REQUEST_URI}}"
```
then restart your server
```sudo systemctl restart httpd```

## Usage

When you ingest new audio or visual files, hls derivatives ought to be created automatically along with the other derivative files. View partials are included for displaying these. And "Embed" action is created for file sets, allowing an endpoint for embedding these in other websites using iframes.

## License

[https://opensource.org/licenses/MIT](MIT license)