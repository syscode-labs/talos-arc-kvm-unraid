.PHONY: tf-init tf-plan tf-apply arc-install kvm-autoscaler-apply

tf-init:
	cd terraform/libvirt && terraform init

tf-plan:
	cd terraform/libvirt && terraform plan

tf-apply:
	cd terraform/libvirt && terraform apply

arc-install:
	./k8s/arc/install.sh

kvm-autoscaler-apply:
	kubectl apply -k k8s/kvm-pool-autoscaler
