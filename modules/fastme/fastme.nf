process FASTME {
    conda 'bioconda::fastme=2.1.6.1'
    container 'quay.io/biocontainers/fastme:2.1.6.1--h031d066_3'

    label 'med'
    tag 'fastme'

    input:
    path(distance_matrix)

    output:
    path('tree.nwk'), emit: tree

    publishDir "${params.output_dir}", mode: 'copy'

    script:
    """
    fastme -i ${distance_matrix} -o tree.nwk -T ${task.cpus}
    """
}