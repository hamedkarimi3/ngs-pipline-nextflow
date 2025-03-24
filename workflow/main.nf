nextflow.enable.dsl=2

process FastQC {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(reads)

    output:
    path("${sample_id}_fastqc.zip")
    path("${sample_id}_fastqc.html")

    script:
    """
    fastqc ${reads} --outdir .
    """
}

workflow {
    Channel
        .fromPath('data/*.fastq.gz')
        .map { file ->
            def id = file.baseName.replaceAll(/\.fastq\.gz$/, '')
            tuple(id, file)
        }
        |>
        FastQC
}
