// in progress not implemented / tested yet

process HOST_FILTER {
    tag "$sample_id Host Filtered"
    publishDir "${params.output_qc}/${params.out_host_removal}", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}_host_filtered.fastq.gz")

    script:
    """
        minimap2 -ax map-ont ${params.host_ref} ${reads} \
        | samtools fastq -f 4 -n -c 6 - \
        | gzip > ${sample_id}_host_filtered.fastq.gz
    """
}