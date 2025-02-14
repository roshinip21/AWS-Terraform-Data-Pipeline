provider "aws" {
  region = "us-east-1"  # Change region if needed
}

# S3 Bucket for Storing Data
resource "aws_s3_bucket" "taxi_data_bucket" {
  bucket = "yellow-green-taxi-data-${var.aws_account_id}"
  acl    = "private"
}


# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

# Attach necessary IAM policies to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}



# RDS Database for Processed Data
resource "aws_db_instance" "taxi_db" {
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  identifier             = "taxi-database"
  db_name                = "taxidb"
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}


# AWS subnet IDS 

subnet_ids = ["subnet-abc123", "subnet-def456"]
