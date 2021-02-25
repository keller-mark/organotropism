# metastasis-prediction-by-ligand-receptor

Goal: determine whether ligand-receptor interactions are predictive for metastasis destination organ or tissue type.

Ground truth:
- for each cancer type, observed frequencies of each organ or tissue type as the metastasis destination

Input data:
- scRNA-seq data for each primary cancer type
- scRNA-seq data for each healthy organ or tissue type
- ligand-receptor pairs

Pre-processing:
- identify the immune/stromal cell types environment in each healthy organ
- identify the ligand and receptor signals in the healthy immune cells
- identify the ligand and receptor signals in the cancer samples


Model inputs: for each ligand and receptor pair, abundance of RNA in cancer cells vs each healthy organ

Model output: score for metastasis be localized to each healthy organ (highest score implies most likely for metastasis destination)

Questions:
- Could a graph embedding be used?
  - Perhaps for each cancer type, build an input graph of ligand-receptor pairs (edges between pairs across organs, with weights for interaction strength), embed to map to a graph of cancer type to organ type with weights


## Metastatic potential

Jin et al., Nature 2020 (pg 337):

$M_{i,j}$ = metastatic potential of cell line $j$ targeting organ $i$
= $M_{i,j} = \frac{1}{n} \sum_{k=1}^{n} c_i p_j$

where $c_i$ = total cancer cell number isolated from organ $i$
and $p_j$ = fractional proportion of cell line $j$ estimated by barcode quantification
and $n$ = number of replicates of mice.

## Metastasis concepts

Gupta and Massague Cell 2006

- millions of cells released by a tumor into circulation every day, but only small minority will colonize a distant organ
  - implies healthy cells display hostility toward invading tumor cells
- steps in metastasis
  - loss of cellular adhesion
  - increased motility and invasiveness
  - entry and survival in the circulation
  - exit into new tissue
  - colonization of distant site
  
- highly metastatic clones from tumor have a higher rate of genetic mutability than nonmetastatic clones from the same tumor

- mechanisms that suppress tumor formation
  - tumor cell intrinsic mechanisms
    - genotoxic stress induced by oncogenes
    - expression of growth inhibitory pathways
    - expression of apoptotic and senescence pathways
    - telomere attrition
  - tumor cell extrinsic mechanisms
    - tumor microenvironment
      - extracellular matrix components
      - basement membranes
      - reactive oxygen species
      - limited availability of nutrients and oxygen
        - low oxygen (hypoxia)
          - hypoxia inducible factor 1 (HIF-1) transcriptional complex -> greater likelihood of metastasis
            - HIF-1 induces expression of chemokine receptor CXCR4 in renal carcinoma cells, promoting metastasis
            - HIF-1 induces expression of lysyl oxidase (LOX), promoting metastasis in estrogen receptor-negative breast cancers
          - hypoxia can induce expression of Met (receptor), allowing HGF (ligand for Met) to mediate tumor cell invasion
          - epithelial cell hypoxia signature is a predictor of metastatic risk for breast and ovarian carcinomas
      - attack by the immune system
      - physical forces
        - tensional forces
          - tensional forces on mammary epithelial cells may result in downstream activation of ERK and Rho-GTPase by mechanotransducing integrins
        - interstital pressure

- stem-like tumor cells ("cancer stem cells")
  - long-term tumorigenic potential may require a small set of malignant cells with stem-like capacity to indefinitely self-renew
  - if self-renewing tumor cells are the only cells capable of generating secondary growths, then prevalence of tumor-initiating cells in a tumor would reflect overall proclivity for metastatic resurgence
    - limited evidence
    - has yet to be shown
  - capacity for tumor initiation is required for reestablishment of the tumor by a few surviving cells in a distant metastatic location
    - molecular mechanisms for tumor initiation
      - polycomb family protein Bmi-1 (transcriptional repressor)
      - Wnt/beta-catenin signaling pathway
      - Hedgehog signaling pathway
        - Gli1 (transcriptional effector of signaling) -> overexpression in rat -> aggressively metastatic to the lungs
      - Notch signaling pathway

