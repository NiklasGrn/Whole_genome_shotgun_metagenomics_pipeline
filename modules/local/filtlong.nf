// alternative to nanofilt

process FILTLONG {
    tag "$sample_id"
    publishDir "${params.outdir}/${params.out_filtered}", mode: 'copy'

    input:
    tuple val(sample_id), path(fastq)

    output:
    tuple val(sample_id), path("${sample_id}_fitlong.fastq.gz")

    script:
    """
    filtlong --min_length 500 --keep_percent 90 ${fastq} > ${sample_id}_fitlong.fastq | gzip > ${sample_id}_fitlong.fastq.gz
    """
}