process BRACKEN_BUILD {
    tag "Bracken build"
    storeDir "${params.db_dir}/bracken_db", mode: 'copy'

    input:
    path kraken_db
    val length

    output:
    path "database${length}_bracken_db", emit: bracken_db_files

    script:
    """   
    bracken-build -d ${kraken_db} -l ${length} -t ${task.cpus} -o database${length}_bracken_db
    """
}

process BRACKEN_CLASSIFY {
    tag "Bracken classify ${sample_id}"
    publishDir "${params.outdir}/${params.out_class_bracken}", mode: 'copy'
    cpus 8

    input:
    tuple val(sample_id), path(kraken_report)
    path bracken_db_files
    val length

    output:
    tuple val(sample_id), path("${sample_id}_bracken_report.txt"), emit: bracken_report

    script:
    """   
    bracken -d ${bracken_db_files} \
            -i ${kraken_report} \
            -o ${sample_id}_bracken_report.txt \
            -r ${length} -l S \
            --threads ${task.cpus}
    """
}