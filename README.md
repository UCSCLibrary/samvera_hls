
## Synopsis

This gem allows a hydra application to create hls derivative media files automatically after uploading audiovisual media files, and to display those to a user through hls adaptive streaming.

## Motivation

Hydra is a promising digital asset management solution with a growign feature set, and we wanted to use as a streaming media service for audiovisual collections. One Hydra based application - [Avalon Media System](https://github.com/avalonmediasystem) - is designed specifically to support multimedia streaming. However, Avalon is not nearly as flexible or well developed as [Sufia](https://github.com/projecthydra/sufia) (another Hydra "head") as an asset management system, and its developer community is relatively small. Avalon also relies on a clunky party transcoding service (Matterhorn) and external streaming server (Red5 or Wowza), creating an unweildly and bug-pronesoftware stack. We wanted the streaming power and flexiblity promised by Avalon, in a more flexible and feature-rich asset management system like Sufia. This gem aims to integrate all of the benefits of adaptive bitrate streaming into Sufia's existing simple, efficient system for creating multimedia derivative files. 

## Security & tokens

This software is not a DRM solution. We do not claim or intend to offer protection against authorized clients storing streamed media and then using it in undesired ways. We only seek to limit streaming from our servers to authorized clients.

Streaming media presents a challenge in balancing speed with security. Media streaming requires many requests to a server, each for a small segment of the media file being played. Each of these requests must be individually authenticated to prevent access by unauthorized users. We want to give our Rails app full control over which users are authorized to view which files - but if we load our whole Rails app for each media request, we put a big load on the server and ruin our streaming media performance. On the other hand, if we don't authenticate requests for media segments (Avalon doesn't) we risk people creating their own playlist files linking directly to those segments and bypassing our authorization system entirely.

Instead, my Rails engine uses signed tokens (using a SHA-256 hash and secret key) which grant direct access to a specific file's media segments for a specified period of time. When an authorized client requests a media segment, the token is authenticated by a lightweight external script which does not need to load the entire Rails app. If a malicious client tries to link to this segment file, the link will break quickly when the token expires.

## Requirements

An apache server is required. This may or may not be the same server that serves your Rails app (through passenger).

## Installation

###Install the gem
Add the following to your gem file:

```gem 'hydra_hls'```

then run the following from your rails app root directory:

```
bundle install
rails generate hydra_hls:install
```

### Update apache config
These instructions assume you have an apache server running.
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

### Create link to derivative folder
It is probably possible to create this link automatically, but I have not set that up yet. You need to create this symbolic link manually. The rewrite rule you created in the last step keeps this path from being accessible publicly. Note that the apache directive FollowSymLinks must be set for this to work properly.
```
sudo su - hydrauser
ln -s /mnt/MY/DERIVATIVE/PATH /srv/MY/WEB/APP/public/stream
logout

## Usage

When you ingest new audio or visual files, hls derivatives ought to be created automatically along with the other derivative files. View partials are included for displaying these. And "Embed" action is created for file sets, allowing an endpoint for embedding these in other websites using iframes.

## License

[www.apache.org/licenses/LICENSE-2.0](Apache License, v2.0)
