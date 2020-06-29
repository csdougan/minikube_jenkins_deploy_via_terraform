variable minikube_certs_path {
  default = "/Users/craig/.minikube/certs"
}

variable jenkins_image_name {
  default = "cdougan/jenkins_with_docker"
}
variable jenkins_image_version {
  default = "latest"
}
variable jenkins_port {
  default = "8080"
}
variable jenkins_svc_port {
  default = "30080"
}

resource "kubernetes_pod" "jenkins" {
  metadata {
    name = "jenkins-master"
    labels {
      app = "jenkins"
    }
  }

  spec {
    container {
      image = "${var.jenkins_image_name}:${var.jenkins_image_version}"
      name  = "jenkinsmaster"

      port {
        container_port = "${var.jenkins_port}"
      }
      volume_mount {
        name       = "minikube-certs"
        mount_path = "/etc/minikube/certs"
        read_only  = true
      }
    }
    volume {
      name = "minikube-certs"
      host_path {
        path = "${var.minikube_certs_path}"
      }
    }   
  }   
}

resource "kubernetes_service" "jenkins-svc" {
  metadata {
    name = "jenkins-svc"
  }
  spec {
    selector {
      app = "jenkins"
    }
    port {
      port = "${var.jenkins_port}"
      node_port = "${var.jenkins_svc_port}"
    }
 
    type = "NodePort"
  }
}

