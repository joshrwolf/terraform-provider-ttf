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

  // Labels allow for identifying tests at runtime. Environments will only be
  // run if the runtime labels match the labels defined here.
  labels = {
    // Match this test with:
    // TTF_LABELS="foo=bar" terraform apply
    // or
    // TTF_LABELS="bar=baz" terraform apply
    // or
    // TTF_LABELS="foo=bar,bar=baz" terraform apply
    "foo" = "bar"
    "bar" = "baz"
  }
}
