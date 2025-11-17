#!/bin/bash

# input: the terraform action ('apply' or 'destroy')
tf_action="$1"

# constant for the terraform output file's path
TF_OUT="./tf${tf_action}.out"

# check if the terraform output file exists
if [[ ! -f "$TF_OUT" ]]; then
  echo "Error: Terraform apply/destroy output file '$TF_OUT' not found."
  exit 1
fi


# extract plan summary lines
get_plan_summary() {
  grep -E '(No changes|Plan:)' || true
}


# extrap apply summary line
get_apply_summary() {
  grep -E '(Apply complete)' || true
}


remove_color_codes() {
  sed -r 's/\x1B\[([0-9]{1,3}(;[0-9]{1,3})*)?[mGK]//g'
}


# cat out the terraform apply/destroy output
# pipe it to functions to get plan summary and apply summary
# send the output to stdout
# use echo to add new lines for better readability
# send a notice to GitHub Actions log
#   https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands#setting-a-notice-message
echo
cat "$TF_OUT" | get_plan_summary
echo
cat "$TF_OUT" | get_apply_summary
echo
echo "::notice::${tf_action^} summary."


# do the same thing but without color codes and send it to the GitHub step summary
# GitHub step summary doesn't support color codes
#   https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands#adding-a-job-summary
{
  cat "$TF_OUT" | remove_color_codes | get_plan_summary
  echo
  cat "$TF_OUT" | remove_color_codes | get_apply_summary
} >> "$GITHUB_STEP_SUMMARY"
