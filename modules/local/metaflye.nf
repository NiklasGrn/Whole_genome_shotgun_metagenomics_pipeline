process ASSEMBLY {
    tag "Flye ${sample_id}"
    publishDir "${params.outdir}/${params.out_assambly}/Flye", mode: 'copy'
    cpus 16 
    memory '64 GB'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}_assembly.fasta"), emit: contigs
    path "${sample_id}_flye.log"
    path "${sample_id}_assembly_info.txt"

    script:
    """
    flye ${params.flye_mode} ${reads} \
        --out-dir . \
        --meta \
        --threads ${task.cpus}

    mv assembly.fasta ${sample_id}_assembly.fasta
    mv flye.log ${sample_id}_flye.log
    mv assembly_info.txt ${sample_id}_assembly_info.txt
    """
}