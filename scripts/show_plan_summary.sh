#!/bin/bash

# constant for the terraform plan binary file's path
TFPLAN_BINARY='./tfplan.binary'

# check if the terraform plan binary file exists
if [[ ! -f "$TFPLAN_BINARY" ]]; then
  echo "Error: Terraform plan binary '$TFPLAN_BINARY' not found."
  exit 1
fi


# extract resource summary lines
# grep '#'               : include lines with # (a terraform plan marks every changed resource with #)
# | grep -v 'unchanged'  : exclude lines with 'unchanged' (these are info messages that are not relevant)
# | nl                   : add line numbers for better readability
# | sed 's/#//g'         : remove the # character for cleaner output
# || true                : grep returns non-zero exit code if no lines match - the "or true" prevents the script from exiting
get_resource_summary() {
  grep '#' | grep -v 'unchanged' | nl | sed 's/#//g' || true
}

# extract plan summary lines
get_plan_summary() {
  grep -E '(No changes|Plan:)' || true
}


# convert the terraform plan from binary to text with color codes
# pipe it to functions to get resource summary and plan summary
# send the output to stdout
# use echo to add new lines for better readability
# send a notice to GitHub Actions log
#   https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands#setting-a-notice-message
echo
terraform show "$TFPLAN_BINARY" | get_resource_summary
echo
terraform show "$TFPLAN_BINARY" | get_plan_summary
echo
echo "::notice::Plan summary."


# do the same thing but without color codes and send it to the GitHub step summary
# GitHub step summary doesn't support color codes
#   https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands#adding-a-job-summary
terraform show -no-color "$TFPLAN_BINARY" | get_resource_summary >> "$GITHUB_STEP_SUMMARY"
terraform show -no-color "$TFPLAN_BINARY" | get_plan_summary     >> "$GITHUB_STEP_SUMMARY"
