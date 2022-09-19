
## **Storage** 

This module makes it easy to create a GCS bucket, and assign basic permissions on it to arbitrary users.

## **Usage**
---
module "storage-bucket" {
  source                      = "git::https://gitprd.cn.ca/scm/gcpsciot/cloud-storage-module//storage-bucket?ref=tags/v1.0.1"
  for_each                    = local.buckets
  bucket_name                 = each.value.bucketname
  bucket_location             = var.region
  project_id                  = each.value.project_id
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  versioning                  = false
  labels                      = { env = "${var.env}", purpose = each.value.purpose }
}
---

## Inputs

| **Name** | **Description** | **Type** | **Default** | **Required** |
|------|-------------|------|---------|:--------:|
| bucket\_policy\_only | Enables Bucket Policy Only access to a bucket. | `bool` | `true` | no |
| encryption | A Cloud KMS key that will be used to encrypt objects inserted into this bucket | <pre>object({<br>    default_kms_key_name = string<br>  })</pre> | `null` | no |
| force\_destroy | When deleting a bucket, this boolean option will delete all contained objects. If false, Terraform will fail to delete buckets which contain objects. | `bool` | `false` | no |
| iam\_members | The list of IAM members to grant permissions on the bucket. | <pre>list(object({<br>    role   = string<br>    member = string<br>  }))</pre> | `[]` | no |
| labels | A set of key/value label pairs to assign to the bucket. | `map(string)` | `null` | no |
| lifecycle\_rules | The bucket's Lifecycle Rules configuration. | <pre>list(object({<br>    # Object with keys:<br>    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.<br>    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.<br>    action = any<br><br>    # Object with keys:<br>    # - age - (Optional) Minimum age of an object in days to satisfy this condition.<br>    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.<br>    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".<br>    # - matches_storage_class - (Optional) Storage Class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.<br>    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.<br>    condition = any<br>  }))</pre> | `[]` | no |
| location | The location of the bucket. | `string` | n/a | yes |
| log\_bucket | The bucket that will receive log objects. | `string` | `null` | no |
| log\_object\_prefix | The object prefix for log objects. If it's not provided, by default GCS sets this to this bucket's name | `string` | `null` | no |
| name | The name of the bucket. | `string` | n/a | yes |
| project\_id | The ID of the project to create the bucket in. | `string` | n/a | yes |
| retention\_policy | Configuration of the bucket's data retention policy for how long objects in the bucket should be retained. | <pre>object({<br>    is_locked        = bool<br>    retention_period = number<br>  })</pre> | `null` | no |
| storage\_class | The Storage Class of the new bucket. | `string` | `null` | no |
| versioning | While set to true, versioning is fully enabled for this bucket. | `bool` | `true` | no |
| website | Map of website values. Supported attributes: main\_page\_suffix, not\_found\_page | `map(any)` | `{}` | no |

## Outputs

| **Name** | **Description** |
|------|-------------|
| bucket | The created storage bucket |
| name | Bucket name. |
| url | Bucket URL. |


=================================================================================================

## **Pubsub** 


This module makes it easy to create Google Cloud Pub/Sub topic and subscriptions associated with the topic.

## **Usage**
---
module "ordernode-order-outbound" {
  source       = "git::https://gitprd.cn.ca/scm/gcpsciot/pub-sub-module//pubsub?ref=tags/v1.0.1"
  project_id   = var.oms
  topic_name   = "ordernode-order-outbound"
  topic_labels = { env = "${var.env}", label = "order-outbound" }
  message_storage_policy = {
    allowed_persistence_regions = [var.region]
  }
  pull_subscriptions = []
  push_subscriptions = []
}
---




## Inputs

| **Name** | **Description** | **Type** | **Default** | **Required** |
|------|-------------|------|---------|:--------:|
| create\_subscriptions | Specify true if you want to create subscriptions. | `bool` | `true` | no |
| create\_topic | Specify true if you want to create a topic. | `bool` | `true` | no |
| enable\_exactly\_once\_delivery | Specify true if you want to the message sent to a subscriber is guaranteed not to be resent before the message's acknowledgement deadline expires. | `bool` | `false` | no |
| grant\_token\_creator | Specify true if you want to add token creator role to the default Pub/Sub SA. | `bool` | `true` | no |
| message\_storage\_policy | A map of storage policies. Default - inherit from organization's Resource Location Restriction policy. | `map(any)` | `{}` | no |
| project\_id | The project ID to manage the Pub/Sub resources. | `string` | n/a | yes |
| pull\_subscriptions | The list of the pull subscriptions. | `list(map(string))` | `[]` | no |
| push\_subscriptions | The list of the push subscriptions. | `list(map(string))` | `[]` | no |
| schema | Schema for the topic. | <pre>object({<br>    name       = string<br>    type       = string<br>    definition = string<br>    encoding   = string<br>  })</pre> | `null` | no |
| subscription\_labels | A map of labels to assign to every Pub/Sub subscription. | `map(string)` | `{}` | no |
| topic | The Pub/Sub topic name. | `string` | n/a | yes |
| topic\_kms\_key\_name | The resource name of the Cloud KMS CryptoKey to be used to protect access to messages published on this topic. | `string` | `null` | no |
| topic\_labels | A map of labels to assign to the Pub/Sub topic. | `map(string)` | `{}` | no |
| topic\_message\_retention\_duration | The minimum duration in seconds to retain a message after it is published to the topic. | `string` | `null` | no |

