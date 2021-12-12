variable "token" {
  description = "OAuth-token, you can get him -> https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}
# variable "cloud_id" {
#   type        = string
#   description = ""
# }
# variable "folder_id" {
#   type        = string
#   description = ""
# }
# variable "zone" {
#   type        = string
#   description = ""
# }
# variable "image_id" {
#   type        = string
#   description = ""
# }
# variable "v4_cidr_blocks" {
#   type    = list(string)
#   description = ""
# }
variable "resource" {
   type    = list(string)
   default=[ "acme-server1","acme-server2" ]
}
