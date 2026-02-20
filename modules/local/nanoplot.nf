process NANOPLOT {
    tag "$sample_id $prefix QC"
    publishDir "${params.output_qc}/${stage}", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)
    val stage
    val prefix

    output:
    tuple val(sample_id), path("${prefix}_${sample_id}_*")

    script:
    """
    NanoPlot --fastq ${reads} --outdir . \
    --prefix "${prefix}_${sample_id}_"
    """
}