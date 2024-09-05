package com.example.ws;

import javax.jws.WebMethod;
import javax.jws.WebService;

@WebService
public class Service2 {

	@WebMethod
	public String sayHello(String name) {
		return String.format("Hello, %s", name);
	}
	
	@WebMethod
	public String ping() {
		return String.format("Pong");
	}

}
