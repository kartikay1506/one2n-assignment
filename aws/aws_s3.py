from botocore.exceptions import ClientError
import boto3

class AWS_S3:
    def __init__(self, aws_access_key_id: None, aws_secret_access_key: None) -> None:
        self.aws_access_key_id = aws_access_key_id
        self.aws_secret_access_key = aws_secret_access_key

    def get_client(self) -> None:
        try:
            client = boto3.client("s3", aws_access_key_id=self.aws_access_key_id, aws_secret_access_key=self.aws_secret_access_key)
            return client
        except ClientError as e:
            return e

    def get_object(self, bucket_name, prefix="") -> None:
        s3_client = self.get_client()

        try:
            bucket_data = s3_client.list_objects(Bucket=bucket_name, Prefix=prefix)
            if not bucket_data.get("Contents"):
                return "Error 404: Path not found in bucket"
            
            files = [obj.get("Key") for obj in bucket_data.get("Contents")]
            return {"content": files}
        except ClientError as e:
            return e
