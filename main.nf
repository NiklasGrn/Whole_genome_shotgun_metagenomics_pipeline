nextflow.enable.dsl=2


// Input Parameters
params.reads = "data/*.fastq.gz"
params.output_qc = "results"
params.outdir = "results"
params.tool = "flye"

params.kraken_db = "/group/db/Kraken2_plusPF_072025"
params.bracken_db_files = "/group/db/Bracken_plusPF_072025"
params.db_dir = "db"
// Host Depletion Parameters
params.host_ref = null
params.skip_host_depletion = false


// Quality parameters
params.min_q = 10                 
params.min_len = 500

// Assembly Parameters
params.flye_mode = "--nano-hq" 
params.medaka_model = "r1041_e82_400bps_sup_v4.3.0"

include { QC_READS } from './subworkflows/qc_reads.nf'
include { ASSEMBLY_CLASSIFICATION } from './subworkflows/assembly.nf'
include { BINNING_ANALYSIS } from './subworkflows/binning_analysis.nf'


workflow {
    reads_ch = channel.fromPath(params.reads).map{file -> tuple(file.simpleName, file)}
    kraken_db_ch = channel.value(file(params.kraken_db))
    
    // QC
    reads_after_qc = QC_READS(reads_ch)

    //Assembly + Classification
    assembly = ASSEMBLY_CLASSIFICATION(reads_after_qc, kraken_db_ch)

    // Binning + Analysis
    BINNING_ANALYSIS(assembly.polished_assembly, reads_after_qc, kraken_db_ch)
}