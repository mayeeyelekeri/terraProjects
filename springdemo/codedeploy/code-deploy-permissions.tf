#.................................................
resource "random_integer" "suffix" {
  min = 100
  max = 999
}

#.................................................
# Create a role for codedeploy 
resource "aws_iam_role" "my_code_deploy_role" {
  name = "MyCodeDeployRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codedeploy.amazonaws.com"
                ]
            },
            "Action": [
                "sts:AssumeRole"
            ]
    }
  ]
}
EOF

}

#.................................................
# Attach codedeploy policy to code deploy role 
resource "aws_iam_role_policy_attachment" "codedeploy_service" {
  role       = aws_iam_role.my_code_deploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}
