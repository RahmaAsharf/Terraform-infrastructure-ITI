# data "aws_iam_policy_document" "lambda_assume_role_policy" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role" "lambda_role" {
#   name               = "lambda-lambdaRole-waf"
#   assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
# }

# data "archive_file" "python_lambda_package" {
#   type        = "zip"
#   source_file = "./sendmail.py"
#   output_path = "sendmail.zip"
# }

# resource "aws_lambda_function" "test_lambda_function" {
#   function_name    = "lambdamail"
#   filename         = "sendmail.zip"
#   source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
#   role             = aws_iam_role.lambda_role.arn
#   runtime          = "python3.9"
#   handler          = "lambda_function.lambda_handler"
#   timeout          = 10
# }

# resource "aws_cloudwatch_event_rule" "test-lambda" {
#   name = "run-lambda-function"
#   event_pattern = jsonencode({
#     source = ["aws.s3"],
#     detail = {
#       eventName = ["ObjectCreated:*"],
#       requestParameters = {
#         bucketName = ["terraform-rahmalab2"]
#       }
#     }
#   })
# }

# resource "aws_cloudwatch_event_target" "lambda-function-target" {
#   target_id = "lambda-function-target"
#   rule      = aws_cloudwatch_event_rule.test-lambda.name
#   arn       = aws_lambda_function.test_lambda_function.arn
# }

# resource "aws_lambda_permission" "allow_cloudwatch" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.test_lambda_function.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.test-lambda.arn
# }