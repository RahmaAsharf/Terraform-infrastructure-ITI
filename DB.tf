# ===== RDS Security Group ====
resource "aws_security_group" "rds_sg" {
  name        = "${var.tag}-rds-sg"
  vpc_id      = module.network-lab2.vpc_id
  
  ingress {
    from_port   = 3306 
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ===== RDS Subnet Group ====
resource "aws_db_subnet_group" "rds_subnetG" {
  name       = "${var.tag}-rds-subnet"
  
  subnet_ids = [
    module.network-lab2.subnets[1].id, 
    module.network-lab2.subnets[2].id
   
  ]
}
# ===== RDS Instance ====
resource "aws_db_instance" "terraform-DB" {
  allocated_storage    = 10
  identifier              = "terraformdb"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t3.micro"
  db_name                 = "terraformdb"
  username                = "admin"
  password                = var.db_pass
  db_subnet_group_name    = aws_db_subnet_group.rds_subnetG.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot = true
}
# ===== ElastiCache Security Group ====
resource "aws_security_group" "elasticache_sg" {
  name        = "${var.tag}-elasticache-sg"
  vpc_id      = module.network-lab2.vpc_id

  ingress {
    from_port   = 6379 // Redis default port
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

# ===== ElastiCache Subnet Group ====
resource "aws_elasticache_subnet_group" "elasticache_subnetG" {
  name       = "${var.tag}-elasticache-subnet-group"
  subnet_ids = [module.network-lab2.subnets[1].id] 
}

# ===== ElastiCache Cluster ====
resource "aws_elasticache_cluster" "terraform-cache" {
  cluster_id           = "mycache"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  subnet_group_name    = aws_elasticache_subnet_group.elasticache_subnetG.name
  security_group_ids = [aws_security_group.elasticache_sg.id]
}


