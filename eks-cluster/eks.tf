 provider "aws" {
 region = "us-east-1"
}

data "aws_iam_policy_document" "iam_role_data" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

#Iam Role

resource "aws_iam_role" "iamrole" {
  name               = "eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.iam_role_data.json
}


resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iamrole.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.iamrole.name
}



resource "aws_eks_cluster" "cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.iamrole.arn
  vpc_config {
    subnet_ids = [
      "subnet-08a1ddcbf956f339d",
      "subnet-02db042cc5c413950",
      "subnet-0a10aee9902ea7f25"
    ]
  }

depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}
