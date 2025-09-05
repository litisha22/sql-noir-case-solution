-- 🎶 SQL Noir - Case File 2: The Stolen Sound
-- Crime Type: Theft
-- Location: West Hollywood Records
-- Stolen Item: Prized Vinyl Record ($10,000+)
-- Date: July 15, 1983

------------------------------------------------------
-- Step 1: Crime Scene Report
-- Pull the details of the theft on July 15, 1983
-- at West Hollywood Records. This sets the stage
-- for identifying linked witnesses and suspects.
------------------------------------------------------
SELECT *
FROM crime_scene
WHERE date = 19830715
  AND location = 'West Hollywood Records';

------------------------------------------------------
-- Step 2: Witness Records
-- Retrieve witness statements linked to this crime scene.
-- Their "clues" may point us toward suspects hiding in the shadows.
------------------------------------------------------
SELECT w.id, w.crime_scene_id, c.description, w.clue
FROM witnesses w
INNER JOIN crime_scene c 
    ON c.id = w.crime_scene_id
WHERE date = 19830715
  AND location = 'West Hollywood Records';

------------------------------------------------------
-- Step 3: Narrow Down Suspects
-- Using the witness clues as input:
--   Witness #1: "I saw a man wearing a red bandana rushing out of the store."
--   Witness #2: "The main thing I remember is that he had a distinctive gold watch on his wrist."
-- We filter the suspects list based on these attributes.
------------------------------------------------------
SELECT id, name, bandana_color, accessory
FROM suspects
WHERE bandana_color = 'red'
  AND accessory = 'gold watch';

------------------------------------------------------
-- Step 4: Confirm the Culprit
-- Cross-check suspects with their interview transcripts.
-- The truth always slips out when the lights get hot.
--
-- Suspect identified:
--   id = 97
--   name = Rico Delgado
-- Confession confirmed: Rico Delgado stole the record.
------------------------------------------------------
SELECT s.id, s.name, i.transcript
FROM suspects s
INNER JOIN interviews i 
    ON s.id = i.suspect_id
WHERE bandana_color = 'red'
  AND accessory = 'gold watch';
