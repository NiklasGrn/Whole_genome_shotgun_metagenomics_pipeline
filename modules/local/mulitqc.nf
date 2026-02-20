process MULTIQC {
    tag "MultiQC Report"
    publishDir "${params.output_qc}/${stage}", mode: 'copy'

    input:
    path dirs
    val stage

    output:
    path "multiqc_report"

    script:
    """
    multiqc ${dirs} -o multiqc_report
    """
}