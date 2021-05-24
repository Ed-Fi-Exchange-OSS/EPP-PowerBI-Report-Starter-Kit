SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[analytics].[tpdm_Survey]') IS NOT NULL
	DROP VIEW [analytics].[tpdm_Survey]

GO

CREATE VIEW [analytics].[tpdm_Survey] AS

---Survey
SELECT tc.CandidateIdentifier
		,s.SurveyTitle
		,sse.SurveySectionTitle
		,sr.ResponseDate
		,q.QuestionCode
		,q.QuestionText
		,mq.TextResponse
FROM [tpdm].[SurveyResponsePersonTargetAssociation] sa
JOIN tpdm.Candidate tc on sa.PersonId = tc.PersonId
JOIN tpdm.SurveySectionExtension sse on sa.SurveyIdentifier = sse.SurveyIdentifier
JOIN edfi.Survey s on sa.SurveyIdentifier = s.SurveyIdentifier
JOIN edfi.SurveyResponse sr on sa.SurveyResponseIdentifier = sr.SurveyResponseIdentifier
JOIN edfi.SurveyQuestion q on sa.SurveyIdentifier = q.SurveyIdentifier 
	and sse.SurveySectionTitle = q.SurveySectionTitle
JOIN edfi.SurveyQuestionResponseSurveyQuestionMatrixElementResponse mq on sa.SurveyResponseIdentifier = mq.SurveyResponseIdentifier
	and q.QuestionCode = mq.QuestionCode

GO

