# Make sure you have a .tfvars file that can hold any sensitive values like access keys or passwords.
# Anything that you do not want revealed in a repository or publically, put it into the .tfvars file
# The .tfvars file within this repo is an example template for reference. 
# Normally, .tfvars is in the gitignore and should never be pushed to a repo

variable access_key{
  type=string
  sensitive=true
}
variable secret_key{
  type=string
  sensitive=true
}
variable region{}

variable instance_type{
  type=string
}
