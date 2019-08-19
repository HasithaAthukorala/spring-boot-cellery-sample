package br.com.example.microservices.articles.controllers;

import br.com.example.microservices.articles.models.Article;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class ArticleController {

    private List<Article> articles;
    private Logger logger = Logger.getLogger(ArticleController.class.getName());

    public ArticleController() {
        this.articles = new ArrayList<>();

        this.articles.add(new Article(1, "First Article", new Date(), 1));
        this.articles.add(new Article(2, "Second Article", new Date(), 2));
        this.articles.add(new Article(3, "Third Article", new Date(), 2));
        this.articles.add(new Article(4, "Fourth Article", new Date(), 1));
        this.articles.add(new Article(5, "Fifth Article", new Date(), 1));
    }

    @HystrixCommand(fallbackMethod = "getAllCached")
    @RequestMapping(path = "/", method = RequestMethod.GET)
    public List<Article> getAll() {
        this.logger.info("Articles.getAll()");
        return this.articles;
    }

    public List<Article> getAllCached() {
        this.logger.info("Articles.getAllCached()");
        this.logger.warning("Return cached result here");

        return new ArrayList<>();
    }
}
