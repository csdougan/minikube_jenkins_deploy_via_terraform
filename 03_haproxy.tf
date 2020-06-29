variable image_name {
  default = "haproxy"
}
variable image_version {
  default = "latest"
}
variable port {
  default = "80"
}
variable svc_port {
  default = "80"
}

resource "kubernetes_pod" "haproxy" {
  metadata {
    name = "haproxy"
    labels {
      app = "haproxy"
    }
  }

  spec {
    container {
      image = "${var.image_name}:${var.image_version}"
      name  = "haproxy"

      port {
        container_port = "${var.port}"
      }
      volume_mount {
        name       = "haproxy-config"
        mount_path = "/usr/local/etc/haproxy/haproxy.cfg"
        read_only  = true
      }
    }
    volume {
      name = "haproxy-config"
      host_path {
        path = "/Users/craig/minikube-files/haproxy-config"
      }
    }

  }
}

resource "kubernetes_service" "haproxy-svc" {
  metadata {
    name = "haproxy-svc"
  }
  spec {
    selector {
#      run = "${kubernetes_pod.haproxy.metadata.0.labels.run}"
      app = "haproxy"
    }
    port {
      port = "${var.port}"
      node_port = "${var.svc_port}"
    }
 
    type = "NodePort"
  }
}




