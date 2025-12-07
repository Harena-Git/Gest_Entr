package com.example.gestion.services;

import com.example.gestion.dto.*;
import java.time.LocalDate;
import java.util.List;
import com.example.gestion.dto.AncienneteDTO;
import com.example.gestion.repository.PersonnelRepository;
import com.example.gestion.repository.PresenceAbsenceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;

@Service
public class StatisticsService {

    @Autowired
    private PersonnelRepository personnelRepo;
        
    @Autowired
    private PresenceAbsenceRepository presenceRepo;

    public List<AncienneteDTO> getAncienneteParDepartement() {
    List<Object[]> raw = personnelRepo.countByAncienneteAndDepartement();
    List<AncienneteDTO> list = new ArrayList<>();

    for (Object[] row : raw) {
        list.add(new AncienneteDTO(
            (String) row[0],
            (String) row[1],
            (Long) row[2]
        ));
    }

        return list;
    }

   
   public List<AbsenceRateDTO> computeAbsenceRate(LocalDate start, LocalDate end) {
        java.sql.Date sqlStart = java.sql.Date.valueOf(start);
        java.sql.Date sqlEnd = java.sql.Date.valueOf(end);

        List<Object[]> results = presenceRepo.getAbsenceRateByDepartement(sqlStart, sqlEnd);
        List<AbsenceRateDTO> list = new ArrayList<>();

        for(Object[] row : results) {
            AbsenceRateDTO dto = new AbsenceRateDTO();
            dto.setDepartement((String) row[0]);
            dto.setTauxAbsent(((Number) row[3]).doubleValue());
            list.add(dto);
        }
        return list;
    }




}