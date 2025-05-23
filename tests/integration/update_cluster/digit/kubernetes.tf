locals {
  cluster_name                          = "123.example.com"
  default-myserviceaccount_role_arn     = aws_iam_role.myserviceaccount-default-sa-123-example-com.arn
  default-myserviceaccount_role_name    = aws_iam_role.myserviceaccount-default-sa-123-example-com.name
  iam_openid_connect_provider_arn       = aws_iam_openid_connect_provider.prefix_123-example-com.arn
  iam_openid_connect_provider_issuer    = "discovery.example.com/123.example.com"
  master_autoscaling_group_ids          = [aws_autoscaling_group.master-us-test-1a-masters-123-example-com.id]
  master_security_group_ids             = [aws_security_group.masters-123-example-com.id]
  masters_role_arn                      = aws_iam_role.masters-123-example-com.arn
  masters_role_name                     = aws_iam_role.masters-123-example-com.name
  myapp-myotherserviceaccount_role_arn  = aws_iam_role.myotherserviceaccount-myapp-sa-123-example-com.arn
  myapp-myotherserviceaccount_role_name = aws_iam_role.myotherserviceaccount-myapp-sa-123-example-com.name
  node_autoscaling_group_ids            = [aws_autoscaling_group.nodes-123-example-com.id]
  node_security_group_ids               = [aws_security_group.nodes-123-example-com.id]
  node_subnet_ids                       = [aws_subnet.us-test-1a-123-example-com.id]
  nodes_role_arn                        = aws_iam_role.nodes-123-example-com.arn
  nodes_role_name                       = aws_iam_role.nodes-123-example-com.name
  region                                = "us-test-1"
  route_table_public_id                 = aws_route_table.prefix_123-example-com.id
  subnet_us-test-1a_id                  = aws_subnet.us-test-1a-123-example-com.id
  vpc_cidr_block                        = aws_vpc.prefix_123-example-com.cidr_block
  vpc_id                                = aws_vpc.prefix_123-example-com.id
  vpc_ipv6_cidr_block                   = aws_vpc.prefix_123-example-com.ipv6_cidr_block
  vpc_ipv6_cidr_length                  = local.vpc_ipv6_cidr_block == "" ? null : tonumber(regex(".*/(\\d+)", local.vpc_ipv6_cidr_block)[0])
}

output "cluster_name" {
  value = "123.example.com"
}

output "default-myserviceaccount_role_arn" {
  value = aws_iam_role.myserviceaccount-default-sa-123-example-com.arn
}

output "default-myserviceaccount_role_name" {
  value = aws_iam_role.myserviceaccount-default-sa-123-example-com.name
}

output "iam_openid_connect_provider_arn" {
  value = aws_iam_openid_connect_provider.prefix_123-example-com.arn
}

output "iam_openid_connect_provider_issuer" {
  value = "discovery.example.com/123.example.com"
}

output "master_autoscaling_group_ids" {
  value = [aws_autoscaling_group.master-us-test-1a-masters-123-example-com.id]
}

output "master_security_group_ids" {
  value = [aws_security_group.masters-123-example-com.id]
}

output "masters_role_arn" {
  value = aws_iam_role.masters-123-example-com.arn
}

output "masters_role_name" {
  value = aws_iam_role.masters-123-example-com.name
}

output "myapp-myotherserviceaccount_role_arn" {
  value = aws_iam_role.myotherserviceaccount-myapp-sa-123-example-com.arn
}

output "myapp-myotherserviceaccount_role_name" {
  value = aws_iam_role.myotherserviceaccount-myapp-sa-123-example-com.name
}

output "node_autoscaling_group_ids" {
  value = [aws_autoscaling_group.nodes-123-example-com.id]
}

output "node_security_group_ids" {
  value = [aws_security_group.nodes-123-example-com.id]
}

output "node_subnet_ids" {
  value = [aws_subnet.us-test-1a-123-example-com.id]
}

output "nodes_role_arn" {
  value = aws_iam_role.nodes-123-example-com.arn
}

output "nodes_role_name" {
  value = aws_iam_role.nodes-123-example-com.name
}

output "region" {
  value = "us-test-1"
}

output "route_table_public_id" {
  value = aws_route_table.prefix_123-example-com.id
}

