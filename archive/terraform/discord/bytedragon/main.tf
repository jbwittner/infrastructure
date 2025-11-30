# Define the required variables
variable "discord_token" {}

# Specify the provider
provider "discord" {
  token = var.discord_token # Token sourced from an environment variable
}

resource "discord_server" "bytedragon" {
  name = "ByteDragon server"
}

resource "discord_category_channel" "toto_category" {
  depends_on = [
    resource.discord_server.bytedragon
  ]
  name      = "Toto category"
  position  = 0
  server_id = resource.discord_server.bytedragon.id
}

resource "discord_text_channel" "toto_aaa_channel" {
  depends_on = [
    resource.discord_category_channel.toto_category
  ]
  name                     = "toto-aaa"
  position                 = 0
  server_id                = resource.discord_server.bytedragon.id
  category                 = resource.discord_category_channel.toto_category.id
  sync_perms_with_category = true
}

resource "discord_text_channel" "toto_bbb_channel" {
  depends_on = [
    resource.discord_category_channel.toto_category
  ]
  name                     = "toto-bbb"
  position                 = 1
  server_id                = resource.discord_server.bytedragon.id
  category                 = resource.discord_category_channel.toto_category.id
  sync_perms_with_category = true
}

resource "discord_voice_channel" "toto-aaa-voice" {
  name                     = "💩toto-aaa-voice"
  server_id                = resource.discord_server.bytedragon.id
  category                 = resource.discord_category_channel.toto_category.id
  sync_perms_with_category = true
  position                 = 0
  user_limit               = 5
}

resource "discord_role" "moderator" {
  server_id   = resource.discord_server.bytedragon.id
  name        = "Moderator"
  permissions = 8
  color       = 159
  hoist       = true
  mentionable = true
  position    = 1
}

resource "discord_member_roles" "jake" {
  user_id   = 148029630308155392
  server_id = resource.discord_server.bytedragon.id

  role {
    role_id = resource.discord_role.moderator.id
  }

}

resource "discord_message" "hello_world" {
  depends_on = [
    resource.discord_text_channel.toto_aaa_channel
  ]
  channel_id = discord_text_channel.toto_aaa_channel.id
  content    = "hello world"
}
