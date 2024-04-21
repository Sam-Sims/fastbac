process MASHSKETCH {
    conda 'bioconda::mash=2.3'
    container 'quay.io/biocontainers/mash:2.3--hd3113c8_6'

    label 'process_low'
    tag 'mashsketch'

    input:
    tuple val(sample_name), path(fasta)

    output:
    path('*.msh'), emit: sketch


    script:
    """
    mash sketch -o ${sample_name}.msh -p $task.cpus ${fasta}
    """
}

process MASHTRIANGLE {
    conda 'bioconda::mash=2.3'
    container 'quay.io/biocontainers/mash:2.3--hd3113c8_6'

    label 'process_medium'
    tag 'mashtriangle'

    input:
    path(sketch_files)

    output:
    path('mash_triangle.txt'), emit: triangle

    publishDir "${params.output_dir}", mode: 'copy'

    script:
    """
    mash triangle -p ${task.cpus} ${sketch_files} -m ${params.min_copy} > mash_triangle.txt
    """
}

process CONVERT_TRIANGLE {
    conda './envs/convert_triangle.yml'

    label 'process_single'
    tag 'converttriangle'

    input:
    path(triangle_file)

    output:
    path('distance_matrix.tsv'), emit: distance_matrix

    publishDir "${params.output_dir}", mode: 'copy'

    script:
    """
    python ${projectDir}/scripts/triangle_to_square.py ${triangle_file} > distance_matrix.tsv
    """
}