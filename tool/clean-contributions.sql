BEGIN;
DELETE FROM "Contributions" c USING assignment121_contribution_fixture f
WHERE c."StokvelId" = f.stokvel_id AND c."UserId" = f.user_id AND c."Cycle" = f.cycle_id
  AND c."ContributionAmount" = 12.01 AND c."Status" = 'Paid'
  AND c."PaidAtUtc" = TIMESTAMPTZ '2060-12-01 00:00:00+00' + (f.cycle_id - 1201000) * interval '1 second';
DELETE FROM "ContributionCycles" c USING assignment121_contribution_fixture f
WHERE c."Id" = f.cycle_id AND c."StokvelId" = f.stokvel_id
  AND NOT EXISTS (SELECT 1 FROM "Contributions" p WHERE p."Cycle" = c."Id");
DROP TABLE assignment121_contribution_fixture;
COMMIT;
