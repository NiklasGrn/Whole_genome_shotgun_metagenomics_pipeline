process QUALITY_FILTER {
    tag "$sample_id Quality Filtered"
    publishDir "${params.output_qc}/${params.out_filtered}", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}_filtered.fastq.gz")

    script:
    """
    cat ${reads} | NanoFilt -q ${params.min_q} -l ${params.min_len} | gzip > ${sample_id}_filtered.fastq.gz
    """
}
