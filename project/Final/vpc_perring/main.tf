
data "terraform_remote_state" "staging_network" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "acs730-assignment-ssaurabh3"      // Bucket where to SAVE Terraform State
    key    = "staging-network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                            // Region where bucket created
  }
}

data "terraform_remote_state" "prod_network" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "acs730-assignment-ssaurabh3"      // Bucket where to SAVE Terraform State
    key    = "prod-network/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1" // Object name in the bucket to GET Terraform State
  }
}
# Create a VPC peering connection between staging and prod
resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id   = data.terraform_remote_state.prod_network.outputs.vpc_id
  vpc_id        = data.terraform_remote_state.staging_network.outputs.vpc_id
  auto_accept   = true

  tags = {
    Name = "staging-prod-vpc-peering"
  }
}

# Add routes for the staging VPC to reach the prod VPC through the peering connection
resource "aws_route" "peer_route_staging" {
  route_table_id            = data.terraform_remote_state.staging_network.outputs.staging_main_route_table_id
  destination_cidr_block    = var.prod_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# Add routes for the prod VPC to reach the staging VPC through the peering connection
resource "aws_route" "peer_route_prod" {
  route_table_id            = data.terraform_remote_state.prod_network.outputs.prod_main_route_table_id
  destination_cidr_block    = var.staging_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "route_to_peered_public_subnet" {
  route_table_id            = data.terraform_remote_state.prod_network.outputs.private_subnet_route_table_id
  destination_cidr_block    = "10.1.1.0/24"
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}



resource "aws_route" "route_to_peered_private_subnet" {
  route_table_id            = data.terraform_remote_state.staging_network.outputs.public_subnet_route_table_id
  destination_cidr_block    = "10.10.1.0/24"
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "route_to_peered_private_subnet_2" {
  route_table_id            = data.terraform_remote_state.staging_network.outputs.public_subnet_route_table_id
  destination_cidr_block    = "10.10.2.0/24"
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

