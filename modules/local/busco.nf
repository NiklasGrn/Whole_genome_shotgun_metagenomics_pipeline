// nicht implementiert, derzeit CHECKM2 als Alternative

process BUSCO_QC {
    tag "BUSCO ${bin_file.simpleName}"
    publishDir "${params.outdir}/${params.out_busco_qc}", mode: 'copy'
    cpus 8 

    input:
    tuple val(sample_id), path(bin_file)

    output:
    path "${bin_file.simpleName}_busco/short_summary.*.txt", emit: summary
    path "${bin_file.simpleName}_busco", emit: full_output

    script:
    """    
    busco -i ${bin_file} \
          -o ${bin_file.simpleName}_busco \
          -m genome \
          -l bacteria_odb10 \
          --cpu ${task.cpus} \
          --force 
    """
}