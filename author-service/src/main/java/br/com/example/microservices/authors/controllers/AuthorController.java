package br.com.example.microservices.authors.controllers;

import br.com.example.microservices.authors.models.Author;
import br.com.example.microservices.authors.models.AuthorType;
import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@RestController
public class AuthorController {

    private List<Author> authors;
    private Logger logger = Logger.getLogger(AuthorController.class.getName());

    public AuthorController() {
        this.authors = new ArrayList<>();

        this.authors.add(new Author(1, "Wendell Adriel", "wendelladriel.ti@gmail.com", AuthorType.EDITOR));
        this.authors.add(new Author(2, "John McQueide", "mcqueide@gmail.com", AuthorType.WRITER));
    }

    @HystrixCommand(fallbackMethod = "getAllCached")
    @RequestMapping(path = "/", method = RequestMethod.GET)
    public List<Author> getAll() {
        this.logger.info("Authors.getAll()");
        return this.authors;
    }

    public List<Author> getAllCached() {
        this.logger.info("Authors.getAllCached()");
        this.logger.warning("Return cached result here");

        return new ArrayList<>();
    }
}
