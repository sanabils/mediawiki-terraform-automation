module "environment" {
  source      = "./mediawiki-tf-module"
  db_username = var.db_username
  db_password = var.db_password
  mediawiki_major_version = "1.39"
  mediawiki_minor_version = "3"
}
