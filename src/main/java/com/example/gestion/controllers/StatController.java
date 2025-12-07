package com.example.gestion.controllers;

import com.example.gestion.dto.AbsenceRateDTO;
import com.example.gestion.dto.AncienneteDTO;
import com.example.gestion.repository.DepartementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.gestion.services.StatisticsService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.RequestParam;


import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/stat")
public class StatController {
    @Autowired
    private DepartementRepository departementRepository;

    @Autowired
    private StatisticsService statistiqueService;

    @Autowired
    private ObjectMapper objectMapper;

    @GetMapping("/personnel")
    public String statPersonnelParDepartement(Model model) {

        List<Object[]> stats = departementRepository.countPersonnelByDepartement();

        // Préparer les tableaux pour le JSP
        StringBuilder labels = new StringBuilder();
        StringBuilder values = new StringBuilder();

        labels.append("[");
        values.append("[");

        for (Object[] row : stats) {
            String depName = (String) row[1];
            Long total = (Long) row[2];

            labels.append("\"").append(depName).append("\",");
            values.append(total).append(",");
        }

        // retirer la dernière virgule
        if (stats.size() > 0) {
            labels.setLength(labels.length() - 1);
            values.setLength(values.length() - 1);
        }

        labels.append("]");
        values.append("]");

        // envoyer au JSP
        model.addAttribute("labels", labels.toString());
        model.addAttribute("values", values.toString());

        return "statistique/statPersonnel"; // ton JSP
    }

    @GetMapping("/stat-anciennete-dept")
    public String statAncienneteDept(Model model) {
        List<AncienneteDTO> stats = statistiqueService.getAncienneteParDepartement();
        String statsJson = "";
        try {
            statsJson = objectMapper.writeValueAsString(stats);
        } catch (JsonProcessingException e) {
            e.printStackTrace(); // ou gérer l'erreur autrement
        }
        model.addAttribute("statsAsJson", statsJson);
        return "statistique/statAncienneteDept"; // ton JSP

       
    }
    
    @GetMapping("/absenteisme")
    public String absenceRateByMonth(
            Model model,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Integer year) {

        // Si rien n’est passé → mois courant
        LocalDate now = LocalDate.now();
        int m = (month == null ? now.getMonthValue() : month);
        int y = (year == null ? now.getYear() : year);

        LocalDate start = LocalDate.of(y, m, 1);
        LocalDate end = start.withDayOfMonth(start.lengthOfMonth());

        List<AbsenceRateDTO> rates = statistiqueService.computeAbsenceRate(start, end);

        StringBuilder labels = new StringBuilder("[");
        StringBuilder values = new StringBuilder("[");
        for (AbsenceRateDTO dto : rates) {
            labels.append("\"").append(dto.getDepartement()).append("\",");
            values.append(dto.getTauxAbsent()).append(",");
        }
        if (!rates.isEmpty()) {
            labels.setLength(labels.length() - 1);
            values.setLength(values.length() - 1);
        }
        labels.append("]");
        values.append("]");

        model.addAttribute("labels", labels.toString());
        model.addAttribute("values", values.toString());

        return "statistique/absenceRate";
    }




}
