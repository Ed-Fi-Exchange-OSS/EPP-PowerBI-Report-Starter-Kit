-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('analytics.epp_EvaluationObjectiveRatingDim') IS NOT NULL
	DROP VIEW analytics.epp_EvaluationObjectiveRatingDim

GO

CREATE VIEW analytics.epp_EvaluationObjectiveRatingDim AS

WITH EOL AS (
	SELECT
		[EducationOrganizationId],
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
				t1.[EvaluationObjectiveTitle],
				t1.[EvaluationPeriodDescriptorId],
				t1.[EvaluationTitle],
				t1.[PerformanceEvaluationTitle],
				t1.[PerformanceEvaluationTypeDescriptorId],
				t1.[SchoolYear],
				t1.[TermDescriptorId],
				col, value
			FROM tpdm.EvaluationObjective t1
			INNER JOIN
			(
				SELECT
					[EducationOrganizationId],
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
						[EvaluationObjectiveTitle],
						[EvaluationPeriodDescriptorId],
						[EvaluationTitle],
						[PerformanceEvaluationTitle],
						[PerformanceEvaluationTypeDescriptorId],
						[SchoolYear],
						[TermDescriptorId],
						[MinRating],[MaxRating],
						Descriptor.CodeValue AS EvaluationRatingLevelDescriptor,
						RN = CAST(ROW_NUMBER() OVER(PARTITION BY [EducationOrganizationId], [EvaluationObjectiveTitle], [EvaluationPeriodDescriptorId], [EvaluationTitle], [PerformanceEvaluationTitle], [PerformanceEvaluationTypeDescriptorId], [SchoolYear], [TermDescriptorId] ORDER BY [EducationOrganizationId], [EvaluationObjectiveTitle], [EvaluationPeriodDescriptorId], [EvaluationTitle], [PerformanceEvaluationTitle], [PerformanceEvaluationTypeDescriptorId], [SchoolYear], [TermDescriptorId],[MinRating]) AS VARCHAR(10))
						FROM tpdm.EvaluationObjectiveRatingLevel
						JOIN edfi.Descriptor
						ON EvaluationObjectiveRatingLevel.EvaluationRatingLevelDescriptorId = Descriptor.DescriptorId

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
		,EvaluationObjectiveRatingResult.EvaluationDate
		,CONVERT(VARCHAR, EvaluationObjectiveRatingResult.EvaluationDate, 112) as EvaluationDateKey
		,EvaluationObjectiveRatingResult.PerformanceEvaluationTitle
		,EvaluationObjective.EvaluationObjectiveTitle
		,EvaluationObjectiveRatingResult.RatingResultTitle
		,EvaluationObjectiveRatingResult.EvaluationTitle
        ,CAST(EvaluationObjectiveRatingResult.TermDescriptorId as VARCHAR) AS	TermDescriptorId
		,CAST(EvaluationObjectiveRatingResult.TermDescriptorId AS VARCHAR) AS TermDescriptorKey
        ,cast(EvaluationObjectiveRatingResult.SchoolYear as varchar) AS SchoolYear
		,EvaluationObjectiveRatingResult.Rating,
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
	tpdm.EvaluationObjectiveRatingResult
	JOIN tpdm.Candidate
		ON
			EvaluationObjectiveRatingResult.PersonId = Candidate.PersonId AND
			EvaluationObjectiveRatingResult.SourceSystemDescriptorId = Candidate.SourceSystemDescriptorId
	JOIN tpdm.EvaluationObjective
		ON
			EvaluationObjectiveRatingResult.[EducationOrganizationId] = EvaluationObjective.[EducationOrganizationId] AND
			EvaluationObjectiveRatingResult.[EvaluationObjectiveTitle] = EvaluationObjective.[EvaluationObjectiveTitle] AND
			EvaluationObjectiveRatingResult.[EvaluationPeriodDescriptorId] = EvaluationObjective.[EvaluationPeriodDescriptorId] AND
			EvaluationObjectiveRatingResult.[EvaluationTitle] = EvaluationObjective.[EvaluationTitle] AND
			EvaluationObjectiveRatingResult.[PerformanceEvaluationTitle] = EvaluationObjective.[PerformanceEvaluationTitle] AND
			EvaluationObjectiveRatingResult.[PerformanceEvaluationTypeDescriptorId] = EvaluationObjective.[PerformanceEvaluationTypeDescriptorId] AND
			EvaluationObjectiveRatingResult.[SchoolYear] = EvaluationObjective.[SchoolYear] AND
			EvaluationObjectiveRatingResult.[TermDescriptorId] = EvaluationObjective.[TermDescriptorId]
	LEFT JOIN EOL
		ON
			EvaluationObjectiveRatingResult.[EducationOrganizationId] = EOL.[EducationOrganizationId] AND
			EvaluationObjectiveRatingResult.[EvaluationObjectiveTitle] = EOL.[EvaluationObjectiveTitle] AND
			EvaluationObjectiveRatingResult.[EvaluationPeriodDescriptorId] = EOL.[EvaluationPeriodDescriptorId] AND
			EvaluationObjectiveRatingResult.[EvaluationTitle] = EOL.[EvaluationTitle] AND
			EvaluationObjectiveRatingResult.[PerformanceEvaluationTitle] = EOL.[PerformanceEvaluationTitle] AND
			EvaluationObjectiveRatingResult.[PerformanceEvaluationTypeDescriptorId] = EOL.[PerformanceEvaluationTypeDescriptorId] AND
			EvaluationObjectiveRatingResult.[SchoolYear] = EOL.[SchoolYear] AND
			EvaluationObjectiveRatingResult.[TermDescriptorId] = EOL.[TermDescriptorId]
GO