## Outputs

| **Name** | **Description** |
|------|-------------|
| id | The ID of the Pub/Sub topic |
| subscription\_names | The name list of Pub/Sub subscriptions |
| subscription\_paths | The path list of Pub/Sub subscriptions |
| topic | The name of the Pub/Sub topic |
| topic\_labels | Labels assigned to the Pub/Sub topic |
| uri | The URI of the Pub/Sub topic |


===============================================================================================================

## **Dataproc**

Dataproc is a managed Spark and Hadoop service that lets you take advantage of open source data tools
 for batch processing, querying, streaming, and machine learning. Dataproc automation helps you create clusters quickly, 
 manage them easily, and save money by turning clusters off when you don't need them.

## **Usage**


module "dataproc-cluster" {
  source                        = "git::https://gitprd.cn.ca/scm/gcpsciot/data-proc-module//dataproc?ref=tags/v1.0.0"
  dataproc_cluster_name         = "dq-dataproc-managed"
  region_name                   = var.region
  project_id                    = var.datacentral
  graceful_decommission_timeout = "120s"
  labels = {
    env = "${var.env}",label = "dq-dataproc"
  }

  cluster_config = [{

    staging_bucket = var.dataproc_bucket
    gce_cluster_config = {
      zone    = "${var.region}-a"
      subnetwork = var.subnetwork
      internal_ip_only = true
      tags = ["dataflow-${var.env}","dataproc-${var.env}","internal-ip-dq"]
      service_account = var.service_account
      shielded_instance_config = {
        enable_secure_boot          = "false"
        enable_vtpm                 = "false"
        enable_integrity_monitoring = "false"
      }
    }
    master_config = {
      num_instances    = 3
      machine_type     = "n1-standard-4"
      min_cpu_platform = "AUTOMATIC"
      disk_config = {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = "500"
        num_local_ssds    = 0
      }
    }
    worker_config = {
      num_instances    = 2
      machine_type     = "n1-standard-4"
      min_cpu_platform = "AUTOMATIC"
      disk_config = {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = "500"
        num_local_ssds    = 0
      }
    }
    software_config = {
      image_version       = "2.0.45-debian10"
      optional_components = ["JUPYTER"]
    }
  }]
}


## Inputs

| **Name** | **Description** | **Type** | **Default** | **Required** |
|------|-------------|------|---------|:--------:|
| dataproc_cluster_name | The name of the cluster, unique within the project and zone. | `string` | n/a | yes |
| region_name | The region in which the cluster and associated nodes will be created in. Defaults to global. | `string` | n/a | yes |
| project_id | The ID of the project in which the cluster will exist. | `string` | n/a | yes |
| graceful_decommission_timeout | Allows graceful decomissioning when you change the number of worker nodes directly through a terraform apply. Does not affect auto scaling decomissioning from an autoscaling policy. Graceful decommissioning allows removing nodes from the cluster without interrupting jobs in progress. Timeout specifies how long to wait for jobs in progress to finish before forcefully removing nodes (and potentially interrupting jobs). Default timeout is 0 (for forceful decommission), and the maximum allowed timeout is 1 day. (see JSON representation of Duration). Only supported on Dataproc image versions 1.2 and higher. For more context see the docs | `string` | `0` | no |
| labels | The list of labels (key/value pairs) to be applied to instances in the cluster. GCP generates some itself including goog-dataproc-cluster-name which is the name of the cluster. | `map(string)` | `{}` | no |
| cluster_config | Allows you to configure various aspects of the cluster. | `list(any)` | n/a | yes |


## Outputs

| **Name** | **Description** |
|------|-------------|
| cluster | The created cluster |
| name | Cluster name. |


===========================================================================================

 ## **private-service-connect**

 This module makes it easy to create allows private consumption of services across VPC networks.

## **Usage**:
Basic usage of this submodule is as follows:

  source              = "git::https://gitprd.cn.ca/scm/gcpsciot/private-service-conn-module//private-serv-conn?ref=tags/v1.0.0"
  project_id          = var.telecom_project_id
  network_name        = module.vpc-network.name
  ip_address_name     = "scio-psconnect-ip"
  ip_address          = var.private_service_connect_ip
  forward_rule_name   = "sciopscfwdrule"
  forward_rule_target = "all-apis"
}

