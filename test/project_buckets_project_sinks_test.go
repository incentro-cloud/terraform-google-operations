package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"testing"
)

func TestTerraformProjectBucketsProjectSinksExample(t *testing.T) {
	projectId := os.Getenv("PROJECT_ID")

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/project_buckets_project_sinks",
		Vars: map[string]interface{}{
			"project_id": projectId,
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}
