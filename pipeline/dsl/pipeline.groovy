pipeline_repo = "stelligent/pipeline_sec_group.git"

workflowJob('security-pipeline') {
  triggers {
    scm("* * * * *")
  }
  definition {
    cpsScm {
      scm {
          git {
            remote {
                github(pipeline_repo)
            }
          }
      }
    scriptPath('pipeline/workflow/security_group_pipeline.groovy')
    }
  }
}