process BINNING_SEMIBIN {
    tag "SemiBin2 ${sample_id}"
    publishDir "${params.outdir}/${params.out_binning}", mode: 'copy'
    cpus 16 

    input:
    tuple val(sample_id), path(assembly), path(bam), path(bai)

    output:
    tuple val(sample_id), path("*.fa"), emit: bins_list, optional: true

    script:
    """
    SemiBin2 single_easy_bin \
        --input-fasta ${assembly} \
        --input-bam ${bam} \
        --output . \
        --threads ${task.cpus} \
        --environment global \
        --min-len 2500 \
        --compression none


    count=`ls -1 output_bins/*.fa 2>/dev/null | wc -l`
    if [ \$count != 0 ]; then
        for f in output_bins/*.fa; do
            filename=\$(basename "\$f" .fa)
            mv "\$f" "${sample_id}_\$filename.fa"
        done
    fi
    """
}