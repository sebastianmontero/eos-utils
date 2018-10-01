function cleos(){
	docker exec -it nodeos cleos --url http://127.0.0.1:8888 --wallet-url http://172.18.0.3:9876 "$@"
}
