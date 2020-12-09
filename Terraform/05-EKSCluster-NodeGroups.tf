resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "example"
  node_role_arn   = aws_iam_role.exampleNG.arn
  subnet_ids      = [
	"subnet-*****************",
	"subnet-*****************",
	"subnet-*****************"
  ]

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.exampleNG-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.exampleNG-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.exampleNG-AmazonEC2ContainerRegistryReadOnly
  ]
}