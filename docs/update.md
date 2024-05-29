# Update test

Download the CloudFormation templates for VPC, Kali Linux, Ubuntu and
AmazonLinux-2023:

```bash
# renovate: currentValue=master
wget --continue -q -P "${TMP_DIR}" https://raw.githubusercontent.com/aws-samples/aws-codebuild-samples/ad3a6f2798ad1b55dc417a7424cc6497c2817477/ci_tools/vpc_cloudformation_template.yml
# renovate:
wget --continue -q -P "${TMP_DIR}" https://raw.githubusercontent.com/aws-samples/amazon-ec2-nice-dcv-samples/3cb54467cf4c58bace2f949a704871f9bc0e5af5/cfn/KaliLinux-NICE-DCV.yaml
# renovate: currentValue=main
wget --continue -q -P "${TMP_DIR}" https://raw.githubusercontent.com/aws-samples/ec2-lamp-server/c2b64d97229a223dd5f5f38fd3f9660a8011f050/UbuntuLinux-2204-LAMP-server.yaml
# renovate:
wget --continue -q -P "${TMP_DIR}" https://raw.githubusercontent.com/aws-samples/ec2-lamp-server/cad9ad9a52f8346d80281186c8e301a69835ffbd/AmazonLinux-2023-LAMP-server.yaml
```
