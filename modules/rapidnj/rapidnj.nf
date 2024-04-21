process RAPIDNJ {
    conda 'bioconda::rapidnj=2.3.2'
    container 'quay.io/biocontainers/rapidnj:2.3.2--h4ac6f70_4'

    label 'process_medium'
    tag 'rapidnj'

    input:
    path(distance_matrix)

    output:
    path('tree.nwk'), emit: tree

    publishDir "${params.output_dir}", mode: 'copy'

    script:
    """
    rapidnj -i pd -c ${task.cpus} ${distance_matrix} > tree.nwk
    """
}