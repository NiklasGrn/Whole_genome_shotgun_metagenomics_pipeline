nextflow.enable.dsl=2

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