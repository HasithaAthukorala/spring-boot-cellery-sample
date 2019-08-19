package br.com.example.microservices.uis.controllers;


import java.util.List;
import java.util.logging.Logger;

import br.com.example.microservices.uis.models.Article;
import br.com.example.microservices.uis.models.Author;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

@Controller
public class UIController {

    private Logger logger = Logger.getLogger(UIController.class.getName());

    public UIController() {}

    @RequestMapping(path = "/", method = RequestMethod.GET)
    public String ui(Model model) {

        logger.info("ARTICLE_URL : " + System.getenv("ARTICLE_URL"));
        logger.info("AUTHOR_URL : " + System.getenv("AUTHOR_URL"));

        RestTemplate articleTemplate = new RestTemplate();
        ResponseEntity<List<Article>> responseFromArticles = articleTemplate.exchange(
                System.getenv("ARTICLE_URL"),
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Article>>(){});
        List<Article> articles = responseFromArticles.getBody();
        model.addAttribute("articles", articles);

        RestTemplate authorTemplate = new RestTemplate();
        ResponseEntity<List<Author>> responseFromAuthors = authorTemplate.exchange(
                System.getenv("AUTHOR_URL"),
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Author>>(){});
        List<Author> authors = responseFromAuthors.getBody();
        model.addAttribute("authors", authors);

        return "ui";
    }
}
