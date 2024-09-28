terraform {
 encryption {
   key_provider "pbkdf2" "migration_key" {
     passphrase    = "super-passphrase-hard-to-find"
     key_length    = 32
     salt_length   = 16
     hash_function = "sha256"
   }
   method "aes_gcm" "secure_method" {
     keys = key_provider.pbkdf2.migration_key
   }
   state {
     method = method.aes_gcm.secure_method
   }
 }
}

resource "random_pet" "one" {}