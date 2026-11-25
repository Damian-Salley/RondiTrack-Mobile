BEGIN;
CREATE TABLE assignment121_contribution_fixture (
  cycle_id integer PRIMARY KEY,
  stokvel_id integer NOT NULL,
  user_id integer NOT NULL
);
INSERT INTO assignment121_contribution_fixture
SELECT ids.cycle_id, payer.stokvel_id, payer.user_id
FROM generate_series(1201001, 1201300) AS ids(cycle_id)
CROSS JOIN (
  SELECT c."StokvelId" AS stokvel_id, c."UserId" AS user_id
  FROM "Contributions" c JOIN "Stokvels" s ON s."Id" = c."StokvelId"
  WHERE s."Name" = 'Community Savings'
  ORDER BY c."UserId", c."Cycle"
  LIMIT 1
) payer;
DO $$
BEGIN
  IF (SELECT count(*) FROM assignment121_contribution_fixture) <> 300 THEN
    RAISE EXCEPTION 'Expected a seeded Community Savings fixture payer';
  END IF;
END
$$;
INSERT INTO "ContributionCycles" (
  "Id", "StokvelId", "Number", "Status", "TargetAmount",
  "RequiredContributionAmount", "EndsAtUtc", "ClosedAtUtc"
)
SELECT cycle_id, stokvel_id, cycle_id, 'Closed', 12.01, 12.01,
  TIMESTAMPTZ '2060-11-30 22:00:00+00', TIMESTAMPTZ '2060-11-30 22:00:00+00'
FROM assignment121_contribution_fixture;
INSERT INTO "Contributions" (
  "StokvelId", "UserId", "Cycle", "ContributionAmount", "Status", "PaidAtUtc"
)
SELECT stokvel_id, user_id, cycle_id, 12.01, 'Paid',
  TIMESTAMPTZ '2060-12-01 00:00:00+00' + (cycle_id - 1201000) * interval '1 second'
FROM assignment121_contribution_fixture;
COMMIT;
