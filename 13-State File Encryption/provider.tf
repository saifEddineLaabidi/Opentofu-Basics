terraform {
  encryption {
    key_provider "aws_kms" "kms_key" {
      kms_key_id = "18370188-.."  # Remplacez par votre KMS Key ID réel
      key_spec   = "AES_256"
      region     = "eu-west-1"
    }
    method "aes_gcm" "secure_method" {
      keys = key_provider.aws_kms.kms_key
    }
    state {
      method = method.aes_gcm.secure_method
    }
  }
}

resource "random_pet" "one" {}
