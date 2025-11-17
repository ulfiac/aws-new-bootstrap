#!/bin/bash

# context concept:
# https://docs.github.com/en/actions/concepts/workflows-and-actions/contexts

# context reference:
# https://docs.github.com/en/actions/reference/workflows-and-actions/contexts

# ::group:: and ::endgroup:: are GitHub Actions workflow commands
# https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands#grouping-log-lines

echo -e "Dumping context...\n"

echo "::group::env context:"
echo "$CONTEXT_ENV"
echo "::endgroup::"

echo "::group::github context:"
echo "$CONTEXT_GITHUB"
echo "::endgroup::"

echo "::group::inputs context:"
echo "$CONTEXT_INPUTS"
echo "::endgroup::"

echo "::group::job context:"
echo "$CONTEXT_JOB"
echo "::endgroup::"

echo "::group::matrix context:"
echo "$CONTEXT_MATRIX"
echo "::endgroup::"

echo "::group::needs context:"
echo "$CONTEXT_NEEDS"
echo "::endgroup::"

echo "::group::runner context:"
echo "$CONTEXT_RUNNER"
echo "::endgroup::"

echo "::group::secrets context:"
echo "$CONTEXT_SECRETS"
echo "::endgroup::"

echo "::group::steps context:"
echo "$CONTEXT_STEPS"
echo "::endgroup::"

echo "::group::strategy context:"
echo "$CONTEXT_STRATEGY"
echo "::endgroup::"

echo "::group::vars context:"
echo "$CONTEXT_VARS"
echo "::endgroup::"

echo -e "\n::notice::Context details.\n"
