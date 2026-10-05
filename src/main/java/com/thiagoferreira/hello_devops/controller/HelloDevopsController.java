package com.thiagoferreira.hello_devops.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloDevopsController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello World";
    }
}
