# account specific
account_id="124837307879"
vpc_name = "hero-tw-ecs"
profile = "default"

# vpc specific
domain = "hero-tw.com"
environment = "dev"
aws_region = "us-east-1"
vpc_cidr = "10.10.48.0/22"
public_cidr_blocks = ["10.10.48.0/27", "10.10.48.32/27"]
private_cidr_blocks = ["10.10.48.128/27", "10.10.48.160/27"]

# app specific
cluster_name = "cluster"
autoscaling_initial_count = 2
autoscaling_min_capacity = 2
autoscaling_max_capacity = 6



