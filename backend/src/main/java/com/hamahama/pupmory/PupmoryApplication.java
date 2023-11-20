package com.hamahama.pupmory;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@EnableJpaAuditing
@SpringBootApplication
public class PupmoryApplication {

	public static void main(String[] args) {
		SpringApplication.run(PupmoryApplication.class, args);
	}

}
