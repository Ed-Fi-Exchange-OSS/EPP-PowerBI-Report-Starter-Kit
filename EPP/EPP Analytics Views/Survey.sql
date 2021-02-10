USE [EdFi_Ods_Populated_Template3]
GO

/****** Object:  View [analytics].[tpdm_Survey]    Script Date: 12/21/2020 1:04:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[analytics].[tpdm_Survey]') IS NOT NULL
	DROP VIEW [analytics].[tpdm_Survey]

GO

CREATE VIEW [analytics].[tpdm_Survey] AS

---Survey
SELECT tc.TeacherCandidateIdentifier
		,s.SurveyTitle
		,sse.SurveySectionTitle
		,sr.ResponseDate
		,q.QuestionCode
		,q.QuestionText
		,mq.TextResponse
FROM [EdFi_Ods_Populated_Template3].[tpdm].[SurveyResponseTeacherCandidateTargetAssociation] sa
JOIN tpdm.TeacherCandidate tc on sa.TeacherCandidateIdentifier = tc.TeacherCandidateIdentifier
JOIN tpdm.SurveySectionExtension sse on sa.SurveyIdentifier = sse.SurveyIdentifier
JOIN edfi.Survey s on sa.SurveyIdentifier = s.SurveyIdentifier
JOIN edfi.SurveyResponse sr on sa.SurveyResponseIdentifier = sr.SurveyResponseIdentifier
JOIN edfi.SurveyQuestion q on sa.SurveyIdentifier = q.SurveyIdentifier 
	and sse.SurveySectionTitle = q.SurveySectionTitle
JOIN edfi.SurveyQuestionResponseSurveyQuestionMatrixElementResponse mq on sa.SurveyResponseIdentifier = mq.SurveyResponseIdentifier
	and q.QuestionCode = mq.QuestionCode




GO