output "subnet_us-test-1a_id" {
  value = aws_subnet.us-test-1a-123-example-com.id
}

output "vpc_cidr_block" {
  value = aws_vpc.prefix_123-example-com.cidr_block
}

output "vpc_id" {
  value = aws_vpc.prefix_123-example-com.id
}

output "vpc_ipv6_cidr_block" {
  value = aws_vpc.prefix_123-example-com.ipv6_cidr_block
}

output "vpc_ipv6_cidr_length" {
  value = local.vpc_ipv6_cidr_block == "" ? null : tonumber(regex(".*/(\\d+)", local.vpc_ipv6_cidr_block)[0])
}

provider "aws" {
  region = "us-test-1"
}

provider "aws" {
  alias  = "files"
  region = "us-test-1"
}

resource "aws_autoscaling_group" "master-us-test-1a-masters-123-example-com" {
  enabled_metrics = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_template {
    id      = aws_launch_template.master-us-test-1a-masters-123-example-com.id
    version = aws_launch_template.master-us-test-1a-masters-123-example-com.latest_version
  }
  max_instance_lifetime = 0
  max_size              = 1
  metrics_granularity   = "1Minute"
  min_size              = 1
  name                  = "master-us-test-1a.masters.123.example.com"
  protect_from_scale_in = false
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "123.example.com"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "master-us-test-1a.masters.123.example.com"
  }
  tag {
    key                 = "aws-node-termination-handler/managed"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/role/control-plane"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "k8s.io/role/master"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "master-us-test-1a"
  }
  tag {
    key                 = "kubernetes.io/cluster/123.example.com"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = [aws_subnet.us-test-1a-123-example-com.id]
}

resource "aws_autoscaling_group" "nodes-123-example-com" {
  enabled_metrics = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_template {
    id      = aws_launch_template.nodes-123-example-com.id
    version = aws_launch_template.nodes-123-example-com.latest_version
  }
  max_instance_lifetime = 0
  max_size              = 2
  metrics_granularity   = "1Minute"
  min_size              = 2
  name                  = "nodes.123.example.com"
  protect_from_scale_in = false
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "123.example.com"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "nodes.123.example.com"
  }
  tag {
    key                 = "aws-node-termination-handler/managed"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/role/node"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "nodes"
  }
  tag {
    key                 = "kubernetes.io/cluster/123.example.com"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = [aws_subnet.us-test-1a-123-example-com.id]
}

resource "aws_autoscaling_lifecycle_hook" "master-us-test-1a-NTHLifecycleHook" {
  autoscaling_group_name = aws_autoscaling_group.master-us-test-1a-masters-123-example-com.id
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
  name                   = "master-us-test-1a-NTHLifecycleHook"
}

resource "aws_autoscaling_lifecycle_hook" "nodes-NTHLifecycleHook" {
  autoscaling_group_name = aws_autoscaling_group.nodes-123-example-com.id
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
  name                   = "nodes-NTHLifecycleHook"
}

resource "aws_cloudwatch_event_rule" "prefix_123-example-com-ASGLifecycle" {
  event_pattern = file("${path.module}/data/aws_cloudwatch_event_rule_123.example.com-ASGLifecycle_event_pattern")
  name          = "123.example.com-ASGLifecycle"
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "123.example.com-ASGLifecycle"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
}

resource "aws_cloudwatch_event_rule" "prefix_123-example-com-InstanceScheduledChange" {
  event_pattern = file("${path.module}/data/aws_cloudwatch_event_rule_123.example.com-InstanceScheduledChange_event_pattern")
  name          = "123.example.com-InstanceScheduledChange"
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "123.example.com-InstanceScheduledChange"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
}

resource "aws_cloudwatch_event_rule" "prefix_123-example-com-InstanceStateChange" {
  event_pattern = file("${path.module}/data/aws_cloudwatch_event_rule_123.example.com-InstanceStateChange_event_pattern")
  name          = "123.example.com-InstanceStateChange"
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "123.example.com-InstanceStateChange"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
}

resource "aws_cloudwatch_event_rule" "prefix_123-example-com-SpotInterruption" {
  event_pattern = file("${path.module}/data/aws_cloudwatch_event_rule_123.example.com-SpotInterruption_event_pattern")
  name          = "123.example.com-SpotInterruption"
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "123.example.com-SpotInterruption"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
}

