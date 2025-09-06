-- 💎 SQL Noir - Case File 6: The Vanishing Diamond
-- Crime Type: Theft
-- Location: Fontainebleau Hotel

------------------------------------------------------
-- Step 1: Establishing the scene of the crime
-- We begin at the Fontainebleau Hotel, the stage for the gala.
-- Pulling details from the crime_scene table to set the timeline
-- and uncover what was recorded about the missing diamond.
------------------------------------------------------
SELECT id, date, location, description
FROM crime_scene
WHERE location LIKE '%Fontainebleau Hotel%';

------------------------------------------------------
-- Step 2: Following the witness trail
-- Date: 1987-05-20
-- The crime scene report pointed to two key witnesses:
--   1. A famous actor.
--   2. A consultant, her first name ending in 'an'.
-- Our job: pull their records from the witness list
-- on the night the Heart of Atlantis vanished.
------------------------------------------------------
SELECT ws.guest_id, g.name, g.occupation,g.invitation_code, ws.clue 
FROM witness_statements ws
INNER JOIN guest g ON g.id = ws.guest_id
WHERE g.occupation = 'Actor'
OR (g.occupation = 'Consultant' AND SUBSTRING(g.name, 1, CHARINDEX(' ', g.name) - 1) LIKE '%an');

-- ------------------------------------------------------
-- Step 3: Pursuing the lead from invitations and locations
-- Witnesses described:
--   - Someone with an invitation code ending in "-R," 
--     wearing a navy suit and white tie.
--   - A cryptic rendezvous at the marina, dock 3.
-- Next, we focus on guests matching those details or 
-- linked to these locations, tracking movements before the diamond vanished.
------------------------------------------------------
SELECT ar.guest_id, g.name, g.occupation, g.invitation_code, mr.dock_number
FROM attire_registry ar
INNER JOIN marina_rentals mr ON mr.renter_guest_id = ar.guest_id
INNER JOIN guest g ON g.id = ar.guest_id
WHERE g.invitation_code LIKE '%-R'
  AND ar.note LIKE '%navy suit%white tie%'
  AND mr.dock_number = 3;

-- ------------------------------------------------------
-- Step 4: Closing in on the prime suspect
-- Guest ID 105 emerges from the clues and is brought in for questioning.
-- The final interviews table holds the key to uncovering the truth.
-- Let's retrieve the confession that cracks the case wide open.
------------------------------------------------------
SELECT *
FROM final_interviews
WHERE guest_id = 105;

-- 📝 Case Closed:
-- The gala’s shadows cleared to reveal the thief plainly.
-- Mike Manning, cornered by the evidence,
-- confessed and returned the Heart of Atlantis.
-- The Vanishing Diamond mystery is solved.
