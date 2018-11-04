function cleos(){ 
	docker exec -it eosf cleos "$@"
}

function cleosk(){
	docker exec -it keosd cleos --wallet-url http://127.0.0.1:9876 "$@"
}

