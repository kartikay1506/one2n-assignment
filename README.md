# one2n-assignment

This is a simple API based application made in Flask framework that returns the content of S3 bucket.

Structure of the project looks something like follows:

```
one2n-assignment
|
| _ _ aws
|     | _ aws_s3.py
|
| _ _ docs
|
| _ _ terraform
|     | _ init.sh
|     | _ main.tf
|     | _ variables.tf
|
| _ _ app.py
```

## About the Application

This application has been created using flask framework with python. app.py defines simple server running on port 8080 that contains two three routes:

1. **/** --> This route handles the default endpoint and displays a simple welcome message to the user
2. **/list-bucket-content** --> This route returns all the content of the bucket.
3. **/list-bucket-content/<"path">** --> This route returns the content of the path inside the bucket and in case the path is invalid it returns a simple 404 not found error.

###
> Here we have assumed that the bucket will have multiple levels of nesting and have returned all the data in default format from aws sdk calls as such. If needed we can always format the data to our needs for better presentation.
###

###
> Bucket name has been hard coded in the application as of now, but can modified later to be taken as an imput from the user to create more robust endoint.
###

###
Infrastructure to deploy our application has been deployed using terraform which makes it convenient deploy, modify and teardown the application. Terraform template **main.tf** deploy aws resources like VPC, subnet, secutiy groups, EC2 instance and IAM role for us. **init.sh** is a shell script that configures the ec2 instance by
installing the necessary packages and cloning our application code from github using **GITHUB_TOKEN** env variable.


Our application is finally run by gunicorn and nginx server.


###
> We've stored sensitive information like github token, aws access key and aws secret access keys in the AWS Parametet store, which we're retrieving later on by use aws cli. This is made possible by attaching the relevant IAM role to the ec2 instance hosting our application.
###
![AWS Parameter Store](/one2n-assignment/docs/Screenshot-7.png)
###

The structure of our AWS S3 bucket looks something like below, wehere we have multiple files and folders of varying nesting levels within the bucket.
###
![Bucket Name](/one2n-assignment/docs/Screenshot-1.png)
###

###
![Bucket Content](/one2n-assignment/docs/Screenshot-2.png)
###

###
![Bucket Path Content](/one2n-assignment/docs/Screenshot-3.png)
###
###

## Working of the Application

###
When the user hits the endpoint `<instance_ip>:8080/`, they're greeted by a simple welcome page

###
![Welcome Page](/one2n-assignment/docs/Screenshot-8.png)
###

If the user does not give any path in the endpoint `<instance_ip>:8080/list-bucket-content`, they get whole content of the s3 bucket.

###
![Bucket Default Content](/one2n-assignment/docs/Screenshot-4.png)
###

If the user provides a path in the endpoint `<instance_ip>:8080/list-bucket-content/<path>`, the endpoint returns the content of the path that is available in the bucket.

###
![Bucket Path Content](/one2n-assignment/docs/Screenshot-5.png)
###

But for some reason, if the user inputs the wrong path or the path does not exist in the bucket, then the application simply returns 404 not found error.

###
![Bucket 404 Error](/one2n-assignment/docs/Screenshot-6.png)
###

###

## Demo
Here's a small demo of the application working.

![Demo Video]()

###

**_Thank you for viewing the application. Please provide any feedbacks and/or suggestions for improvements._**