resource "aws_cloudwatch_event_target" "prefix_123-example-com-ASGLifecycle-Target" {
  arn  = aws_sqs_queue.prefix_123-example-com-nth.arn
  rule = aws_cloudwatch_event_rule.prefix_123-example-com-ASGLifecycle.id
}

resource "aws_cloudwatch_event_target" "prefix_123-example-com-InstanceScheduledChange-Target" {
  arn  = aws_sqs_queue.prefix_123-example-com-nth.arn
  rule = aws_cloudwatch_event_rule.prefix_123-example-com-InstanceScheduledChange.id
}

resource "aws_cloudwatch_event_target" "prefix_123-example-com-InstanceStateChange-Target" {
  arn  = aws_sqs_queue.prefix_123-example-com-nth.arn
  rule = aws_cloudwatch_event_rule.prefix_123-example-com-InstanceStateChange.id
}

resource "aws_cloudwatch_event_target" "prefix_123-example-com-SpotInterruption-Target" {
  arn  = aws_sqs_queue.prefix_123-example-com-nth.arn
  rule = aws_cloudwatch_event_rule.prefix_123-example-com-SpotInterruption.id
}

resource "aws_ebs_volume" "us-test-1a-etcd-events-123-example-com" {
  availability_zone = "us-test-1a"
  encrypted         = false
  iops              = 3000
  size              = 20
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "us-test-1a.etcd-events.123.example.com"
    "k8s.io/etcd/events"                    = "us-test-1a/us-test-1a"
    "k8s.io/role/control-plane"             = "1"
    "k8s.io/role/master"                    = "1"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
  throughput = 125
  type       = "gp3"
}

resource "aws_ebs_volume" "us-test-1a-etcd-main-123-example-com" {
  availability_zone = "us-test-1a"
  encrypted         = false
  iops              = 3000
  size              = 20
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "us-test-1a.etcd-main.123.example.com"
    "k8s.io/etcd/main"                      = "us-test-1a/us-test-1a"
    "k8s.io/role/control-plane"             = "1"
    "k8s.io/role/master"                    = "1"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
  throughput = 125
  type       = "gp3"
}

resource "aws_iam_instance_profile" "masters-123-example-com" {
  name = "masters.123.example.com"
  role = aws_iam_role.masters-123-example-com.name
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "masters.123.example.com"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
}

resource "aws_iam_instance_profile" "nodes-123-example-com" {
  name = "nodes.123.example.com"
  role = aws_iam_role.nodes-123-example-com.name
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "nodes.123.example.com"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
}

resource "aws_iam_openid_connect_provider" "prefix_123-example-com" {
  client_id_list = ["amazonaws.com"]
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "123.example.com"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280", "a9d53002e97e00e043244f3d170d6f4c414104fd"]
  url             = "https://discovery.example.com/123.example.com"
}

resource "aws_iam_role" "masters-123-example-com" {
  assume_role_policy = file("${path.module}/data/aws_iam_role_masters.123.example.com_policy")
  name               = "masters.123.example.com"
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "masters.123.example.com"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
}

resource "aws_iam_role" "myotherserviceaccount-myapp-sa-123-example-com" {
  assume_role_policy = file("${path.module}/data/aws_iam_role_myotherserviceaccount.myapp.sa.123.example.com_policy")
  name               = "myotherserviceaccount.myapp.sa.123.example.com"
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "myotherserviceaccount.myapp.sa.123.example.com"
    "kubernetes.io/cluster/123.example.com" = "owned"
    "service-account.kops.k8s.io/name"      = "myotherserviceaccount"
    "service-account.kops.k8s.io/namespace" = "myapp"
  }
}

resource "aws_iam_role" "myserviceaccount-default-sa-123-example-com" {
  assume_role_policy = file("${path.module}/data/aws_iam_role_myserviceaccount.default.sa.123.example.com_policy")
  name               = "myserviceaccount.default.sa.123.example.com"
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "myserviceaccount.default.sa.123.example.com"
    "kubernetes.io/cluster/123.example.com" = "owned"
    "service-account.kops.k8s.io/name"      = "myserviceaccount"
    "service-account.kops.k8s.io/namespace" = "default"
  }
}

