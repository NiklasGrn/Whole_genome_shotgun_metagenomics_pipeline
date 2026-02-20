process MAPPING_TO_ASSEMBLY {
    tag "Mapping ${sample_id}"
    cpus 16

    input:
    tuple val(sample_id), path(assembly), path(reads)

    output:
    tuple val(sample_id), path(assembly), path("${sample_id}.bam"), path("${sample_id}.bam.bai"), emit: bam_tuple

    script:
    """
    minimap2 -d assembly.mmi ${assembly}

    minimap2 -ax map-ont -t ${task.cpus} assembly.mmi ${reads} \
    | samtools sort -@ ${task.cpus} -o ${sample_id}.bam
    
    samtools index ${sample_id}.bam
    """
}