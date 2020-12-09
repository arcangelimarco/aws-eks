resource "aws_eks_fargate_profile" "example" {
  cluster_name           = "aws_eks_cluster.example.name"
  fargate_profile_name   = "example"
  pod_execution_role_arn = "arn:aws:iam::***********:role/eksctl-ekscluster-cluster-FargatePodExecutionRole-***********"
  subnet_ids             = [
	"subnet-*****************",
	"subnet-*****************",
	"subnet-*****************"
  ] 

  selector {
    namespace = "example"
  }
}