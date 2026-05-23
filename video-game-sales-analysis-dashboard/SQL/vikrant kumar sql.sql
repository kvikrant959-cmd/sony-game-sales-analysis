----Q1-

SELECT 
    Publisher_Name,
    SUM(NA_Sales + EU_Sales + JP_Sales + Other_Sales) AS Total_Sales
FROM video_game_sales as vs INNER JOIN video_game_publishers as vp on vs.Publisher_ID=vp.Publisher_ID
GROUP BY Publisher_Name
ORDER BY Total_Sales DESC;

--q2--

WITH GameSales AS (
    SELECT 
        Publisher_Name,
        Game_Name AS Game,
        (NA_Sales + EU_Sales + JP_Sales + Other_Sales) AS Total_Sales
    FROM video_game_sales  as vs INNER JOIN video_game_publishers as vp on vs.Publisher_ID=vp.Publisher_ID
)
SELECT TOP 1
    Publisher_Name,
    COUNT(Game) AS Best_Selling_Games
FROM GameSales
WHERE Total_Sales > 10
GROUP BY Publisher_Name
ORDER BY Best_Selling_Games DESC;


---q3---


WITH PublisherSales AS (
    SELECT 
        Publisher_Name,
        SUM(NA_Sales + EU_Sales + JP_Sales + Other_Sales) AS Publisher_Sales
    FROM video_game_sales as vs INNER JOIN video_game_publishers as vp on vs.Publisher_ID=vp.Publisher_ID
    GROUP BY Publisher_Name
),
TotalIndustry AS (
    SELECT SUM(NA_Sales + EU_Sales + JP_Sales + Other_Sales) AS Industry_Sales
    FROM video_game_sales
)
SELECT 
    p.Publisher_Name,
    p.Publisher_Sales,
    (p.Publisher_Sales * 100.0 / t.Industry_Sales) AS Percentage_Contribution
FROM PublisherSales p
CROSS JOIN TotalIndustry t
ORDER BY Percentage_Contribution DESC;

---q4---



WITH GameSales AS (
    SELECT 
        Publisher_Name,
        Game_Name AS Game,
        SUM(NA_Sales + EU_Sales + JP_Sales + Other_Sales) AS Game_Sales
    FROM video_game_sales as vs INNER JOIN video_game_publishers as vp on vs.Publisher_ID=vp.Publisher_ID
    GROUP BY Publisher_Name, Game_Name
)
SELECT TOP 1
    Publisher_Name,
    AVG(Game_Sales) AS Avg_Sales_Per_Game
FROM GameSales
GROUP BY Publisher_Name
ORDER BY Avg_Sales_Per_Game DESC;

--q6--

WITH YearlySales AS (
    SELECT 
        Publisher_Name,
        YEAR(Publish_Year) AS Sales_Year,
        SUM(NA_Sales + EU_Sales + JP_Sales + Other_Sales) AS Total_Sales
    FROM video_game_sales as vs INNER JOIN video_game_publishers as vp on vs.Publisher_ID=vp.Publisher_ID
    GROUP BY Publisher_Name, YEAR(Publish_Year)
    HAVING SUM(NA_Sales + EU_Sales + JP_Sales + Other_Sales) > 0
),
Streaks AS (
    SELECT 
        Publisher_Name,
        Sales_Year,
        LAG(Sales_Year) OVER (PARTITION BY Publisher_name ORDER BY Sales_Year) AS Prev_Year
    FROM YearlySales
)
SELECT TOP 1
    Publisher_Name,
    COUNT(*) AS Longest_Streak
FROM Streaks
WHERE Sales_Year - Prev_Year = 1
GROUP BY Publisher_Name
ORDER BY Longest_Streak DESC;