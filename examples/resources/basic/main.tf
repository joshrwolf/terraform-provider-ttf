terraform {
  required_providers {
    ttf = {
      source = "registry.terraform.io/joshrwolf/ttf"
    }
  }
  backend "inmem" {}
}

provider "ttf" {}

resource "ttf_feature" "footure" {
  name        = "footure"
  description = "My great footure"

  assert {
    cmd = "echo 'first assertion'"
  }

  assert {
    cmd = "echo 'second assertion'"
  }
}

resource "ttf_environment" "foo" {
  test {
    features = [ttf_feature.footure.id]
  }
}
