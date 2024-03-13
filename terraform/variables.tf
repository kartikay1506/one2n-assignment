# variable "access_key" {
#     description = "AWS access key id"
# }

# variable "secret_key" {
#     description = "AWS secret access key"
# }

variable "instance_name" {
    description = "Name of the instance"
    default = "testflaskapp"
}

variable "ami_id" {
    description = "AMI id of the image to be used"
    default = "ami-0a1b648e2cd533174"
}

variable "ssh_key_pair" {
    description = "Key pair to be used for ssh into the instance"
    default = "one2n-assignment-keypair"
}