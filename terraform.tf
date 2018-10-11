terraform {
  backend "s3" {
    bucket  = "tf-ecs-cluster-hero-us-east-1"
    region = "us-east-1"
    key     = "ecs_cluster"
  }
}
