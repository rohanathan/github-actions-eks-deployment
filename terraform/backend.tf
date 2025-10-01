terraform {
  backend "s3" {
    bucket         = "tfstate-897545368009-eu-west-2" # Replace with your actual S3 bucket name
    key            = "eks-gh-01/state.tfstate"        # Define the path for storing the state file
    region         = "eu-west-2"
    encrypt        = true            # Enable encryption for security
    dynamodb_table = "tfstate-locks" # Replace with your DynamoDB table for state locking
  }
}