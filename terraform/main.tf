terraform {
  required_providers {
    git = {
      source = "metio/git"
      version = "2023.10.20"
    }
  }
}

provider "git" {
  # Configuration options
}

resource "git_add" "single_file" {
  directory = "."
  add_paths = ["**"]
}
