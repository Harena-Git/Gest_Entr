package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "profil_qcm")
public class ProfilQcm {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_profil_qcm;

    @ManyToOne
    @JoinColumn(name = "id_profil", nullable = false)
    private Profil profil;

    @ManyToOne
    @JoinColumn(name = "id_qcm", nullable = false)
    private Qcm qcm;

    public Integer getId_profil_qcm() { return id_profil_qcm; }
    public void setId_profil_qcm(Integer id_profil_qcm) { this.id_profil_qcm = id_profil_qcm; }

    public Profil getProfil() { return profil; }
    public void setProfil(Profil profil) { this.profil = profil; }

    public Qcm getQcm() { return qcm; }
    public void setQcm(Qcm qcm) { this.qcm = qcm; }
}
