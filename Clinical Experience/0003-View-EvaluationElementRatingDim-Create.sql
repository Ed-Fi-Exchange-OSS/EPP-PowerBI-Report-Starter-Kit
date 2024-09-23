USE [EdFi_Ods_Populated_Template_Test]
GO

/****** Object:  View [analytics].[EPP_EvaluationElementRatingDim]    Script Date: 4/25/2024 11:45:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [analytics].[EPP_EvaluationElementRatingDim] AS

WITH EEL AS (
	SELECT
		[EducationOrganizationId],
		[EvaluationElementTitle], 
		[EvaluationObjectiveTitle], 
		[EvaluationPeriodDescriptorId], 
		[EvaluationTitle], 
		[PerformanceEvaluationTitle], 
		[PerformanceEvaluationTypeDescriptorId], 
		[SchoolYear], 
		[TermDescriptorId],
		[MinRating_1],[MaxRating_1],[EvaluationRatingLevelDescriptor_1],
		[MinRating_2],[MaxRating_2],[EvaluationRatingLevelDescriptor_2],
		[MinRating_3],[MaxRating_3],[EvaluationRatingLevelDescriptor_3],
		[MinRating_4],[MaxRating_4],[EvaluationRatingLevelDescriptor_4],
		[MinRating_5],[MaxRating_5],[EvaluationRatingLevelDescriptor_5],
		[MinRating_6],[MaxRating_6],[EvaluationRatingLevelDescriptor_6],
		[MinRating_7],[MaxRating_7],[EvaluationRatingLevelDescriptor_7],
		[MinRating_8],[MaxRating_8],[EvaluationRatingLevelDescriptor_8],
		[MinRating_9],[MaxRating_9],[EvaluationRatingLevelDescriptor_9],
		[MinRating_10],[MaxRating_10],[EvaluationRatingLevelDescriptor_10]
		FROM
		(
			SELECT
				t1.[EducationOrganizationId], 
				t1.[EvaluationElementTitle], 
				t1.[EvaluationObjectiveTitle], 
				t1.[EvaluationPeriodDescriptorId], 
				t1.[EvaluationTitle], 
				t1.[PerformanceEvaluationTitle], 
				t1.[PerformanceEvaluationTypeDescriptorId], 
				t1.[SchoolYear], 
				t1.[TermDescriptorId],
				col, value
			FROM tpdm.EvaluationElement t1
			INNER JOIN
			(
				SELECT
					[EducationOrganizationId], 
					[EvaluationElementTitle], 
					[EvaluationObjectiveTitle], 
					[EvaluationPeriodDescriptorId], 
					[EvaluationTitle], 
					[PerformanceEvaluationTitle], 
					[PerformanceEvaluationTypeDescriptorId], 
					[SchoolYear], 
					[TermDescriptorId],
					col, value
				FROM
				(
					SELECT
						[EducationOrganizationId], 
						[EvaluationElementTitle], 
						[EvaluationObjectiveTitle], 
						[EvaluationPeriodDescriptorId], 
						[EvaluationTitle], 
						[PerformanceEvaluationTitle], 
						[PerformanceEvaluationTypeDescriptorId], 
						[SchoolYear], 
						[TermDescriptorId],
						[MinRating],[MaxRating]
						,Descriptor.CodeValue AS EvaluationRatingLevelDescriptor, 
						RN = CAST(ROW_NUMBER() OVER(PARTITION BY [EducationOrganizationId], [EvaluationElementTitle], [EvaluationObjectiveTitle], [EvaluationPeriodDescriptorId], [EvaluationTitle], [PerformanceEvaluationTitle], [PerformanceEvaluationTypeDescriptorId], [SchoolYear], [TermDescriptorId] ORDER BY [EducationOrganizationId], [EvaluationElementTitle], [EvaluationObjectiveTitle], [EvaluationPeriodDescriptorId], [EvaluationTitle], [PerformanceEvaluationTitle], [PerformanceEvaluationTypeDescriptorId], [SchoolYear], [TermDescriptorId],[MinRating]) AS VARCHAR(10))
						FROM tpdm.EvaluationElementRatingLevel
						JOIN edfi.Descriptor 
						ON EvaluationElementRatingLevel.EvaluationRatingLevelDescriptorId = Descriptor.DescriptorId
				) D
				CROSS APPLY
				(
					SELECT 'MinRating_' + RN, CAST(MinRating AS NVARCHAR(10)) UNION ALL
					SELECT 'MaxRating_'+ RN, CAST(MaxRating AS NVARCHAR(10)) UNION ALL
					SELECT 'EvaluationRatingLevelDescriptor_'+ RN, EvaluationRatingLevelDescriptor
				) C (col, value) 
			) t2	
			ON
				t1.[EducationOrganizationId] = t2.[EducationOrganizationId] AND
				t1.[EvaluationElementTitle] = t2.[EvaluationElementTitle] AND 
				t1.[EvaluationObjectiveTitle] = t2.[EvaluationObjectiveTitle] AND
				t1.[EvaluationPeriodDescriptorId] = t2.[EvaluationPeriodDescriptorId] AND
				t1.[EvaluationTitle] = t2.[EvaluationTitle] AND
				t1.[PerformanceEvaluationTitle] = t2.[PerformanceEvaluationTitle] AND
				t1.[PerformanceEvaluationTypeDescriptorId] = t2.[PerformanceEvaluationTypeDescriptorId] AND
				t1.[SchoolYear] = t2.[SchoolYear] AND
				t1.[TermDescriptorId] = t2.[TermDescriptorId]
		) x
		PIVOT
		(
			MAX(value)
			FOR COL IN (
			[MinRating_1],[MaxRating_1],[EvaluationRatingLevelDescriptor_1],
			[MinRating_2],[MaxRating_2],[EvaluationRatingLevelDescriptor_2],
			[MinRating_3],[MaxRating_3],[EvaluationRatingLevelDescriptor_3],
			[MinRating_4],[MaxRating_4],[EvaluationRatingLevelDescriptor_4],
			[MinRating_5],[MaxRating_5],[EvaluationRatingLevelDescriptor_5],
			[MinRating_6],[MaxRating_6],[EvaluationRatingLevelDescriptor_6],
			[MinRating_7],[MaxRating_7],[EvaluationRatingLevelDescriptor_7],
			[MinRating_8],[MaxRating_8],[EvaluationRatingLevelDescriptor_8],
			[MinRating_9],[MaxRating_9],[EvaluationRatingLevelDescriptor_9],
			[MinRating_10],[MaxRating_10],[EvaluationRatingLevelDescriptor_10]
			)
		) p

)

---Evaluation Rating: perfomance evaluation >> Objective >> Element
SELECT 
	DISTINCT Candidate.CandidateIdentifier AS CandidateKey
		,EvaluationElementRatingResult.EvaluationDate
		,CONVERT(VARCHAR, EvaluationElementRatingResult.EvaluationDate, 112) as EvaluationDateKey
		,EvaluationElementRatingResult.PerformanceEvaluationTitle
		,EvaluationObjective.EvaluationObjectiveTitle
		,EvaluationElementRatingResult.EvaluationElementTitle
		,EvaluationElementRatingResult.RatingResultTitle
		,EvaluationElementRatingResult.EvaluationTitle
        ,CAST(EvaluationElementRatingResult.TermDescriptorId as VARCHAR) AS	TermDescriptorId
		,CAST(EvaluationElementRatingResult.TermDescriptorId AS VARCHAR) AS TermDescriptorKey
        ,cast(EvaluationElementRatingResult.SchoolYear as varchar) AS SchoolYear
		,EvaluationElementRatingResult.Rating,
		(	SELECT 
				MAX(MaxLastModifiedDate)
			FROM (VALUES (Candidate.LastModifiedDate)
						,(EvaluationObjective.LastModifiedDate)
				 ) AS VALUE (MaxLastModifiedDate)
		) AS LastModifiedDate,
		[MinRating_1],[MaxRating_1],[EvaluationRatingLevelDescriptor_1],
		[MinRating_2],[MaxRating_2],[EvaluationRatingLevelDescriptor_2],
		[MinRating_3],[MaxRating_3],[EvaluationRatingLevelDescriptor_3],
		[MinRating_4],[MaxRating_4],[EvaluationRatingLevelDescriptor_4],
		[MinRating_5],[MaxRating_5],[EvaluationRatingLevelDescriptor_5],
		[MinRating_6],[MaxRating_6],[EvaluationRatingLevelDescriptor_6],
		[MinRating_7],[MaxRating_7],[EvaluationRatingLevelDescriptor_7],
		[MinRating_8],[MaxRating_8],[EvaluationRatingLevelDescriptor_8],
		[MinRating_9],[MaxRating_9],[EvaluationRatingLevelDescriptor_9],
		[MinRating_10],[MaxRating_10],[EvaluationRatingLevelDescriptor_10]
FROM
	tpdm.EvaluationElementRatingResult
	JOIN tpdm.Candidate
		ON 
			EvaluationElementRatingResult.PersonId = Candidate.PersonId AND 
			EvaluationElementRatingResult.SourceSystemDescriptorId = Candidate.SourceSystemDescriptorId
	JOIN tpdm.EvaluationObjective
		ON 
			EvaluationElementRatingResult.[EducationOrganizationId] = EvaluationObjective.[EducationOrganizationId] AND
			EvaluationElementRatingResult.[EvaluationObjectiveTitle] = EvaluationObjective.[EvaluationObjectiveTitle] AND
			EvaluationElementRatingResult.[EvaluationPeriodDescriptorId] = EvaluationObjective.[EvaluationPeriodDescriptorId] AND
			EvaluationElementRatingResult.[EvaluationTitle] = EvaluationObjective.[EvaluationTitle] AND
			EvaluationElementRatingResult.[PerformanceEvaluationTitle] = EvaluationObjective.[PerformanceEvaluationTitle] AND
			EvaluationElementRatingResult.[PerformanceEvaluationTypeDescriptorId] = EvaluationObjective.[PerformanceEvaluationTypeDescriptorId] AND
			EvaluationElementRatingResult.[SchoolYear] = EvaluationObjective.[SchoolYear] AND
			EvaluationElementRatingResult.[TermDescriptorId] = EvaluationObjective.[TermDescriptorId]
	LEFT JOIN EEL
		ON
			EvaluationElementRatingResult.[EducationOrganizationId] = EEL.[EducationOrganizationId] AND
			EvaluationElementRatingResult.[EvaluationElementTitle] = EEL.[EvaluationElementTitle] AND 
			EvaluationElementRatingResult.[EvaluationObjectiveTitle] = EEL.[EvaluationObjectiveTitle] AND
			EvaluationElementRatingResult.[EvaluationPeriodDescriptorId] = EEL.[EvaluationPeriodDescriptorId] AND
			EvaluationElementRatingResult.[EvaluationTitle] = EEL.[EvaluationTitle] AND
			EvaluationElementRatingResult.[PerformanceEvaluationTitle] = EEL.[PerformanceEvaluationTitle] AND
			EvaluationElementRatingResult.[PerformanceEvaluationTypeDescriptorId] = EEL.[PerformanceEvaluationTypeDescriptorId] AND
			EvaluationElementRatingResult.[SchoolYear] = EEL.[SchoolYear] AND
			EvaluationElementRatingResult.[TermDescriptorId] = EEL.[TermDescriptorId]
GO

