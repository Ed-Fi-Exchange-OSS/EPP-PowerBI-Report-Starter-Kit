USE [EdFi_Ods_Populated_Template3]
GO

/****** Object:  View [analytics].[EvaluationElementRating]    Script Date: 12/21/2020 1:01:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[analytics].[EvaluationElementRating]') IS NOT NULL
	DROP VIEW [analytics].[EvaluationElementRating]

GO

CREATE VIEW [analytics].[EvaluationElementRating] AS

---Evaluation Rating: perfomance evaluation >> Objective >> Element
SELECT DISTINCT tc.TeacherCandidateIdentifier
		,r.EvaluationDate
		,r.PerformanceEvaluationTitle
		,eo.EvaluationObjectiveTitle
		,r.EvaluationElementTitle
		,r.RatingResultTitle
		,r.Rating
FROM [EdFi_Ods_Populated_Template3].[tpdm].EvaluationElementRatingResult r
JOIN tpdm.TeacherCandidate tc on r.PersonId = tc.PersonId
JOIN tpdm.EvaluationObjective eo on r.EvaluationObjectiveTitle = eo.EvaluationObjectiveTitle


GO


