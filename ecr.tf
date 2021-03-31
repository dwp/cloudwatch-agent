resource "aws_ecr_repository" "cloudwatch-agent" {
  name = "cloudwatch-agent"
  tags = merge(
    local.common_tags,
    { DockerHub : "dwpdigital/cloudwatch-agent" }
  )
}

resource "aws_ecr_repository_policy" "cloudwatch-agent" {
  repository = aws_ecr_repository.cloudwatch-agent.name
  policy     = data.terraform_remote_state.management.outputs.ecr_iam_policy_document
}

output "ecr_example_url" {
  value = aws_ecr_repository.cloudwatch-agent.repository_url
}