## Inputs

| **Name** | **Description** | **Type** | **Default** | **Required** |
|------|-------------|------|---------|:--------:|
|project_id |	Project in which the private service connect will be deployed.	string	n/a	yes
|network_name | network in which the private service connect will be deployed. string n/a yes


## Outputs

| **Name** | **Description** |
|------|-------------|
|id | created private service connect id. |


## **Network Module**

This module makes it easy to set up a new VPC Network in GCP by defining your network and subnet ranges in a concise syntax.



## **Usage**
You can go to the examples folder, however the usage of the module could be like this in your own main.tf file:

module "vpc-network" {
  source       = "git::https://gitprd.cn.ca/scm/gcpsciot/network-module//network?ref=tags/v1.0.1"
  network_name = var.shared_vpc_name
  project_id   = var.telecom_project_id
  routing_mode = "GLOBAL" 
  subnets      = var.subnet_list
}
    

## Inputs

| **Name** | **Description** | **Type** | **Default** | **Required** |
|------|-------------|------|---------|:--------:|
| auto\_create\_subnetworks | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. | `bool` | `false` | no |
| delete\_default\_internet\_gateway\_routes | If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted | `bool` | `false` | no |
| description | An optional description of this resource. The resource must be recreated to modify this field. | `string` | `""` | no |
| firewall\_rules | List of firewall rules | `any` | `[]` | no |
| mtu | The network MTU (If set to 0, meaning MTU is unset - defaults to '1460'). Recommended values: 1460 (default for historic reasons), 1500 (Internet default), or 8896 (for Jumbo packets). Allowed are all values in the range 1300 to 8896, inclusively. | `number` | `0` | no |
| network\_name | The name of the network being created | `any` | n/a | yes |
| project\_id | The ID of the project where this VPC will be created | `any` | n/a | yes |
| routes | List of routes being created in this VPC | `list(map(string))` | `[]` | no |
| routing\_mode | The network routing mode (default 'GLOBAL') | `string` | `"GLOBAL"` | no |
| secondary\_ranges | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| shared\_vpc\_host | Makes this project a Shared VPC host if 'true' (default 'false') | `bool` | `false` | no |
| subnets | The list of subnets being created | `list(map(string))` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| network | The created network |
| network\_id | The ID of the VPC being created |
| network\_name | The name of the VPC being created |
| network\_self\_link | The URI of the VPC being created |
| project\_id | VPC project id |
| route\_names | The route names associated with this VPC |
| subnets | A map with keys of form subnet\_region/subnet\_name and values being the outputs of the google\_compute\_subnetwork resources used to create corresponding subnets. |
| subnets\_flow\_logs | Whether the subnets will have VPC flow logs enabled |
| subnets\_ids | The IDs of the subnets being created |
| subnets\_ips | The IPs and CIDRs of the subnets being created |
| subnets\_names | The names of the subnets being created |
| subnets\_private\_access | Whether the subnets will have access to Google API's without a public IP |
| subnets\_regions | The region where the subnets will be created |
| subnets\_secondary\_ranges | The secondary ranges associated with these subnets |
| subnets\_self\_links | The self-links of subnets being created |



### Subnet Inputs

The subnets list contains maps, where each object represents a subnet. Each map has the following inputs 

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| subnet\_name | The name of the subnet being created  | string | - | yes |
| subnet\_ip | The IP and CIDR range of the subnet being created | string | - | yes |
| subnet\_region | The region where the subnet will be created  | string | - | yes |
| subnet\_private\_access | Whether this subnet will have private Google access enabled | string | `"false"` | no |
| subnet\_flow\_logs  | Whether the subnet will record and send flow log data to logging | string | `"false"` | no |

======================================================================

## **VPC Serverless Connector**

It creates the vpc serverless connector using the beta components available.

## **Usage**
---
module "vpc-access-conn" {
  source     = "git::https://gitprd.cn.ca/scm/gcpsciot/serverless-vpc-connector-module//vpc-serverless-connector?ref=tags/v1.0.0"
  project_id = var.telecom_project_id
  vpc_connectors = [{
    connector_name  = var.connector01
    region          = var.region
    subnet_name     = var.connector_vpc_snet_name
    host_project_id = var.telecom_project_id
    machine_type    = "e2-standard-4"
    min_instances   = 2
    max_instances   = 5
    max_throughput  = 500
  }]
}
---

## Inputs
|**Name** |	**Description** |	**Type**	| **Default**	|**Required**
project_id |	Project in which the vpc connector will be deployed.|	string |	n/a|	yes
vpc_connectors |	List of VPC serverless connectors.	|list(map(string)) |	[] |	no

## Outputs
|**Name** |	**Description**
connector_ids	VPC serverless connector ID





