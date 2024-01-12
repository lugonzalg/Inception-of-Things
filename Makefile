VAGRANT="./InceptionOfThings"

.PHONY: all build clean fclean

build-p1:
	VAGRANT_VAGRANTFILE=./InceptionOfThings/p1
	vagrant up