include { PORECHOP } from '../modules/local/porechop.nf'
include { QUALITY_FILTER } from '../modules/local/nanofilt.nf'
include { HOST_FILTER } from '../modules/local/host_filt.nf'
include { NANOPLOT as NANOPLOT_RAW } from '../modules/local/nanoplot.nf'
include { NANOPLOT as NANOPLOT_FILTERED } from '../modules/local/nanoplot.nf'
include { MULTIQC } from '../modules/local/mulitqc.nf'


workflow QC_READS {
    take:
        reads

    main:
        NANOPLOT_RAW(reads, params.out_raw_qc, "raw")
        PORECHOP(reads)
        QUALITY_FILTER(PORECHOP.out)

        if (!params.skip_host_depletion && params.host_ref) {
            HOST_FILTER(QUALITY_FILTER.out)
            reads_after_qc = HOST_FILTER.out
        } else {
            reads_after_qc = QUALITY_FILTER.out
        }

        NANOPLOT_FILTERED(reads_after_qc, params.out_filtered_qc, "filtered")

        // Collect all QC output paths for MultiQC
        raw_qc_results = NANOPLOT_RAW.out.map { _sample_id, path -> path }
        filtered_qc_results = NANOPLOT_FILTERED.out.map { _sample_id, path -> path }

        all_paths = raw_qc_results.mix(filtered_qc_results).collect()
        MULTIQC(all_paths, params.out_multiqc_qc) 

    emit:
        qc_reads = reads_after_qc
}