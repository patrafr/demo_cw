# CloudWatch alarm
resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
     alarm_name          = "cpu-utilization-demo" # "cpu-utilization-demo"
     comparison_operator = "GreaterThanOrEqualToThreshold"
     evaluation_periods  = "2"
     metric_name         = "CPUUtilization"
     namespace           = "AWS/EC2"
     period              = "60" #seconds
     statistic           = "Average"
     threshold           = "80"
     alarm_description   = "This metric monitors ec2 cpu utilization"
     alarm_actions       = [aws_sns_topic.cpualarm.arn]
     insufficient_data_actions = []
dimensions = {
       InstanceId = aws_instance.cwdemo.id
     }
}

resource "aws_cloudwatch_metric_alarm" "ec2_memory" {
     alarm_name          = "memory-utilization-demo"
     comparison_operator = "GreaterThanOrEqualToThreshold"
     evaluation_periods  = "1"
     metric_name         = "mem_used_percent"
     namespace           = "CWAgent"
     period              = "60" #seconds
     statistic           = "Average"
     threshold           = "50"
     alarm_description   = "This metric monitors ec2 memory utilization"
     alarm_actions       = [aws_sns_topic.memoryalarm.arn]
     insufficient_data_actions = []
dimensions = {
       InstanceId = aws_instance.cwdemo.id
     }
}


#### Please do not show this on demo ####

#locals {
#  emails = ["hello@world.com"]
#}

#resource "aws_sns_topic_subscription" "topic_email_subscription" {
#  count     = length(local.emails)
#  topic_arn = aws_sns_topic.topic.arn
#  protocol  = "email"
#  endpoint  = local.emails[count.index]
#}