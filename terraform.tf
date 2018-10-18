terraform {
  backend "s3" {
    bucket  = "tf-hero-us-east-1"
    region = "us-east-1"
    key     = "ecs_cluster"
  }
}
