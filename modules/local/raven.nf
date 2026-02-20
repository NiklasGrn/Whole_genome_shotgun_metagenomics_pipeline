process ASSEMBLY {
    tag "Raven ${sample_id}"
    publishDir "${params.outdir}/${params.out_assambly}/Raven", mode: 'copy'
    cpus 16 
    memory '64 GB'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}_raven_assembly.fasta"), emit: raven_contigs
    path "${sample_id}_raven.log"

    script:
    """
    raven --threads ${task.cpus} ${reads} > ${sample_id}_raven_assembly.fasta 2> ${sample_id}_raven.log
    """
}