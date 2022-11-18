

dependencies:
	mkdir -p roles/
	cp -r custom_roles/* roles
	ansible-galaxy install -r requirements.yml -p ./roles

install: dependencies
	ansible-playbook -i inventory.yml --ask-become-pass install-tools.yml
	ansible-playbook -i inventory.yml --ask-become-pass install-langs.yml

