.PHONY: tf-init tf-plan tf-apply arc-install

tf-init:
	cd terraform/libvirt && terraform init

tf-plan:
	cd terraform/libvirt && terraform plan

tf-apply:
	cd terraform/libvirt && terraform apply

arc-install:
	./k8s/arc/install.sh
