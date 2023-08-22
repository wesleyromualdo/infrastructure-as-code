package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func setUp(t *testing.T) *terraform.Options {
	return terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/s3_default",
	})
}

func TestS3Default(t *testing.T) {
	terraformOptions := setUp(t)
	bucketARN := "arn:aws:s3:::f491b9f5-86f4-48f0-bb67-bc9ac1ee0e65"

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
	output := terraform.Output(t, terraformOptions, "string_parameters_arns")

	assert.Equal(t, bucketARN, output)
}