resource "aws_iam_role" "nodes-123-example-com" {
  assume_role_policy = file("${path.module}/data/aws_iam_role_nodes.123.example.com_policy")
  name               = "nodes.123.example.com"
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "nodes.123.example.com"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
}

resource "aws_iam_role_policy" "masters-123-example-com" {
  name   = "masters.123.example.com"
  policy = file("${path.module}/data/aws_iam_role_policy_masters.123.example.com_policy")
  role   = aws_iam_role.masters-123-example-com.name
}

resource "aws_iam_role_policy" "myotherserviceaccount-myapp-sa-123-example-com" {
  name   = "myotherserviceaccount.myapp.sa.123.example.com"
  policy = file("${path.module}/data/aws_iam_role_policy_myotherserviceaccount.myapp.sa.123.example.com_policy")
  role   = aws_iam_role.myotherserviceaccount-myapp-sa-123-example-com.name
}

resource "aws_iam_role_policy" "nodes-123-example-com" {
  name   = "nodes.123.example.com"
  policy = file("${path.module}/data/aws_iam_role_policy_nodes.123.example.com_policy")
  role   = aws_iam_role.nodes-123-example-com.name
}

resource "aws_iam_role_policy_attachment" "external-myserviceaccount-default-sa-123-example-com-3197825879" {
  policy_arn = "arn:aws-test:iam::123456789012:policy/UsersManageOwnCredentials"
  role       = aws_iam_role.myserviceaccount-default-sa-123-example-com.name
}

resource "aws_internet_gateway" "prefix_123-example-com" {
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "123.example.com"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
  vpc_id = aws_vpc.prefix_123-example-com.id
}

resource "aws_key_pair" "kubernetes-123-example-com-c4a6ed9aa889b9e2c39cd663eb9c7157" {
  key_name   = "kubernetes.123.example.com-c4:a6:ed:9a:a8:89:b9:e2:c3:9c:d6:63:eb:9c:71:57"
  public_key = file("${path.module}/data/aws_key_pair_kubernetes.123.example.com-c4a6ed9aa889b9e2c39cd663eb9c7157_public_key")
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "123.example.com"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
}

resource "aws_launch_template" "master-us-test-1a-masters-123-example-com" {
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      encrypted             = true
      iops                  = 3000
      throughput            = 125
      volume_size           = 64
      volume_type           = "gp3"
    }
  }
  block_device_mappings {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.masters-123-example-com.id
  }
  image_id      = "ami-12345678"
  instance_type = "m3.medium"
  key_name      = aws_key_pair.kubernetes-123-example-com-c4a6ed9aa889b9e2c39cd663eb9c7157.id
  lifecycle {
    create_before_destroy = true
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
  }
  monitoring {
    enabled = false
  }
  name = "master-us-test-1a.masters.123.example.com"
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    ipv6_address_count          = 0
    security_groups             = [aws_security_group.masters-123-example-com.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      "KubernetesCluster"                                                                                     = "123.example.com"
      "Name"                                                                                                  = "master-us-test-1a.masters.123.example.com"
      "aws-node-termination-handler/managed"                                                                  = ""
      "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"                         = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"                   = ""
      "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers" = ""
      "k8s.io/role/control-plane"                                                                             = "1"
      "k8s.io/role/master"                                                                                    = "1"
      "kops.k8s.io/instancegroup"                                                                             = "master-us-test-1a"
      "kubernetes.io/cluster/123.example.com"                                                                 = "owned"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      "KubernetesCluster"                                                                                     = "123.example.com"
      "Name"                                                                                                  = "master-us-test-1a.masters.123.example.com"
      "aws-node-termination-handler/managed"                                                                  = ""
      "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"                         = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"                   = ""
      "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers" = ""
      "k8s.io/role/control-plane"                                                                             = "1"
      "k8s.io/role/master"                                                                                    = "1"
      "kops.k8s.io/instancegroup"                                                                             = "master-us-test-1a"
      "kubernetes.io/cluster/123.example.com"                                                                 = "owned"
    }
  }
  tags = {
    "KubernetesCluster"                                                                                     = "123.example.com"
    "Name"                                                                                                  = "master-us-test-1a.masters.123.example.com"
    "aws-node-termination-handler/managed"                                                                  = ""
    "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"                         = ""
    "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"                   = ""
    "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers" = ""
    "k8s.io/role/control-plane"                                                                             = "1"
    "k8s.io/role/master"                                                                                    = "1"
    "kops.k8s.io/instancegroup"                                                                             = "master-us-test-1a"
    "kubernetes.io/cluster/123.example.com"                                                                 = "owned"
  }
  user_data = filebase64("${path.module}/data/aws_launch_template_master-us-test-1a.masters.123.example.com_user_data")
}

