process BINNING_SEMIBIN {
    tag "SemiBin2 ${sample_id}"
    publishDir "${params.outdir}/${params.out_binning}/${sample_id}", mode: 'copy'
    cpus 16 

    input:
    tuple val(sample_id), path(assembly), path(bam), path(bai)

    output:
    tuple val(sample_id), path("output_bins/*.fa"), emit: bins_list, optional: true

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


    count=`ls -1 *.fa 2>/dev/null | wc -l`
    if [ \$count != 0 ]; then
        for f in *.fa; do
            mv "\$f" "${sample_id}_\$f"
        done
    fi
    """
}