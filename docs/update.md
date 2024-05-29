# Update test

Download the CloudFormation templates for VPC, Kali Linux, Ubuntu and
AmazonLinux-2023:

```bash
# renovate: currentValue=master
wget --continue -q -P "${TMP_DIR}" https://raw.githubusercontent.com/aws-samples/aws-codebuild-samples/00284b828a360aa89ac635a44d84c5a748af03d3/ci_tools/vpc_cloudformation_template.yml
# renovate:
wget --continue -q -P "${TMP_DIR}" https://raw.githubusercontent.com/aws-samples/amazon-ec2-nice-dcv-samples/3cb54467cf4c58bace2f949a704871f9bc0e5af5/cfn/KaliLinux-NICE-DCV.yaml
# renovate: currentValue=main
wget --continue -q -P "${TMP_DIR}" https://raw.githubusercontent.com/aws-samples/ec2-lamp-server/c0ec2481d4995771422304b05b7b90bd701052f2/UbuntuLinux-2204-LAMP-server.yaml
# renovate:
wget --continue -q -P "${TMP_DIR}" https://raw.githubusercontent.com/aws-samples/ec2-lamp-server/c0ec2481d4995771422304b05b7b90bd701052f2/AmazonLinux-2023-LAMP-server.yaml
```
