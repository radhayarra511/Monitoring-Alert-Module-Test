# Dataproc

Dataproc is a managed Spark and Hadoop service that lets you take advantage of open source data tools for batch processing, querying, streaming, and machine learning. Dataproc automation helps you create clusters quickly, manage them easily, and save money by turning clusters off when you don't need them.

## Usage

```hcl
module "dataproc" {
  source = "git::https://infygithub.ad.infosys.com/ciscld-gcp/terraform-gcp-dataproc?ref=v0.0.1"
  dataproc_cluster_name         = "mycluster"
  region_name                   = "us-east1"
  project_id                    = "ciscldgcp-training"
  graceful_decommission_timeout = "120s"
  labels = {
    foo                          = "bar"
    ##Replace this with the actual cluster details after creation
    "goog-dataproc-cluster-name" = "mycluster"
    "goog-dataproc-cluster-uuid" = "85c39759-f8f6-4437-93a2-01cdc1436d84"
    "goog-dataproc-location"     = "us-east1"
  }

  cluster_config = [{
      
      staging_bucket = "gs://dataproc-staging-us"

      gce_cluster_config = {
      zone                   = "us-east1-c"
      network                = "default"
      service_account_scopes = [
        "https://www.googleapis.com/auth/bigquery",
        "https://www.googleapis.com/auth/bigtable.admin.table",
        "https://www.googleapis.com/auth/bigtable.data",
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
        "https://www.googleapis.com/auth/devstorage.full_control",
        "https://www.googleapis.com/auth/devstorage.read_write",
        "https://www.googleapis.com/auth/logging.write",
      ]

      shielded_instance_config = {
        enable_secure_boot          = "true"
        enable_vtpm                 = "true"
        enable_integrity_monitoring = "true"
      }
    }

    master_config = {
      num_instances = 3
      machine_type  = "n1-standard-4"
      min_cpu_platform = "AUTOMATIC"

      disk_config = {
        boot_disk_type = "pd-standard"
        boot_disk_size_gb = "1000"
        num_local_ssds    = 0
      }
    }

    initialization_action = [
      {
        script = "gs://"
        timeout_sec = "600"
      },
      {
        script = "gs://"
        timeout_sec = "600"
      },
      {
        script = "gs://"
        timeout_sec = "600"
      }
    ]
  }]
}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dataproc_cluster_name | The name of the cluster, unique within the project and zone. | `string` | n/a | yes |
| region_name | The region in which the cluster and associated nodes will be created in. Defaults to global. | `string` | n/a | yes |
| project_id | The ID of the project in which the cluster will exist. | `string` | n/a | yes |
| graceful_decommission_timeout | Allows graceful decomissioning when you change the number of worker nodes directly through a terraform apply. Does not affect auto scaling decomissioning from an autoscaling policy. Graceful decommissioning allows removing nodes from the cluster without interrupting jobs in progress. Timeout specifies how long to wait for jobs in progress to finish before forcefully removing nodes (and potentially interrupting jobs). Default timeout is 0 (for forceful decommission), and the maximum allowed timeout is 1 day. (see JSON representation of Duration). Only supported on Dataproc image versions 1.2 and higher. For more context see the docs | `string` | `0` | no |
| labels | The list of labels (key/value pairs) to be applied to instances in the cluster. GCP generates some itself including goog-dataproc-cluster-name which is the name of the cluster. | `map(string)` | `{}` | no |
| cluster_config | Allows you to configure various aspects of the cluster. | `list(any)` | n/a | yes |
