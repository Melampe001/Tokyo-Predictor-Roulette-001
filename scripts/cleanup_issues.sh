#!/bin/bash
set -e

echo "📝 Starting issue cleanup..."

# Close duplicate Copilot setup issues (keep #94 which has the PR)
echo "Closing duplicate issues..."
for issue in 85 93; do
  echo "  Closing issue #$issue"
  gh issue close $issue --comment "🤖 **Automated Cleanup**: Duplicate issue. Copilot setup completed via PR #94." 2>/dev/null || true
done

echo "✅ Issue cleanup completed"
