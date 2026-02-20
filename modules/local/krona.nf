process KRONA {
    tag "Krona: ${sample_id}"
    publishDir "${params.outdir}/${stage}/plots", mode: 'copy'

    input:
    tuple val(sample_id), path(tax_report)
    val stage
    val suffix

    output:
    path "${sample_id}_${suffix}_krona.html"

    script:
    """
    ktImportTaxonomy \
        ${tax_report} \
        -o ${sample_id}_${suffix}_krona.html \
        -m 3 -t 5
    """
}