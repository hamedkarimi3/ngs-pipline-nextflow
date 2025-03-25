nextflow.enable.dsl=2

process FastQC {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(reads)

    output:
    path("${sample_id}_fastqc.html")
    path("${sample_id}_fastqc.zip")

    script:
    """
    fastqc ${reads} --outdir .
    """
}

workflow {

    Channel
        .fromPath('data/*.fastq.gz')
        .map { file ->
            def id = file.getBaseName().replaceFirst(/\.fastq\.gz$/, '').replaceFirst(/\.gz$/, '')
            tuple(id, file)
        }
        .set { read_pairs }

    FastQC(read_pairs)
}
