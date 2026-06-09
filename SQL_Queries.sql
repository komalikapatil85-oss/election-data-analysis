-- 1. Total votes cast
SELECT SUM(votes) AS total_votes
FROM election_results;

-- 2. Party-wise total votes
SELECT party, SUM(votes) AS total_votes
FROM election_results
GROUP BY party
ORDER BY total_votes DESC;

-- 3. Winner candidate per constituency
SELECT constituency, candidate, party, votes
FROM election_results e1
WHERE votes = (
    SELECT MAX(votes)
    FROM election_results e2
    WHERE e1.constituency = e2.constituency
);

-- 4. Top 5 candidates by votes
SELECT candidate, party, votes
FROM election_results
ORDER BY votes DESC
LIMIT 5;

-- 5. Party with highest wins
SELECT party, COUNT(*) AS wins
FROM election_results
WHERE is_winner = 1
GROUP BY party
ORDER BY wins DESC;

-- 6. Constituency-wise total votes
SELECT constituency, SUM(votes) AS total_votes
FROM election_results
GROUP BY constituency;

-- 7. Average votes per candidate
SELECT AVG(votes) AS avg_votes
FROM election_results;

-- 8. Highest vote margin winner
SELECT constituency, candidate, (votes - runner_up_votes) AS margin
FROM election_results
ORDER BY margin DESC
LIMIT 1;

-- 9. Party performance percentage
SELECT party,
       SUM(votes) * 100.0 / (SELECT SUM(votes) FROM election_results) AS vote_share
FROM election_results
GROUP BY party;

-- 10. Candidates who lost elections
SELECT candidate, party, votes
FROM election_results
WHERE is_winner = 0;

-- 11. State-wise total votes (if state column exists)
SELECT state, SUM(votes) AS total_votes
FROM election_results
GROUP BY state;

-- 12. Constituency with highest turnout
SELECT constituency, SUM(votes) AS turnout
FROM election_results
GROUP BY constituency
ORDER BY turnout DESC
LIMIT 1;

-- 13. Party with most candidates
SELECT party, COUNT(candidate) AS total_candidates
FROM election_results
GROUP BY party
ORDER BY total_candidates DESC;

-- 14. Close contests (low margin cases)
SELECT constituency, candidate, votes
FROM election_results
WHERE votes < 1000;

-- 15. Rank candidates within constituency
SELECT constituency, candidate, party, votes,
       RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS rank
FROM election_results;
