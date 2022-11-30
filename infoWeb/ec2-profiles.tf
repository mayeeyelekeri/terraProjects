# Create a policy for S3 access for EC2 
resource "aws_iam_policy" "mys3policy" {
  name        = "S3AccessPolicy"
  path        = "/"
  description = "My S3 access policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action": [
                "s3:Get*",
                "s3:List*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  })

  depends_on = [aws_security_group.public_sg]
}

# Create a role for EC2 
resource "aws_iam_role" "myec2role" {
    name = "myec2role"
    assume_role_policy = jsonencode({
     "Version": "2012-10-17",
     "Statement": [
     {
       "Action": "sts:AssumeRole",
       "Principal": {
         "Service": "ec2.amazonaws.com"
       },
       "Effect": "Allow",
       "Sid": ""
     }
     ]
    })

    depends_on = [aws_iam_policy.mys3policy]
}

# Create a instance profile 
resource "aws_iam_instance_profile" "myinstanceprofile" {
  name = "myinstanceprofile"
  role = aws_iam_role.myec2role.name
  path = "/"

  depends_on = [aws_iam_role.myec2role]
} # end of resource aws_iam_role

# Attach policy to role 
resource "aws_iam_role_policy_attachment" "roll_attach_to_policy" {
  role       = aws_iam_role.myec2role.name
  policy_arn = aws_iam_policy.mys3policy.arn

  depends_on = [aws_iam_policy.mys3policy, aws_iam_role.myec2role]
}
