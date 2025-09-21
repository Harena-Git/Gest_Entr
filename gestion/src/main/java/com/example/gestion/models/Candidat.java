package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "candidat")
public class Candidat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_candidat;

    private String nom;
    private String prenom;

    @Column(unique = true)
    private String email;

    @Lob
    private String photo;

    private String telephone;
    private String adresse;

    @Temporal(TemporalType.DATE)
    private Date date_candidature;

    private Integer annee_experience;

    @ManyToOne
    @JoinColumn(name = "Id_lieu")
    private Lieu lieu;

    @ManyToOne
    @JoinColumn(name = "Id_etat_candidat")
    private EtatCandidat etatCandidat;

    @OneToMany(mappedBy = "candidat")
    private List<HistoriqueEtat> historiqueEtats;

    @OneToMany(mappedBy = "candidat")
    private List<DiplomeCandidat> diplomesCandidats;

    @OneToMany(mappedBy = "candidat")
    private List<ContratEssai> contratsEssai;

    @OneToMany(mappedBy = "candidat")
    private List<Personnel> personnels;

    @OneToMany(mappedBy = "candidat")
    private List<Entretien1> entretien1;

    // Getters and Setters
    public Integer getId_candidat() { return id_candidat; }
    public void setId_candidat(Integer id_candidat) { this.id_candidat = id_candidat; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public Date getDate_candidature() { return date_candidature; }
    public void setDate_candidature(Date date_candidature) { this.date_candidature = date_candidature; }

    public Integer getAnnee_experience() { return annee_experience; }
    public void setAnnee_experience(Integer annee_experience) { this.annee_experience = annee_experience; }

    public Lieu getLieu() { return lieu; }
    public void setLieu(Lieu lieu) { this.lieu = lieu; }

    public EtatCandidat getEtatCandidat() { return etatCandidat; }
    public void setEtatCandidat(EtatCandidat etatCandidat) { this.etatCandidat = etatCandidat; }

    public List<HistoriqueEtat> getHistoriqueEtats() { return historiqueEtats; }
    public void setHistoriqueEtats(List<HistoriqueEtat> historiqueEtats) { this.historiqueEtats = historiqueEtats; }

    public List<DiplomeCandidat> getDiplomesCandidats() { return diplomesCandidats; }
    public void setDiplomesCandidats(List<DiplomeCandidat> diplomesCandidats) { this.diplomesCandidats = diplomesCandidats; }

    public List<ContratEssai> getContratsEssai() { return contratsEssai; }
    public void setContratsEssai(List<ContratEssai> contratsEssai) { this.contratsEssai = contratsEssai; }

    public List<Personnel> getPersonnels() { return personnels; }
    public void setPersonnels(List<Personnel> personnels) { this.personnels = personnels; }

    public List<Entretien1> getEntretien1() { return entretien1; }
    public void setEntretien1(List<Entretien1> entretien1) { this.entretien1 = entretien1; }
}
