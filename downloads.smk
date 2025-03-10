import os
import platform
from os.path import join
from urllib.parse import quote_plus

O2_USER = "mk596"
# Check if this is running on O2
IS_O2 = (platform.system() == "Linux" and O2_USER != None)

# Directory / file constants
DATA_DIR = ("data" if not IS_O2 else join(os.sep, "n", "scratch3", "users", O2_USER[0], O2_USER, "lr", "data"))
RAW_DIR = join(DATA_DIR, "raw")
PROCESSED_DIR = join(DATA_DIR, "processed")


# Tabula Muris URLs: https://figshare.com/articles/dataset/Robject_files_for_tissues_processed_by_Seurat/5821263
TM_FACS_SEURAT = {
 'Bladder': 'https://ndownloader.figshare.com/files/13091141',
 'Brain_Non-Myeloid': 'https://ndownloader.figshare.com/files/13091513',
 'Fat': 'https://ndownloader.figshare.com/files/13091744',
 'Skin': 'https://ndownloader.figshare.com/files/13092389',
 'Trachea': 'https://ndownloader.figshare.com/files/13092410',
 'Lung': 'https://ndownloader.figshare.com/files/13092194',
 'Kidney': 'https://ndownloader.figshare.com/files/13091963',
 'Brain_Myeloid': 'https://ndownloader.figshare.com/files/13091333',
 'Pancreas': 'https://ndownloader.figshare.com/files/13092386',
 'Tongue': 'https://ndownloader.figshare.com/files/13092401',
 'Limb_Muscle': 'https://ndownloader.figshare.com/files/13092152',
 'Thymus': 'https://ndownloader.figshare.com/files/13092398',
 'Mammary_Gland': 'https://ndownloader.figshare.com/files/13092197',
 'Diaphragm': 'https://ndownloader.figshare.com/files/13091525',
 'Marrow': 'https://ndownloader.figshare.com/files/13092380',
 'Spleen': 'https://ndownloader.figshare.com/files/13092395',
 'Large_Intestine': 'https://ndownloader.figshare.com/files/13092143',
 'Liver': 'https://ndownloader.figshare.com/files/13092155',
 'Heart': 'https://ndownloader.figshare.com/files/13091957',
 'Aorta': 'https://ndownloader.figshare.com/files/13091138'
}
TM_FACS_TISSUES = list(TM_FACS_SEURAT.keys())

TM_TO_METMAP = {
  'Brain_Non-Myeloid': 'brain',
  'Lung': 'lung',
  'Liver': 'liver',
  'Marrow': 'bone',
  'Kidney': 'kidney'
}
METMAP_TISSUES = list(TM_TO_METMAP.keys())

# CellPhoneDB URLs: https://www.cellphonedb.org/downloads
CELLPHONEDB_GENE_INPUT_URL = "https://raw.githubusercontent.com/Teichlab/cellphonedb-data/master/data/gene_input.csv"
CELLPHONEDB_PROTEIN_INPUT_URL = "https://raw.githubusercontent.com/Teichlab/cellphonedb-data/master/data/protein_input.csv"
CELLPHONEDB_COMPLEX_INPUT_URL = "https://raw.githubusercontent.com/Teichlab/cellphonedb-data/master/data/complex_input.csv"
CELLPHONEDB_INTERACTION_INPUT_URL = "https://raw.githubusercontent.com/Teichlab/cellphonedb-data/master/data/interaction_input.csv"

# MetMap URLs: https://depmap.org/metmap/data/index.html
METMAP_500_URL = "https://ndownloader.figshare.com/files/24009293"
METMAP_EXP_COUNTS_URL = "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE148283&format=file&file=GSE148283%5Fall%2Ecount%2Ecsv%2Egz"
METMAP_EXP_SAMPLES_URL = "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE148283&format=file&file=GSE148283%5Fall%2Esample%2Ecsv%2Egz"

# CCLE URLS: https://portals.broadinstitute.org/ccle/data
CCLE_EXP_URL = "https://data.broadinstitute.org/ccle/CCLE_RNAseq_genes_counts_20180929.gct.gz"

# Cell and Gene Ontology URLs: http://www.obofoundry.org/ontology/cl.html
CL_OBO_URL = "http://purl.obolibrary.org/obo/cl.obo"
GO_OBO_URL = "http://purl.obolibrary.org/obo/go.obo"

# Lists of genes per KEGG pathway: https://maayanlab.cloud/Enrichr/#stats
KEGG_HUMAN_URL = "https://maayanlab.cloud/Enrichr/geneSetLibrary?mode=text&libraryName=KEGG_2019_Human"
KEGG_MOUSE_URL = "https://maayanlab.cloud/Enrichr/geneSetLibrary?mode=text&libraryName=KEGG_2019_Mouse"


