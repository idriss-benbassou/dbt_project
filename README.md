# Projet dbt + Snowflake : le projet fil rouge de la Formation dbt

Le code complet du projet construit pas à pas dans la [**Formation dbt gratuite**](https://www.idriss-benbassou.com/formation-dbt/), de ton premier modèle au déploiement en production, sur Snowflake.

Chaque brique de ce repo correspond à un module de la formation : sources et staging, matérialisations, tests, documentation, seeds, snapshots, macros, contracts, unit tests, CI/CD, couche intermédiaire et Semantic Layer.

> Formation complète (16 modules, gratuite) → https://www.idriss-benbassou.com/formation-dbt/
> Examens blancs certification dbt Analytics Engineering → https://datacertification.fr/certifications/dbt-analytics-engineer

---

## Prérequis

- Le **moteur dbt Fusion** en local (binaire autonome, aucun Python requis)
- Un compte Snowflake (l'essai gratuit 30 jours suffit)
- Être à l'aise en SQL

Pas encore à l'aise en SQL ? → [240+ exercices SQL interactifs](https://datacertification.fr/exercices-sql)

---

## Installer dbt Fusion

Fusion est un binaire compilé en Rust.

**macOS / Linux**

```bash
curl -fsSL https://public.cdn.getdbt.com/fs/install/install.sh | sh -s -- --update
exec $SHELL
```

**Windows (PowerShell)**

```powershell
irm https://public.cdn.getdbt.com/fs/install/install.ps1 | iex
```

Vérifie l'installation :

```bash
dbt --version
```

La commande est `dbt`. Si tu as déjà dbt Core installé sur la machine, utilise l'alias `dbtf` pour éviter le conflit de PATH (`dbtf build`, `dbtf deps`…). Pour l'expérience complète (autocomplete, lineage, erreurs en direct), installe aussi l'extension VS Code **dbt** publiée par dbt Labs.

---

## Se connecter à Snowflake

Le `profiles.yml` ne contient aucun secret. Il lit quatre variables d'environnement :

| Variable | Contenu |
|---|---|
| `SNOWFLAKE_ACCOUNT` | l'identifiant de ton compte |
| `SNOWFLAKE_USER` | ton utilisateur |
| `SNOWFLAKE_PRIVATE_KEY_PATH` | le chemin vers ta clé privée `rsa_key.p8` |
| `SNOWFLAKE_PRIVATE_KEY_PASSPHRASE` | la phrase de passe de la clé |

La création de la paire de clés est expliquée dans le [module 2](https://www.idriss-benbassou.com/installer-dbt-core-et-connecter-snowflake-ton-premier-projet-dbt/). Sur un compte d'essai, le mot de passe fonctionne encore : remplace les deux lignes `private_key` par `password: "{{ env_var('SNOWFLAKE_PASSWORD') }}"`.

---

## Les couches du projet

```
raw (sources)  →  staging  →  intermediate  →  marts  →  Semantic Layer
```

- **staging** : une vue par table source, renommée et nettoyée. Aucune règle métier.
- **intermediate** : la logique partagée par plusieurs marts. Ici `int_commandes_enrichies` décide une seule fois ce qu'est une commande payée.
- **marts** : les tables prêtes pour les outils de restitution.
- **Semantic Layer** : les indicateurs définis une seule fois au-dessus des marts.

---

## Les modules et le code correspondant

### Fondamentaux

| # | Module | Dans le repo |
|---|--------|--------------|
| 1 | [dbt : à quoi ça sert ?](https://www.idriss-benbassou.com/dbt-data-build-tool-a-quoi-ca-sert-exemples-sql/) | Pas de code |
| 2 | [Installer dbt et connecter Snowflake](https://www.idriss-benbassou.com/installer-dbt-core-et-connecter-snowflake-ton-premier-projet-dbt/) | `dbt_project.yml`, `profiles.yml` |
| 3 | [Sources et staging : source(), ref()](https://www.idriss-benbassou.com/dbt-sources-staging-source-ref-premiere-couche/) | `models/staging/` |
| 4 | [Les matérialisations](https://www.idriss-benbassou.com/dbt-materialisations-view-table-incremental-ephemeral/) | `dbt_project.yml` (la règle par dossier), `mart_orders.sql` (une exception) |
| 5 | [Les tests dbt](https://www.idriss-benbassou.com/dbt-tests-generic-test-unitaire-fiabiliser-donnee/) | `models/staging/_models.yml`, `tests/assert_montant_positif.sql` |
| 6 | [Documentation, lineage et exposures](https://www.idriss-benbassou.com/dbt-documentation-doc-lineage-exposures/) | `models/staging/_docs.md`, `models/_exposures.yml` |
| 7 | [Les seeds dbt](https://www.idriss-benbassou.com/dbt-seeds-csv-data-donnees-reference/) | `seeds/`, `int_commandes_enrichies.sql`, le test `relationships` sur `statut` |
| 8 | [Déployer : Git, dbt build, production](https://www.idriss-benbassou.com/dbt-deploiement-git-build-production/) | `profiles.yml` (targets `dev` / `prod`) |

### Avancé / Production

| # | Module | Dans le repo |
|---|--------|--------------|
| 9 | [Les modèles incremental](https://www.idriss-benbassou.com/dbt-incremental-is-incremental-unique-key-merge/) | `models/marts/mart_orders.sql` |
| 10 | [Snapshots : SCD Type 2](https://www.idriss-benbassou.com/dbt-snapshots-scd-type-2/) | `snapshots/customers_snapshot.yml` |
| 11 | [Jinja et macros](https://www.idriss-benbassou.com/dbt-jinja-macros/) | `macros/` |
| 12 | [Les packages dbt](https://www.idriss-benbassou.com/dbt-packages-dbt-utils/) | `packages.yml`, `mart_orders.sql`, `mart_clients_commandes_status.sql` |
| 13 | [Gouvernance : contracts, access, grants](https://www.idriss-benbassou.com/dbt-gouvernance-contracts-access-grants/) | `models/marts/_models.yml` |
| 14 | [Unit tests](https://www.idriss-benbassou.com/dbt-unit-tests-tester-logique/) | `models/marts/_unit_tests.yml` |
| 15 | [CI/CD et Slim CI](https://www.idriss-benbassou.com/dbt-cicd-slim-ci-github-actions/) | `.github/workflows/`, `profiles.yml` (target `ci`) |
| 16 | Orchestration et performance | à venir |
| Bonus | Couche intermédiaire : écrire une règle métier une seule fois | `models/intermediate/` |
| Bonus | Semantic Layer : définir un indicateur une seule fois | `models/marts/_models.yml` (`mart_orders_enrichi`), `models/utils/` |

---

## Commandes utiles

```bash
dbt build                      # run + test sur tout le projet
dbt build --select staging     # uniquement la couche staging
dbt build --select stg_orders+ # un modèle et tout ce qui en dépend
dbt test --select mart_clients_commandes
dbt test --select test_type:unit
dbt snapshot                   # historisation SCD2
dbt source freshness           # fraîcheur de raw.orders
dbt docs generate && dbt docs serve
```

---

## Semantic Layer

Les indicateurs sont définis une seule fois, sur `mart_orders_enrichi` : `nb_commandes`, `chiffre_affaires` et `panier_moyen`, calculés sur les commandes payées (`est_paye` du seed). Un tableau de bord, une requête ou un assistant IA qui les interroge obtient toujours le même chiffre.

- `models/marts/_models.yml` déclare le semantic model (entités, dimensions) et les trois métriques.
- `models/utils/metricflow_time_spine.sql` est le calendrier qui permet de regrouper les métriques par jour, mois ou année.

`dbt parse` vérifie les définitions. Pour interroger les métriques en local, installe MetricFlow (`pip install dbt-metricflow`), puis :

```bash
mf validate-configs
mf query --metrics panier_moyen --group-by metric_time__month
mf query --metrics chiffre_affaires --group-by metric_time__month --explain   # affiche le SQL généré
```

---

## CI/CD

- **`ci.yml`** se déclenche sur chaque pull request vers `main`. Il récupère le `manifest.json` du dernier déploiement en prod, puis ne reconstruit que les modèles modifiés et leurs descendants (`state:modified+ --defer`) dans le schéma `ci`. Tant qu'aucun manifest de prod n'existe, il reconstruit tout.
- **`cd.yml`** se déclenche sur chaque push vers `main` : `dbt build --target prod`, puis sauvegarde du `manifest.json` de production en artefact. C'est ce manifest qui sert de state au Slim CI.

En local, le projet tourne sur Fusion. La CI installe dbt Core avec `pip`, dans une version figée. Les deux moteurs lisent le même projet.

Les identifiants Snowflake passent par les GitHub Secrets : `SNOWFLAKE_ACCOUNT`, `SNOWFLAKE_USER`, `SNOWFLAKE_PRIVATE_KEY` (le contenu de `rsa_key.p8`) et `SNOWFLAKE_PRIVATE_KEY_PASSPHRASE`. Pour la CI, crée un utilisateur dédié de type `SERVICE` et associe-lui la clé publique :

```sql
CREATE USER dbt_ci_user TYPE = SERVICE DEFAULT_ROLE = dbt_role RSA_PUBLIC_KEY = 'MIIBIjANBgkq...';
GRANT ROLE dbt_role TO USER dbt_ci_user;
```

---

## Aller plus loin

- [Formation Snowflake](https://www.idriss-benbassou.com/formation-snowflake/)
- [MERGE SQL](https://www.idriss-benbassou.com/merge-sql-insert-update-delete-en-une-requete-snowflake-dbt-bigquery/)
- [SCD Type 1, 2, 3, 6](https://www.idriss-benbassou.com/scd-slowly-changing-dimensions-type-1-2-3-6-sql-dbt-snowflake/)
- [Architecture Médaillon](https://www.idriss-benbassou.com/architecture-medaillon-bronze-silver-gold-erreurs-a-eviter/)
- [Préparer la certification dbt Analytics Engineering](https://datacertification.fr/certifications/dbt-analytics-engineer)

---

[Site](https://www.idriss-benbassou.com) · [LinkedIn](https://www.linkedin.com/in/idriss-benbassou/) · [DataCertification.fr](https://datacertification.fr)
