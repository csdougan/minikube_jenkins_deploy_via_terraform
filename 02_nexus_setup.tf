variable nexus_image_name {
  default = "sonatype/nexus"
}
variable nexus_image_version {
  default = "latest"
}
variable nexus_port {
  default = "8081"
}
variable nexus_svc_port {
  default = "30081"
}

resource "kubernetes_pod" "nexus" {
  metadata {
    name = "sonatype-nexus-2"
    labels {
      app = "nexus"
    }
  }

  spec {
    container {
      image = "${var.nexus_image_name}:${var.nexus_image_version}"
      name  = "nexus2"

      port {
        container_port = "${var.nexus_port}"
      }
    }
  }
}

resource "kubernetes_service" "nexus-svc" {
  metadata {
    name = "nexus-svc"
  }
  spec {
    selector {
#      run = "${kubernetes_pod.nexus.metadata.0.labels.run}"
      app = "nexus"
    }
    port {
      port = "${var.nexus_port}"
      node_port = "${var.nexus_svc_port}"
    }
 
    type = "NodePort"
  }
}