- cancer cells usually show diminished intercellular adhesiveness
  - epithelial tumors
    - loss of E-cadherin-mediated adhesions
      - E-cadherin repression is part of epithelial-to-mesenchymal transition (EMT)
        - EMT can occur upon activation of transcription factors (the same factors are involved in EMT during embryogenesis)
          - Snail
          - Twist
          - Slug

- integrins are mediators of the malignant phenotype
  - $\alpha_6 \beta_4$ integrin
    - binds to laminin (an extracellular matrix protein)
    - forms signalling complexes with oncogenic receptor tyrosine kinases
      - Met
      - EGFR
      - Her2
  - $\alpha_V \beta_3$ and $\alpha 3 \beta_1$ integrins
    - implicated in the later stages of metastasis, during adhesion of circulating tumor cells to the vasculature

- metastasis requires cell motility
  - dynamic cytoskeletal changes
  - cell-matrix interactions
    - cancer cells that are highly motile -> attracted to blood vessels (observed in mammary carcinoma in mice)
      - chemoattractive gradients
      - extracellular matrix tracks emanating from (or terminating at) blood vessels
  - localized proteolysis
  - actin-myosin contractions
  - focal contact disassembly

- motility regulators
  - small GTPases
    - Rho
    - cdc42
    - Rac
  - integrin-containing focal adhesion assembly and disassembly
  - secreted and plasma membrane-tethered proteases
  - actomyosin contractile machinery

