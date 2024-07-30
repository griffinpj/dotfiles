function swpnode
	sudo n $argv[1] && sudo rm -R ./node_modules && sudo npm i && npm start
end
