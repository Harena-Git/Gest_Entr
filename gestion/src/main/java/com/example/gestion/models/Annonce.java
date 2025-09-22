package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "annonce")
public class Annonce {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_annonce;

    private String date_annonce;

    @Column(columnDefinition = "TEXT")
    private String responsabilite;

    private Date date_fin;

    @ManyToOne
    @JoinColumn(name = "id_poste", nullable = false)
    private Poste poste;

    @ManyToOne
    @JoinColumn(name = "id_profil", nullable = false)
    private Profil profil;

    public Integer getId_annonce() { return id_annonce; }
    public void setId_annonce(Integer id_annonce) { this.id_annonce = id_annonce; }

    public String getDate_annonce() { return date_annonce; }
    public void setDate_annonce(String date_annonce) { this.date_annonce = date_annonce; }

    public String getResponsabilite() { return responsabilite; }
    public void setResponsabilite(String responsabilite) { this.responsabilite = responsabilite; }

    public Date getDate_fin() { return date_fin; }
    public void setDate_fin(Date date_fin) { this.date_fin = date_fin; }

    public Poste getPoste() { return poste; }
    public void setPoste(Poste poste) { this.poste = poste; }

    public Profil getProfil() { return profil; }
    public void setProfil(Profil profil) { this.profil = profil; }
}
