resource "aws_instance" "task1_kuldeep_sir" {
    ami = "ami-00fa32593b478ad6e"
    instance_type = "t2.micro"
    root_block_device {
      volume_size = 30
    }
    vpc_security_group_ids = [aws_security_group.custom_sg.name]
    
}
resource "aws_security_group" "custom_sg" {
        name        = var.custom
        description = "Allow TLS inbound traffic and all outbound traffic"
        vpc_id      = "vpc-07d4de2bc286eea08"

        tags = {
            Name = var.custom
        }
        ingress {
            from_port   = 22//ssh
            to_port     = 22
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }

        ingress {
            from_port   = 80//https
            to_port     = 80
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }

        ingress {
            from_port   = 443//https
            to_port     = 443
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }//inbound for 22, 80, 443 

        egress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }//outbound
}
resource "aws_cloudwatch_metric_alarm" "ec2_memory" {
    alarm_name = "ec2_memory"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "10"
    alarm_description = "This alram enable when ec2 cpu utilization is above than 10gb"
    alarm_actions = [aws_sns_topic.sns_conformation.arn]

    dimensions = {
       InstanceId = aws_instance.task1_kuldeep_sir.id
     }
}
resource "aws_sns_topic" "sns_conformation" {
  name = "sns_conformation"
}
resource "aws_sns_topic_subscription" "email_send" {
   topic_arn = "arn:aws:sns:ap-south-1:381491902899:sns_conformation"
   protocol = "email"
   endpoint =  "mtaori197@gmail.com"
   confirmation_timeout_in_minutes = 10
   
}