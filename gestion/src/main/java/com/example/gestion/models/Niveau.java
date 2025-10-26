/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.example.gestion.models;


import jakarta.persistence.*;

@Entity
@Table(name = "niveau")
public class Niveau {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id_niveau;

	private String libelle;

	public Integer getId_niveau() { return id_niveau; }
	public void setId_niveau(Integer id_niveau) { this.id_niveau = id_niveau; }

	public String getLibelle() { return libelle; }
	public void setLibelle(String libelle) { this.libelle = libelle; }
}
