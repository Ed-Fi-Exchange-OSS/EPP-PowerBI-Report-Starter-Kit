-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.
IF OBJECT_ID('analytics.MostRecentGradingPeriod') IS NOT NULL 
	DROP VIEW analytics.MostRecentGradingPeriod

GO
CREATE VIEW analytics.MostRecentGradingPeriod AS

	SELECT
		SchoolKey,
		MAX(GradingPeriodBeginDateKey) as GradingPeriodBeginDateKey
	FROM 
		analytics.GradingPeriodDim
	GROUP BY
		SchoolKey