- growth factor signaling can modulate motility regulators
  - HGF and Met receptor ([CellPhoneDB](https://www.cellphonedb.org/fast-query/ligands-from-receptor?species=HOMO_SAPIENS&receptor=HGF))
  - RhoC -> lung metastasis in mice
  - Nedd9 (focal adhesion kinase) adaptor protein
    - -> melanoma metastasis in mice
    - -> metastasis of breast cancer to the lungs
  - podoplanin (mucin-like transmembrane glycoprotein)
    - cellular invasiveness independently of E-cadherin loss
    - may regulate the cytoskeletal anchoring protein Ezrin
  
- resistance to extracellular death signals
  - anti-apoptotic effectors
    - BCL2
    - $BCL-X_L$
    - XIAP
  - repression of apoptotic initiator caspase 8
    - activated downstream of unligated integrins
    - makes tumor cells more resistant to stress from loss of adhesion
  
- basement membrane: dense meschwork of glycoproteins and proteoglycans, forms epithelial and endothelial cell layers
  - provides a physical boundry
  - provides a signaling substrate
    - orients cells through integrin-based adhesions
    
- histopathological markers of stromal cell cooption in tumors
  - fibrosis
  - leukocytic infiltration
  - angiogenesis
  - lymphangiogenesis

- recruitment of tumor-promoting mesenchyme promotes metastasis
  - gene expression signature of fibroblast activation in vitro -> predicts likelihood for metastasis in primary breast tumors
    - chemokine CXCL12 produced by breast cancer-associated fibroblasts
      - augments the proliferation and migratory activity of tumor cells
    - chemokine CXCL12 (ligand) and recruitment of progenitor cells expressing CXCR4 (its receptor)
      - facilitates angiogenesis in developing tumors

- immunosuppression
  - immune attack suppressed by overexpression of immuosuppressive cytokines
    - TGF-beta
    - interleukin-10
    - interleukin-23
  - tumor cells may not provide the co-stimulatory signals necessary for immune response
    - no signals which neutrilize the autoinhibitory activity of cytotoxic-T lymphocyte angigen-4 (CTLA-4)
  - metastasis promoting effects -> no activation of the nuclear factor kappa B ($NF-\kappa B$) pathway
  - inflammatory cells synthesizing prostaglandins -> metastatic progression
    - inducible cyclooxygenase 2 (COX-2)
  - tumors infiltrated by activated macrophages typically follow an aggressive course of disease
    - secretion of vasoactive factors induces angiogenesis
      - VEGF
      - IL-8
      - PGE_2
    - secretion of proteases enhances bioactivity
      - MMP-9
      - uPA
    - release of growth factors faciliates tumor cell proliferation, survival, invasion
      - EGF
      - PDGF
      - HGF
    - mutation of CSF-1 -> defects in macrophage lineage -> no lung metastasis from mammary tumors in mice
  
  - metastasis requires that tumor cells access distant sites through tumor-associated vasculature
    - tumors establish neo-vasculature (the "angiogenic switch") to grow beyond existing blood vessels
    - lymphatic vessels are more leaky than blood vessels (lack of tight intercellular junctions between lymphatic endothelial cells)
      - lymph node metastasis -> early indicator of metastatic dissemination in several cancer types (including melanoma)
        - exception: sarcomas (metastasis without lymph node evidence)
    - access to all organs besides lymph nodes is primarily through blood circulation
  
- survival of circulating tumor cells
  - co-opting of blood platelets (used as "shields")
    - thrombosis and abundant fibrin deposition (observed in early-stage hematogenous metastasis in humans)
    - tumor emboli -> greater metastatic potential than "naked" tumor cells
      - resistant to clearance
      - resistant to physical hemodynamic forces
  - anoikis: the loss of adhesive supports
    - may allow evasion of cell death
    - brain-derived neurotrophic factor (BDNF) receptor trkB
      - -> resistance to anoikis in vitro
      - -> metastsis in rat intestinal epithelial cell line

- **adhesive interactions between cell-surface receptors in malignant cells and ligands expressed in target sites for metastasis**
  - integrin receptors
    - $\alpha 3 \beta 1$ integrins expressed on circulating tumor cells
      - bind to laminin-5 in vascular basement membrane during lung metastasis ([CellPhoneDB](https://www.cellphonedb.org/fast-query/ligands-from-receptor?species=HOMO_SAPIENS&receptor=LAMA3))
  - metadherin adhesion receptor
    - expressed by metastatic breast cancer cells
    - binds to unknown ligand expressed on lung-capillary endothelial cells
  - chemokines and their receptors
    - CXCR4 expression in breast cancer cells -> metastasis to CXCL12-rich tissues (lungs) ([CellPhoneDB](https://www.cellphonedb.org/fast-query/ligands-from-receptor?species=HOMO_SAPIENS&receptor=CXCR4))
    

- extravasation: exiting the endothelial vasculature into the target tissue
  - growth may occur within the vasculature and "burst out" into the surrounding tissue
  - ezrin (cytoskeletal anchoring protein) -> escape from vasculature in osteosarcoma cells
    - ezrin repression -> higher rates of cancer cell death prior to lung metastasis
  - cell signals which induce vascular permeability
    - VEGF (vasculature permeability factor)
      - VEGF -> Src kinases disrupt endothelial cell junctions
      

- patterns of colonization: organ distribution of metastasis from primary tumors
  - seed-and-soil hypothesis (Paget 1889)
    - circulating cancer cells (seeds) only colonize organ microenvironments (soils) compatible with their growth
  - circulatory patterns alone provide a **partial** explanation for preferred sites of metastasis
  - known patterns
    - breast cancer -> lungs, bones, liver, brain
      - no direct circulatory connection to breast tissue
    - prostate cancer -> bone
      - rarely lungs or liver
    - uveal melanoma -> liver
    - sarcomas -> lungs

  - hematopoietic progenitor  hypothesis (Kaplan et al., 2005)
    - circulation mobilizes hematopoietic progenitors from bone marrow
    - hormonal factors emitted by primary tumors -> metastasis by hematopoietic progenitors
    - molecular characterization of the recruited hematopoietic cells: expression of
      - VEGFR1 ([CellPhoneDB](https://www.cellphonedb.org/fast-query/ligands-from-receptor?species=HOMO_SAPIENS&receptor=FLT1))
        - VEGFR1 ligands may be required for premetastatic conditioning of target organ sites
      - CD133
      - CD34
      - c-kit


## Resources

- Tabula muris: 20 organs and tissues from mouse
  - [Human Cell Atlas data portal](https://data.humancellatlas.org/explore/projects/e0009214-c0a0-4a7b-96e2-d6a83e966ce0/expression-matrices?catalog=dcp2)
  - Zhang et al. Cell 2013: "The evidence supports a model in which a TN tumor stroma rich in mesenchymal cytokines CXCL12 and IGF1 skews the carcinoma population toward a preponderance of clones with a high level of activated Src and a predisposition to grow in the bone marrow, a soil that is rich in CXCL12 and IGF1 compared to lung, brain, and other metastasis target tissues"
    - task: explore tabula muris to determine whether mouse bone marrow data seems to have this property as well

- 