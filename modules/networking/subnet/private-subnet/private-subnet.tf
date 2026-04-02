/*
──────────────────────────────────────────────────────────────────────
private Subnet Module – Networking
──────────────────────────────────────────────────────────────────────
📌 Purpose: Create private subnets (one per AZ) that have private IPs
            on launch and are associated with the Internet Gateway.
📅 Created: 14‑01‑2026
👤 Owner:   Yogendra Pratap Singh (yogendra.singh01@nagarro.com)
🏢 Team:    Infrastructure / DevOps
💰 Cost Center: 12345‑AWS‑SUBNET
🌍 Region: ${var.aws_region}
🗂️ Components:
  • aws_subnet "private_subnet"
🔗 References:
  – AWS Subnet docs: https://docs.aws.amazon.com/vpc/latest/userguide/subnet-details.html
  – Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
🔐 Security / Compliance:
  • private subnets expose resources to the internet; ensure only
    intended resources (e.g., load balancers, bastion hosts) are placed here.
  • Tags include `project`, `environment` for cost allocation.
📦 Inputs (variables) – see variables.tf:
  • vpc_id                – VPC ID to attach subnets.
  • private_subnets_cidr   – List of CIDR blocks for each private subnet.
  • availability_zones    – List of AZs matching the CIDR list order.
  • project, environment  – Tagging metadata.
📤 Outputs – see output.tf:
  • private_subnet_ids – List of created subnet IDs.
──────────────────────────────────────────────────────────────────────
---------------------------------------------------------------------
aws_subnet "private_subnet"
---------------------------------------------------------------------
Creates a private subnet in each availability zone. `map_private_ip_on_launch`
is set to true so that instances receive a private IP automatically (useful
for load balancers, bastion hosts, etc.). The subnet is tagged with a
descriptive name that includes project, environment, AZ, and purpose.
*/
resource "aws_subnet" "private_subnet" {
  vpc_id                              = var.vpc_id
  count                               = length(var.private_subnets_cidr)
  cidr_block                          = element(var.private_subnets_cidr, count.index)
  availability_zone                   = var.availability_zones[count.index]
  private_dns_hostname_type_on_launch = "ip-name"

  tags = {
    Name                                                                          = "${var.project}-${var.environment}-${element(var.availability_zones, count.index)}-private-subnet"
    Environment                                                                   = var.environment
    "kubernetes.io/role/internal-elb"                                             = "1"
    "kubernetes.io/cluster/${var.project}-${var.environment}-${var.cluster_name}" = "shared"
  }
}
