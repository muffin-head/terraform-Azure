provider "databricks" {
  host = var.databricks_workspace_url
}
variable "databricks_workspace_url" {
  description = "The URL to the Azure Databricks workspace (must start with https://)"
  type = string
  default = "<Azure Databricks workspace URL>"
}

variable "resource_prefix" {
  description = "The prefix to use when naming the notebook and job"
  type = string
  default = "terraform-demo"
}

variable "email_notifier" {
  description = "The email address to send job status to"
  type = list(string)
  default = ["<Your email address>"]
}

data "databricks_current_user" "me" {}

resource "databricks_notebook" "this" {
  path     = "${data.databricks_current_user.me.home}/Terraform/${var.resource_prefix}-notebook.ipynb"
  language = "PYTHON"
  content_base64 = base64encode(<<-EOT
    # created from ${abspath(path.module)}
    display(spark.range(10))
    EOT
  )
}

data "databricks_node_type" "smallest" {
  local_disk = true
}

data "databricks_spark_version" "latest" {}

resource "databricks_job" "this" {
  name = "${var.resource_prefix}-job-${data.databricks_current_user.me.alphanumeric}"
  new_cluster {
    num_workers   = 1
    spark_version = data.databricks_spark_version.latest.id
    node_type_id  = data.databricks_node_type.smallest.id
  }
  notebook_task {
    notebook_path = databricks_notebook.this.path
  }
  email_notifications {
    on_success = var.email_notifier
    on_failure = var.email_notifier
  }
}

output "notebook_url" {
  value = databricks_notebook.this.url
}

output "job_url" {
  value = databricks_job.this.url
}