resource "aws_launch_template" "nodes-123-example-com" {
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      encrypted             = true
      iops                  = 3000
      throughput            = 125
      volume_size           = 128
      volume_type           = "gp3"
    }
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.nodes-123-example-com.id
  }
  image_id      = "ami-12345678"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.kubernetes-123-example-com-c4a6ed9aa889b9e2c39cd663eb9c7157.id
  lifecycle {
    create_before_destroy = true
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
  }
  monitoring {
    enabled = false
  }
  name = "nodes.123.example.com"
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    ipv6_address_count          = 0
    security_groups             = [aws_security_group.nodes-123-example-com.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      "KubernetesCluster"                                                          = "123.example.com"
      "Name"                                                                       = "nodes.123.example.com"
      "aws-node-termination-handler/managed"                                       = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
      "k8s.io/role/node"                                                           = "1"
      "kops.k8s.io/instancegroup"                                                  = "nodes"
      "kubernetes.io/cluster/123.example.com"                                      = "owned"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      "KubernetesCluster"                                                          = "123.example.com"
      "Name"                                                                       = "nodes.123.example.com"
      "aws-node-termination-handler/managed"                                       = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
      "k8s.io/role/node"                                                           = "1"
      "kops.k8s.io/instancegroup"                                                  = "nodes"
      "kubernetes.io/cluster/123.example.com"                                      = "owned"
    }
  }
  tags = {
    "KubernetesCluster"                                                          = "123.example.com"
    "Name"                                                                       = "nodes.123.example.com"
    "aws-node-termination-handler/managed"                                       = ""
    "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
    "k8s.io/role/node"                                                           = "1"
    "kops.k8s.io/instancegroup"                                                  = "nodes"
    "kubernetes.io/cluster/123.example.com"                                      = "owned"
  }
  user_data = filebase64("${path.module}/data/aws_launch_template_nodes.123.example.com_user_data")
}

resource "aws_route" "route-0-0-0-0--0" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.prefix_123-example-com.id
  route_table_id         = aws_route_table.prefix_123-example-com.id
}

resource "aws_route" "route-__--0" {
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.prefix_123-example-com.id
  route_table_id              = aws_route_table.prefix_123-example-com.id
}

resource "aws_route_table" "prefix_123-example-com" {
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "123.example.com"
    "kubernetes.io/cluster/123.example.com" = "owned"
    "kubernetes.io/kops/role"               = "public"
  }
  vpc_id = aws_vpc.prefix_123-example-com.id
}

resource "aws_route_table_association" "us-test-1a-123-example-com" {
  route_table_id = aws_route_table.prefix_123-example-com.id
  subnet_id      = aws_subnet.us-test-1a-123-example-com.id
}

