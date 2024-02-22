 provider "aws" {
 region = "eu-west-3"
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
      "subnet-02eeb5247c4007027",
      "subnet-0a841430fdfb696f4",
      "subnet-03c1446940d7891fe"
    ]
  }

depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}
