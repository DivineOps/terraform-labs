// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package main

import (
	"fmt"
	"log"
	"net"
	"net/http"
)

func sayHelloHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello World")
}

func healthzHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Ping")
}

// func insecureConnect()  {
//   user := "root"
//   myPassword := "supersecret"
//   url := "login=" + user + "&passwd=" + myPassword

//   var (
//     ip   = "127.0.0.1"
//     port = 3333
//   )
//   SocketClient(ip, port)
// }

func main() {
	http.HandleFunc("/", sayHelloHandler)
	http.HandleFunc("/healthz", healthzHandler)
	listener, err := net.Listen("tcp", ":80")
	if err != nil {
		log.Fatal("Listen failed: ", err)
	}
	fmt.Println("Server is listening on port", listener.Addr().(*net.TCPAddr).Port)
	log.Fatal(http.Serve(listener, nil))
}
