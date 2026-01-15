#!/usr/bin/env bash
set -euo pipefail

pass(){ echo "✅ $1"; }
fail(){ echo "❌ $1"; exit 1; }

echo "Test 1: IT -> Sales (should PASS)"
docker exec -it clab-cisco-smart-enterprise-it ping -c 1 -W 1 192.168.10.10 >/dev/null && pass "IT -> Sales allowed" || fail "IT -> Sales failed"

echo "Test 2: Sales -> IT (should FAIL)"
if docker exec -it clab-cisco-smart-enterprise-sales ping -c 1 -W 1 192.168.30.10 >/dev/null; then
  fail "Sales -> IT should be blocked but succeeded"
else
  pass "Sales -> IT blocked"
fi

echo "Test 3: Ops -> Mgmt (should FAIL)"
if docker exec -it clab-cisco-smart-enterprise-ops ping -c 1 -W 1 192.168.40.10 >/dev/null; then
  fail "Ops -> Mgmt should be blocked but succeeded"
else
  pass "Ops -> Mgmt blocked"
fi

echo "🎉 All tests passed."
