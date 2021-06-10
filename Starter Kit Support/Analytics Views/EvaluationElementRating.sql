-- SPDX-License-Identifier: Apache-2.0-- Licensed to the Ed-Fi Alliance under one or more agreements.-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.-- See the LICENSE and NOTICES files in the project root for more information.
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[analytics].[tpdm_EvaluationElementRating]') IS NOT NULL
	DROP VIEW [analytics].[tpdm_EvaluationElementRating]

GO

CREATE VIEW [analytics].[tpdm_EvaluationElementRating] AS

---Evaluation Rating: perfomance evaluation >> Objective >> Element
SELECT DISTINCT tc.CandidateIdentifier
		,r.EvaluationDate
		,r.PerformanceEvaluationTitle
		,eo.EvaluationObjectiveTitle
		,r.EvaluationElementTitle
		,r.RatingResultTitle
		,r.Rating
FROM [tpdm].EvaluationElementRatingResult r
JOIN tpdm.Candidate tc on r.PersonId = tc.PersonId
JOIN tpdm.EvaluationObjective eo on r.EvaluationObjectiveTitle = eo.EvaluationObjectiveTitle
GO


