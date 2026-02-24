process METAQUAST {
    tag "MetaQUAST ${sample_id}"
    publishDir "${params.outdir}/${stage}/MetaQUAST", mode: 'copy'
    cpus 8 
    memory '32 GB'

    input:
    tuple val(sample_id), path(contigs)
    val stage

    output:
    tuple val(sample_id), path("${sample_id}_metaquast_report"), emit: metaquast_report

    script:
    """
    metaquast.py ${contigs} \
        -o ${sample_id}_metaquast_report \
        --threads ${task.cpus}
    """
}