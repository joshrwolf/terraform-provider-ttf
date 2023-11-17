terraform {
  required_providers {
    ttf = {
      source = "registry.terraform.io/joshrwolf/ttf"
    }
  }
  backend "inmem" {}
}

provider "ttf" {}

resource "ttf_harness_k3s" "simple" {}

resource "ttf_harness_teardown" "simple" {
  harness = ttf_harness_k3s.simple.id
}

resource "ttf_feature" "footure" {
  name        = "footure"
  description = "My great footure"

  setup {
    cmd = "echo 'setting up'"
  }

  teardown {
    cmd = "echo 'tearing down'"
  }

  assert {
    cmd = "echo 'assert 1'"
  }

  assert {
    cmd = "sleep 2"
  }

  assert {
    cmd = "kubectl get po -A"
  }
}

resource "ttf_environment" "foo" {
  harness = ttf_harness_k3s.simple.id

  test {
    features = [ttf_feature.footure.id]
  }
}
