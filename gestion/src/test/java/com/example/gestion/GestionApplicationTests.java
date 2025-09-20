package com.example.gestion;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

@SpringBootTest
@TestPropertySource(locations = "classpath:application.properties")
class GestionApplicationTests {

    @Test
    void contextLoads() {
        // This test verifies that the Spring context loads correctly
    }

}