resource "aws_s3_object" "cluster-completed-spec" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_cluster-completed.spec_content")
  key                    = "clusters.example.com/123.example.com/cluster-completed.spec"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "discovery-json" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_discovery.json_content")
  key                    = "discovery.example.com/123.example.com/.well-known/openid-configuration"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "etcd-cluster-spec-events" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_etcd-cluster-spec-events_content")
  key                    = "clusters.example.com/123.example.com/backups/etcd/events/control/etcd-cluster-spec"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "etcd-cluster-spec-main" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_etcd-cluster-spec-main_content")
  key                    = "clusters.example.com/123.example.com/backups/etcd/main/control/etcd-cluster-spec"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "keys-json" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_keys.json_content")
  key                    = "discovery.example.com/123.example.com/openid/v1/jwks"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "kops-version-txt" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_kops-version.txt_content")
  key                    = "clusters.example.com/123.example.com/kops-version.txt"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "manifests-etcdmanager-events-master-us-test-1a" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_manifests-etcdmanager-events-master-us-test-1a_content")
  key                    = "clusters.example.com/123.example.com/manifests/etcd/events-master-us-test-1a.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "manifests-etcdmanager-main-master-us-test-1a" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_manifests-etcdmanager-main-master-us-test-1a_content")
  key                    = "clusters.example.com/123.example.com/manifests/etcd/main-master-us-test-1a.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "manifests-static-kube-apiserver-healthcheck" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_manifests-static-kube-apiserver-healthcheck_content")
  key                    = "clusters.example.com/123.example.com/manifests/static/kube-apiserver-healthcheck.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "nodeupconfig-master-us-test-1a" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_nodeupconfig-master-us-test-1a_content")
  key                    = "clusters.example.com/123.example.com/igconfig/control-plane/master-us-test-1a/nodeupconfig.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "nodeupconfig-nodes" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_nodeupconfig-nodes_content")
  key                    = "clusters.example.com/123.example.com/igconfig/node/nodes/nodeupconfig.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "prefix_123-example-com-addons-aws-cloud-controller-addons-k8s-io-k8s-1-18" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_123.example.com-addons-aws-cloud-controller.addons.k8s.io-k8s-1.18_content")
  key                    = "clusters.example.com/123.example.com/addons/aws-cloud-controller.addons.k8s.io/k8s-1.18.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "prefix_123-example-com-addons-aws-ebs-csi-driver-addons-k8s-io-k8s-1-17" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_123.example.com-addons-aws-ebs-csi-driver.addons.k8s.io-k8s-1.17_content")
  key                    = "clusters.example.com/123.example.com/addons/aws-ebs-csi-driver.addons.k8s.io/k8s-1.17.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "prefix_123-example-com-addons-bootstrap" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_123.example.com-addons-bootstrap_content")
  key                    = "clusters.example.com/123.example.com/addons/bootstrap-channel.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "prefix_123-example-com-addons-coredns-addons-k8s-io-k8s-1-12" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_123.example.com-addons-coredns.addons.k8s.io-k8s-1.12_content")
  key                    = "clusters.example.com/123.example.com/addons/coredns.addons.k8s.io/k8s-1.12.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "prefix_123-example-com-addons-dns-controller-addons-k8s-io-k8s-1-12" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_123.example.com-addons-dns-controller.addons.k8s.io-k8s-1.12_content")
  key                    = "clusters.example.com/123.example.com/addons/dns-controller.addons.k8s.io/k8s-1.12.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "prefix_123-example-com-addons-kops-controller-addons-k8s-io-k8s-1-16" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_123.example.com-addons-kops-controller.addons.k8s.io-k8s-1.16_content")
  key                    = "clusters.example.com/123.example.com/addons/kops-controller.addons.k8s.io/k8s-1.16.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "prefix_123-example-com-addons-kubelet-api-rbac-addons-k8s-io-k8s-1-9" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_123.example.com-addons-kubelet-api.rbac.addons.k8s.io-k8s-1.9_content")
  key                    = "clusters.example.com/123.example.com/addons/kubelet-api.rbac.addons.k8s.io/k8s-1.9.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "prefix_123-example-com-addons-limit-range-addons-k8s-io" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_123.example.com-addons-limit-range.addons.k8s.io_content")
  key                    = "clusters.example.com/123.example.com/addons/limit-range.addons.k8s.io/v1.5.0.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "prefix_123-example-com-addons-node-termination-handler-aws-k8s-1-11" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_123.example.com-addons-node-termination-handler.aws-k8s-1.11_content")
  key                    = "clusters.example.com/123.example.com/addons/node-termination-handler.aws/k8s-1.11.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_object" "prefix_123-example-com-addons-storage-aws-addons-k8s-io-v1-15-0" {
  bucket                 = "testingBucket"
  content                = file("${path.module}/data/aws_s3_object_123.example.com-addons-storage-aws.addons.k8s.io-v1.15.0_content")
  key                    = "clusters.example.com/123.example.com/addons/storage-aws.addons.k8s.io/v1.15.0.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_security_group" "masters-123-example-com" {
  description = "Security group for masters"
  name        = "masters.123.example.com"
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "masters.123.example.com"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
  vpc_id = aws_vpc.prefix_123-example-com.id
}

resource "aws_security_group" "nodes-123-example-com" {
  description = "Security group for nodes"
  name        = "nodes.123.example.com"
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "nodes.123.example.com"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
  vpc_id = aws_vpc.prefix_123-example-com.id
}

resource "aws_security_group_rule" "from-0-0-0-0--0-ingress-tcp-22to22-masters-123-example-com" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.masters-123-example-com.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "from-0-0-0-0--0-ingress-tcp-22to22-nodes-123-example-com" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.nodes-123-example-com.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "from-0-0-0-0--0-ingress-tcp-443to443-masters-123-example-com" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.masters-123-example-com.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "from-masters-123-example-com-egress-all-0to0-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.masters-123-example-com.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-masters-123-example-com-egress-all-0to0-__--0" {
  from_port         = 0
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "-1"
  security_group_id = aws_security_group.masters-123-example-com.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-masters-123-example-com-ingress-all-0to0-masters-123-example-com" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.masters-123-example-com.id
  source_security_group_id = aws_security_group.masters-123-example-com.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-masters-123-example-com-ingress-all-0to0-nodes-123-example-com" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nodes-123-example-com.id
  source_security_group_id = aws_security_group.masters-123-example-com.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-123-example-com-egress-all-0to0-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nodes-123-example-com.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-nodes-123-example-com-egress-all-0to0-__--0" {
  from_port         = 0
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "-1"
  security_group_id = aws_security_group.nodes-123-example-com.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-nodes-123-example-com-ingress-all-0to0-nodes-123-example-com" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nodes-123-example-com.id
  source_security_group_id = aws_security_group.nodes-123-example-com.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-123-example-com-ingress-tcp-1to2379-masters-123-example-com" {
  from_port                = 1
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-123-example-com.id
  source_security_group_id = aws_security_group.nodes-123-example-com.id
  to_port                  = 2379
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-123-example-com-ingress-tcp-2382to4000-masters-123-example-com" {
  from_port                = 2382
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-123-example-com.id
  source_security_group_id = aws_security_group.nodes-123-example-com.id
  to_port                  = 4000
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-123-example-com-ingress-tcp-4003to65535-masters-123-example-com" {
  from_port                = 4003
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-123-example-com.id
  source_security_group_id = aws_security_group.nodes-123-example-com.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-123-example-com-ingress-udp-1to65535-masters-123-example-com" {
  from_port                = 1
  protocol                 = "udp"
  security_group_id        = aws_security_group.masters-123-example-com.id
  source_security_group_id = aws_security_group.nodes-123-example-com.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_sqs_queue" "prefix_123-example-com-nth" {
  message_retention_seconds = 300
  name                      = "123-example-com-nth"
  policy                    = file("${path.module}/data/aws_sqs_queue_123-example-com-nth_policy")
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "123-example-com-nth"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
}

resource "aws_subnet" "us-test-1a-123-example-com" {
  availability_zone                           = "us-test-1a"
  cidr_block                                  = "172.20.32.0/19"
  enable_resource_name_dns_a_record_on_launch = true
  private_dns_hostname_type_on_launch         = "resource-name"
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "us-test-1a.123.example.com"
    "SubnetType"                            = "Public"
    "kubernetes.io/cluster/123.example.com" = "owned"
    "kubernetes.io/role/elb"                = "1"
    "kubernetes.io/role/internal-elb"       = "1"
  }
  vpc_id = aws_vpc.prefix_123-example-com.id
}

resource "aws_vpc" "prefix_123-example-com" {
  assign_generated_ipv6_cidr_block = true
  cidr_block                       = "172.20.0.0/16"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "123.example.com"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "prefix_123-example-com" {
  domain_name         = "us-test-1.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    "KubernetesCluster"                     = "123.example.com"
    "Name"                                  = "123.example.com"
    "kubernetes.io/cluster/123.example.com" = "owned"
  }
}

resource "aws_vpc_dhcp_options_association" "prefix_123-example-com" {
  dhcp_options_id = aws_vpc_dhcp_options.prefix_123-example-com.id
  vpc_id          = aws_vpc.prefix_123-example-com.id
}

terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      "configuration_aliases" = [aws.files]
      "source"                = "hashicorp/aws"
      "version"               = ">= 5.0.0"
    }
  }
}
