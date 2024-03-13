from flask import Flask, render_template
from aws.aws_s3 import AWS_S3
import os


current_dir = os.path.dirname(__file__)
template_dir = os.path.join(current_dir, "templates")
app = Flask(__name__, template_folder=template_dir)

def get_environ_vars():
    return os.environ.get("AWS_ACCESS_KEY"), os.environ.get("AWS_SECRET_ACCESS_KEY")


@app.route("/")
def index():
    return "Welcome to a simple API based application that returns the content of S3 bucket."


@app.route("/list-bucket-content")
def get_default_bucket_data():
    aws_access_key_id, aws_secret_access_key = get_environ_vars()
    
    s3_client = AWS_S3(aws_access_key_id, aws_secret_access_key)
    result = s3_client.get_object(bucket_name="one2n-assignment")
    return result

@app.get("/list-bucket-content/<path>")
def get_bucket_data(path):
    aws_access_key_id, aws_secret_access_key = get_environ_vars()

    s3_client = AWS_S3(aws_access_key_id, aws_secret_access_key)
    result = s3_client.get_object(bucket_name="one2n-assignment", prefix=path)
    return result

if __name__ == "__main__":
    app.run(host="127.0.0.1", port="8080", debug=True)