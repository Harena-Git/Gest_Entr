package com.example.gestion.models;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "TypeRetenu")
public class TypeRetenu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_TypeRetenu")
    private Integer id;

    @Column(name = "libelle", length = 50)
    private String libelle;

    @Column(name = "taux")
    private Double taux;

    @Enumerated(EnumType.STRING)
    @Column(name = "type_enum", length = 20)
    private TypeEnum typeEnum;  // <-- Ajout de l'enum

    @OneToMany(mappedBy = "typeRetenu")
    private List<Retenu> retenus;

    // Getters et setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    public Double getTaux() { return taux; }
    public void setTaux(Double taux) { this.taux = taux; }

    public TypeEnum getTypeEnum() { return typeEnum; }
    public void setTypeEnum(TypeEnum typeEnum) { this.typeEnum = typeEnum; }

    public List<Retenu> getRetenus() { return retenus; }
    public void setRetenus(List<Retenu> retenus) { this.retenus = retenus; }
}
