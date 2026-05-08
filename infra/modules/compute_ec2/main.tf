# ── Security Group ────────────────────────────────────────────────────────────
resource "aws_security_group" "this" {
  name        = "${var.name}-${var.environment}-sg"
  description = "Allow inbound traffic to the Ruby HTTP server and all outbound"

  ingress {
    description = "Application port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Allow all outbound (needed for dnf + S3)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-${var.environment}-sg"
    Environment = var.environment
  }
}

# ── IAM Role ──────────────────────────────────────────────────────────────────
resource "aws_iam_role" "this" {
  name = "${var.name}-${var.environment}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.name}-${var.environment}-role"
    Environment = var.environment
  }
}

# ── Scoped S3 inline policy (server.rb only, no wildcards) ────────────────────
resource "aws_iam_role_policy" "s3_read" {
  name = "${var.name}-${var.environment}-s3-read"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.app_s3_bucket}/server.rb"
      }
    ]
  })
}

# ── Instance Profile ──────────────────────────────────────────────────────────
resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-${var.environment}-profile"
  role = aws_iam_role.this.name
}

# ── EC2 Instance ──────────────────────────────────────────────────────────────
resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y ruby
    aws s3 cp s3://${var.app_s3_bucket}/server.rb /opt/server.rb
    COMPUTE_TYPE=ec2 nohup ruby /opt/server.rb &
  EOF

  tags = {
    Name        = "${var.name}-${var.environment}"
    Environment = var.environment
  }
}
