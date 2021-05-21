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