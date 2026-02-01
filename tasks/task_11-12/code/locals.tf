locals {
  formatted_project_name = lower(replace(var.project_name, " ", "-"))
  tags = merge(var.default_tags, var.environmental_tags)
  formatted_bucketname=replace(replace(substr(lower(var.bucket_name), 0, 63), " ", "-"), "!", "")
  
  port_list = split(",", var.allowed_ports)

 
  sg_rules = [
    // loop
    for port in local.port_list :
      {
        name = "port-${port}"  // Interpolation
        port = port
        description = "Allowed traffic on port ${port}"
      }
  ]

  instance_size = lookup(var.instance_sizes, var.environment, "t2.micro")
}