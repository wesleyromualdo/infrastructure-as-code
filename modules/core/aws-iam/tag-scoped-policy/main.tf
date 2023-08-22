locals {
  extra_actions_switch = length(var.extra_tag_scoped_actions) > 0 ? ["extra_actions"] : []
  non_tag_scoped_actions_switch = length(var.non_tag_scoped_actions) > 0 ? ["non_tag_scoped_actions"] : []
  resource_scoped_actions_switch = length(var.resource_scoped_actions) > 0 && length(var.resource_scoped_actions) > 0 ? ["resource_scoped_actions"]: []
}

data "aws_iam_policy" "policies_to_attach" {
  for_each = toset(var.original_policies)
  name = each.value
}

data "aws_iam_policy_document" "policies_to_attach" {
  dynamic statement {
    // This block creates dynamic IAM statements for each element in the list of local.extra_actions_switch.
    // Each statement will have a different set of conditions depending on the elements in var.tags_scope.
    for_each = local.extra_actions_switch
    content {
      // These are the actions that each statement will allow.
      actions = var.extra_tag_scoped_actions
      // These statements will allow the specified effect.
      effect = "Allow"
      // These statements will apply to all resources.
      resources = ["*"]

      // This block creates dynamic IAM conditions for each element in the list of var.tags_scope.
      dynamic condition {
        // Each condition will have a different variable depending on the key-value pairs in var.tags_scope.
        for_each = var.tags_scope
        content {
          // This variable specifies the tag key-value pair that the condition will test against.
          variable = "aws:ResourceTag/${condition.key}"
          // This test specifies the type of comparison to perform between the tag value and the condition value.
          test     = "StringEquals"
          // These are the condition values to test against.
          values   = [condition.value]
        }
      }
    }
  }


# This dynamic block creates AWS IAM policy statements for non-tag-scoped actions
  dynamic statement {
    for_each = local.non_tag_scoped_actions_switch # Iterate over a map to create a statement for each key-value pair
    content {
      actions = var.non_tag_scoped_actions # Specify the actions that are allowed for the given resource
      effect = "Allow" # Specify the effect of the statement (in this case, allow)
      resources = ["*"] # Specify the ARNs of the resources the statement applies to (in this case, all resources)
    }
  }

  # This dynamic block creates AWS IAM policy statements for resource-scoped actions
  dynamic statement {
    for_each = local.resource_scoped_actions_switch # Iterate over a map to create a statement for each key-value pair
    content {
      actions = var.resource_scoped_actions # Specify the actions that are allowed for the given resource
      effect = "Allow" # Specify the effect of the statement (in this case, allow)
      resources = var.resource_scoped_arns # Specify the ARNs of the resources the statement applies to (as specified in the input variable)
    }
  }


  dynamic statement { # Creates a dynamic block for an IAM statement
    for_each = var.original_policies # Loops through all the original policies
    content { # Begins the content block for each individual statement
      actions = flatten([ # Retrieves all the IAM actions from a JSON policy document
        for statement in jsondecode(data.aws_iam_policy.policies_to_attach[statement.value].policy).Statement:
          statement.Action
      ])
      effect = "Allow" # Sets the effect of the statement to "Allow"
      resources = ["*"] # Allows the statement to access all resources
      dynamic condition { # Creates a dynamic block for conditions that must be met for the statement to apply
        for_each = var.tags_scope # Loops through each tag scope defined in the input variables
        content { # Begins the content block for each individual condition
          test = "StringEquals" # Compares two strings for exact match
          values = [condition.value] # Sets the value to match against the tag key
          variable = "aws:ResourceTag/${condition.key}" # Specifies the tag key to match against
        }
      }
    }
  }
}

# This block defines an AWS IAM policy resource.
resource "aws_iam_policy" "this" {
  # The policy's name is set to the value of the "name" variable.
  name = var.name

  # The policy's contents are set to the JSON output of an AWS policy document data source.
  policy = data.aws_iam_policy_document.policies_to_attach.json

  # Tags are applied to the policy based on the "tags" variable.
  tags = var.tags
}
