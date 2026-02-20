process KRAKEN2 {
    tag "Kraken ${input_file.simpleName}"
    publishDir "${params.outdir}/${stage}", mode: 'copy'
    cpus 8
    maxForks 4

    input:
    tuple val(sample_id), path(input_file)
    path db_dir
    val stage

    output:
    tuple val(sample_id), path("${sample_id}_${input_file.simpleName}_report.txt"), emit: report

    script:
    """   
    kraken2 --db ${db_dir} \
            --threads ${task.cpus} \
            --report ${sample_id}_${input_file.simpleName}_report.txt \
            --output /dev/null \
            --use-names \
            ${input_file}
    """
}