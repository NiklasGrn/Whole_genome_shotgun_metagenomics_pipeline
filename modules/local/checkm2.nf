process CHECKM2 {
    tag "checkm2 ${sample_id}"
    publishDir "${params.outdir}/${params.out_class_bins_qc}", mode: 'copy'

    conda '/home/ngrundner/miniforge3/envs/checkm2'

    input:
    tuple val(sample_id), path(bins)

    output:
    path "${sample_id}_${bins.simpleName}"

    script:
    """
    checkm2 predict -i ${bins} -o ${sample_id}_${bins.simpleName} 
    """
}