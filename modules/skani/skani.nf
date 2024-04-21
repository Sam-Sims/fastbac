process SKANISKETCH {
    conda 'bioconda::skani=0.2.1'
    container 'quay.io/biocontainers/skani:0.2.1--h4ac6f70_0'

    label 'process_low'
    tag 'skani'

    input:
    tuple val(sample_name), path(fasta)

    output:
    path "${sample_name}/*.sketch", emit: sketch


    script:
    """
    skani sketch -t ${task.cpus} ${fasta} -o ${sample_name}
    """
}

process SKANITRIANGLE {
    conda 'bioconda::skani=0.2.1'
    container 'quay.io/biocontainers/skani:0.2.1--h4ac6f70_0'

    label 'process_high'
    tag 'skani'

    input:
    path(fasta_files)

    output:
    path('skani_triangle.txt'), emit: triangle

    publishDir "${params.output_dir}", mode: 'copy'

    script:
    """
    skani triangle -t ${task.cpus} ${fasta_files} > skani_triangle.txt
    """
}

process CONVERT_ANI {
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
    python ${projectDir}/scripts/triangle_to_square.py --ani ${triangle_file} > distance_matrix.tsv
    """
}