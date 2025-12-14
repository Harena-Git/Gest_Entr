package com.example.gestion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.TypeDocument;

@Repository
public interface TypeDocumentRepository extends JpaRepository<TypeDocument, Integer> {
}
