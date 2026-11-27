provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Project   = "workforce-analytics-platform"
      Env       = "dev"
      ManagedBy = "terraform"
    }
  }
}
