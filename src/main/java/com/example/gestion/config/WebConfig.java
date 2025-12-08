package com.example.gestion.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {
    
    @Value("${file.upload-dir:uploads}")
    private String uploadDir;
    
    @Value("${file.releves-dir:releves}")
    private String relevesDir;
    
    @Value("${file.exports-dir:exports}")
    private String exportsDir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 🔧 CORRIGÉ : Chemins absolus pour Windows
        String basePath = "E:/HP/Documents/S5/Mr Tovo/Gest_Entr/src/main/resources/static/";
        
        // 1. Uploads (justificatifs, etc.)
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + basePath + "uploads/")
                .setCachePeriod(3600);
        
        // 2. Relevés (fichiers générés)
        registry.addResourceHandler("/releves/**")
                .addResourceLocations("file:" + basePath + "releves/")
                .setCachePeriod(3600);
        
        // 3. Exports paie
        registry.addResourceHandler("/exports/paie/**")
                .addResourceLocations("file:" + basePath + "exports/paie/")
                .setCachePeriod(3600);
        
        // 4. Static resources classiques
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/")
                .setCachePeriod(3600);
        
        // 5. CSS et JS
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/");
        
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/");
        
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/");
    }

    @Bean
    InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        return resolver;
    }
}