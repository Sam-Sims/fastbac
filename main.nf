include {MASHSKETCH} from './modules/mash/mash'
include {MASHTRIANGLE} from './modules/mash/mash'
include {CONVERT_TRIANGLE} from './modules/mash/mash'

include {SKANISKETCH} from './modules/skani/skani'
include {SKANITRIANGLE} from './modules/skani/skani'
include {CONVERT_ANI} from './modules/skani/skani'

include {RAPIDNJ} from './modules/rapidnj/rapidnj'

workflow {
    fastas = Channel.fromPath(params.samplesheet) \
        | splitCsv(header:true) \
        | map { row -> tuple(row.sample_name, row.fasta) }

        if (params.workflow == 'mash') {
            sketches = MASHSKETCH(fastas)
            triangle = MASHTRIANGLE(sketches.collect())
            matrix = CONVERT_TRIANGLE(triangle)
        } else if (params.workflow == 'skani') {
            sketches = SKANISKETCH(fastas)
            skani = SKANITRIANGLE(sketches.collect())
            matrix = CONVERT_ANI(skani)
        }
        tree = RAPIDNJ(matrix)
}