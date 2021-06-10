-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[analytics].[tpdm_EvaluationRatingResult]') IS NOT NULL
	DROP VIEW [analytics].[tpdm_EvaluationRatingResult]

GO

CREATE VIEW [analytics].[tpdm_EvaluationRatingResult] AS

---EVALUATION RATING RESULT
SELECT c.CandidateIdentifier
		,err.EvaluationDate
		,err.EvaluationTitle
		,err.Rating
		,err.RatingResultTitle
	FROM tpdm.EvaluationRatingResult err
	JOIN tpdm.Candidate c on err.PersonId = c.PersonId
	
GO