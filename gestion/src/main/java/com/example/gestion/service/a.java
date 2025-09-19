@Service
public class CandidatService {

    @Autowired
    private CandidatRepository candidatRepository;

    @Autowired
    private HistoriqueEtatRepository historiqueEtatRepository;

    @Autowired
    private EtatCandidatRepository etatCandidatRepository;

    public boolean verifierEtEnregistrer(Candidat candidat, Profil profilAnnonce) {
        // Vérification genre
        if (profilAnnonce.getGenre() != null 
                && !profilAnnonce.getGenre().equalsIgnoreCase(candidat.getGenre())) {
            return false;
        }

        // Vérification âge
        LocalDate naissance = candidat.getDate_naissance().toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
        int ageCandidat = Period.between(naissance, LocalDate.now()).getYears();

        if (profilAnnonce.getAge() != null && ageCandidat < profilAnnonce.getAge()) {
            return false;
        }

        // Vérification années d’expérience
        if (profilAnnonce.getAnnee_experience() != null &&
                candidat.getAnnee_experience() < profilAnnonce.getAnnee_experience()) {
            return false;
        }

        // Vérification lieu
        if (profilAnnonce.getLieu() != null) {
            if (candidat.getLieu() == null ||
                    !profilAnnonce.getLieu().getId_lieu().equals(candidat.getLieu().getId_lieu())) {
                return false;
            }
        }

        // Vérification diplôme
        if (profilAnnonce.getDiplome() != null) {
            boolean match = false;

            for (DiplomeCandidat dc : candidat.getDiplomesCandidats()) {
                Diplome diplomeCandidat = dc.getDiplome();
                Diplome diplomeProfil = profilAnnonce.getDiplome();

                if (diplomeCandidat != null) {
                    boolean memeFiliere = diplomeProfil.getFiliere() != null
                            && diplomeCandidat.getFiliere() != null
                            && diplomeProfil.getFiliere().getIdFiliere()
                            .equals(diplomeCandidat.getFiliere().getIdFiliere());

                    boolean niveauOk = diplomeProfil.getNiveau() != null
                            && diplomeCandidat.getNiveau() != null
                            && diplomeCandidat.getNiveau().getIdNiveau()
                            >= diplomeProfil.getNiveau().getIdNiveau();

                    if (memeFiliere && niveauOk) {
                        match = true;
                        break;
                    }
                }
            }

            if (!match) {
                return false;
            }
        }

        // ✅ Si tout est conforme, on sauvegarde
        EtatCandidat etatInitial = etatCandidatRepository.findById(1)
                .orElseThrow(() -> new RuntimeException("Etat initial introuvable"));

        candidat.setEtatCandidat(etatInitial);
        Candidat saved = candidatRepository.save(candidat);

        HistoriqueEtat historique = new HistoriqueEtat();
        historique.setCandidat(saved);
        historique.setEtatCandidat(etatInitial);
        historique.setDate_changement(LocalDate.now().toString());
        historiqueEtatRepository.save(historique);

        return true;
    }
}