rule convert_gct_to_h5ad:
  input:
    join(RAW_DIR, "ccle", "CCLE_RNAseq_genes_counts_20180929.gct")
  output:
    join(RAW_DIR, "ccle", "CCLE_RNAseq_genes_counts_20180929.h5ad")
  script:
    join("src", "convert_gct_to_h5ad.py")

    
rule download_orthologs:
  output:
    join(RAW_DIR, "ensembl", "human_mouse_orthologs.tsv")
  script:
    join("src", "download_orthologs.py")


# Abstract parent rules
rule curl_download:
  shell:
    '''
    curl -L -o {output} "{params.file_url}"
    '''

rule unzip:
  shell:
    '''
    unzip -o {input} -d {params.out_dir}
    '''

rule gunzip:
  shell:
    '''
    gunzip -c {input} > {output}
    '''
    
# Download Tabula Muris data
use rule curl_download as download_tm_facs_robj with:
  output:
    join(RAW_DIR, "tm", "seurat", "{tissue}.facs.Robj")
  params:
    file_url=(lambda w: TM_FACS_SEURAT[w.tissue])

# Download CellPhoneDB data
use rule curl_download as download_cellphonedb_gene_input with:
  output:
    join(RAW_DIR, "cellphonedb", "gene_input.csv")
  params:
    file_url=CELLPHONEDB_GENE_INPUT_URL

use rule curl_download as download_cellphonedb_protein_input with:
  output:
    join(RAW_DIR, "cellphonedb", "protein_input.csv")
  params:
    file_url=CELLPHONEDB_PROTEIN_INPUT_URL
  
use rule curl_download as download_cellphonedb_complex_input with:
  output:
    join(RAW_DIR, "cellphonedb", "complex_input.csv")
  params:
    file_url=CELLPHONEDB_COMPLEX_INPUT_URL

use rule curl_download as download_cellphonedb_interaction_input with:
  output:
    join(RAW_DIR, "cellphonedb", "interaction_input.csv")
  params:
    file_url=CELLPHONEDB_INTERACTION_INPUT_URL
    
# Download MetMap data
use rule curl_download as download_metmap_500 with:
  output:
    join(RAW_DIR, "metmap", "metmap_500_met_potential.xlsx")
  params:
    file_url=METMAP_500_URL

use rule gunzip as gunzip_metmap_counts with:
  input:
    join(RAW_DIR, "metmap", "GSE148283_all.count.csv.gz")
  output:
    join(RAW_DIR, "metmap", "GSE148283_all.count.csv")

use rule gunzip as gunzip_metmap_samples with:
  input:
    join(RAW_DIR, "metmap", "GSE148283_all.sample.csv.gz")
  output:
    join(RAW_DIR, "metmap", "GSE148283_all.sample.csv")

use rule curl_download as download_metmap_counts with:
  output:
    join(RAW_DIR, "metmap", "GSE148283_all.count.csv.gz")
  params:
    file_url=METMAP_EXP_COUNTS_URL

use rule curl_download as download_metmap_samples with:
  output:
    join(RAW_DIR, "metmap", "GSE148283_all.sample.csv.gz")
  params:
    file_url=METMAP_EXP_SAMPLES_URL
    
# Download CCLE data
use rule gunzip as gunzip_ccle_exp with:
  input:
    join(RAW_DIR, "ccle", "CCLE_RNAseq_genes_counts_20180929.gct.gz")
  output:
    join(RAW_DIR, "ccle", "CCLE_RNAseq_genes_counts_20180929.gct")
    
use rule curl_download as download_ccle_exp with:
  output:
    join(RAW_DIR, "ccle", "CCLE_RNAseq_genes_counts_20180929.gct.gz")
  params:
    file_url=CCLE_EXP_URL

# Download ontology files
use rule curl_download as download_cl_obo with:
  output:
    join(RAW_DIR, "ontologies", "cl.obo")
  params:
    file_url=CL_OBO_URL
  
use rule curl_download as download_go_obo with:
  output:
    join(RAW_DIR, "ontologies", "go.obo")
  params:
    file_url=GO_OBO_URL
    
# Download KEGG pathway lists of genes
use rule curl_download as download_kegg_human_genes with:
  output:
    join(RAW_DIR, "kegg", "KEGG_2019_Human.tsv")
  params:
    file_url=KEGG_HUMAN_URL

use rule curl_download as download_kegg_mouse_genes with:
  output:
    join(RAW_DIR, "kegg", "KEGG_2019_Mouse.tsv")
  params:
    file_url=KEGG_MOUSE_URL