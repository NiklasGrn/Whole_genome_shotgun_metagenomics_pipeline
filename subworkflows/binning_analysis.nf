include { MAPPING_TO_ASSEMBLY } from '../modules/local/minimap_to_assembly.nf'
include { BINNING_SEMIBIN } from '../modules/local/semibin2.nf'

include { BUSCO_QC } from '../modules/local/busco.nf'
include { CHECKM2 } from '../modules/local/checkm2.nf'

include { KRAKEN2 as CLASSIFY_BINS } from '../modules/local/kraken2.nf'
include { MULTIQC } from '../modules/local/mulitqc.nf'
include { KRONA as KRONA_BINS } from '../modules/local/krona.nf'

workflow BINNING_ANALYSIS {
    take:
        assembly
        reads_after_qc
        kraken_db_ch

    main:
        mapping_input_ch = assembly.join(reads_after_qc)

        MAPPING_TO_ASSEMBLY(mapping_input_ch)
        BINNING_SEMIBIN(MAPPING_TO_ASSEMBLY.out.bam_tuple)

        
        single_bins_ch = BINNING_SEMIBIN.out.bins_list.transpose()

        // --- 3. QC (BUSCO) ---
        // BUSCO_QC( single_bins_ch )

        CHECKM2(single_bins_ch)


        CLASSIFY_BINS(single_bins_ch, kraken_db_ch, params.out_class_bins)

        qc_reports = CLASSIFY_BINS.out.report.map{_sample_id, path -> path}.collect()
        MULTIQC(qc_reports, params.out_multiqc_binning)


        // Not Working as intended - Kraken2 reports werden nicht korrekt gruppiert
        report_grouped = CLASSIFY_BINS.out.report
            .map {sample_id, path -> tuple(sample_id, path) }
            .groupTuple()
        KRONA_BINS(report_grouped, params.out_binning, "bins")
}