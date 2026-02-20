process POLISHING {
    tag "Medaka ${sample_id}"
    publishDir "${params.outdir}/${params.out_polishing}", mode: 'copy'
    cpus 16

    input:
    tuple val(sample_id), path(draft_assembly), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}_consensus.fasta"), emit: polished_assembly

    script:
    """
    medaka_consensus \
        -i ${reads} \
        -d ${draft_assembly} \
        -o medaka_out \
        -t ${task.cpus} \
        -m ${params.medaka_model}

    mv medaka_out/consensus.fasta ${sample_id}_consensus.fasta
    
    rm -rf medaka_out
    """
}