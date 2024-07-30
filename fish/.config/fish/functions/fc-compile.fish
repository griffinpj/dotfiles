function fc-compile
	docker run -it --rm -v $PWD:/app/project telor/fontcustom-worker fontcustom compile
end
