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

    reads_ch = Channel
        .fromPath('data/*.fastq.gz')
        .map { file ->
            def id = file.getName().replaceFirst(/\.fastq\.gz$/, '')
            tuple(id, file)
        }

    FastQC(reads_ch)
}
