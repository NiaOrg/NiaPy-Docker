build: 
	docker build -t "niapyorg" .

sslkey:
	openssl genrsa -des3 -out file_lock.key 2048
	openssl rsa -in file_lock.key -out jupyter_server.key
	openssl req -x509 -new -nodes -key jupyter_server.key -sha256 -days 1024 -out jupyter_cert.pem
	
run:
	docker run --name niapyorg-server \
		-p 164.8.230.37:9999:9999 \
		-d niapyorg

start:
	docker start niapyorg-server

stop:
	docker container stop niapyorg-server

remove:
	docker container rm niapyorg-server

clean:
	docker image rm niapyorg
