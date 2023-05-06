#// This is the role to allow SSM to conect to the EC2 instance
data "aws_iam_policy_document" "ec2_instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
#// This is the role from above but can't be attached without an iam instance profile
resource "aws_iam_role" "ec2_instance_role" {
  assume_role_policy = data.aws_iam_policy_document.ec2_instance_assume_role_policy.json
  name               = "Ec2InstanceRole"
}


#// This is the what will attach the the ec2 instance.
resource "aws_iam_instance_profile" "ec2_access_role" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_instance_role.name
}


resource "aws_iam_role_policy_attachment" "ssm_core_role" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
