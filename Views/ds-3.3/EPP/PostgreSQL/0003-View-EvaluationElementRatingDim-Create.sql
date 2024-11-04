-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

DROP VIEW IF EXISTS analytics.EPP_EvaluationElementRatingDim;

CREATE OR REPLACE VIEW analytics.EPP_EvaluationElementRatingDim AS

WITH EEL AS (
	SELECT
		EducationOrganizationId,
		EvaluationElementTitle, 
		EvaluationObjectiveTitle, 
		EvaluationPeriodDescriptorId, 
		EvaluationTitle, 
		PerformanceEvaluationTitle, 
		PerformanceEvaluationTypeDescriptorId, 
		SchoolYear, 
		TermDescriptorId,
		MinRating_1,MaxRating_1,EvaluationRatingLevelDescriptor_1,
		MinRating_2,MaxRating_2,EvaluationRatingLevelDescriptor_2,
		MinRating_3,MaxRating_3,EvaluationRatingLevelDescriptor_3,
		MinRating_4,MaxRating_4,EvaluationRatingLevelDescriptor_4,
		MinRating_5,MaxRating_5,EvaluationRatingLevelDescriptor_5,
		MinRating_6,MaxRating_6,EvaluationRatingLevelDescriptor_6,
		MinRating_7,MaxRating_7,EvaluationRatingLevelDescriptor_7,
		MinRating_8,MaxRating_8,EvaluationRatingLevelDescriptor_8,
		MinRating_9,MaxRating_9,EvaluationRatingLevelDescriptor_9,
		MinRating_10,MaxRating_10,EvaluationRatingLevelDescriptor_10
	FROM tpdm.EvaluationElement t1
	JOIN
	(
		SELECT * FROM CROSSTAB
			(
				$$
				SELECT 
				ROW_NUMBER() OVER(Partition By MinRating, value Order By MinRating) AS rn,
				'category' as category,
				value
				FROM
				(
					SELECT DISTINCT	MinRating,	CAST(MinRating AS TEXT) as Value
					FROM tpdm.EvaluationElementRatingLevel

					UNION ALL

					SELECT DISTINCT	MinRating,	CAST(MaxRating AS TEXT) as Value
					FROM tpdm.EvaluationElementRatingLevel

					UNION ALL

					SELECT DISTINCT	MinRating,	CodeValue as Value
					FROM tpdm.EvaluationElementRatingLevel
					JOIN edfi.Descriptor 
					ON EvaluationElementRatingLevel.EvaluationRatingLevelDescriptorId = Descriptor.DescriptorId
				) a
				ORDER BY rn, minRating
				$$
			)
			AS ct
			(
			rn bigint, 
			MinRating_1 text,MaxRating_1 text,EvaluationRatingLevelDescriptor_1 text,
			MinRating_2 text,MaxRating_2 text,EvaluationRatingLevelDescriptor_2 text,
			MinRating_3 text,MaxRating_3 text,EvaluationRatingLevelDescriptor_3 text,
			MinRating_4 text,MaxRating_4 text,EvaluationRatingLevelDescriptor_4 text,
			MinRating_5 text,MaxRating_5 text,EvaluationRatingLevelDescriptor_5 text,
			MinRating_6 text,MaxRating_6 text,EvaluationRatingLevelDescriptor_6 text,
			MinRating_7 text,MaxRating_7 text,EvaluationRatingLevelDescriptor_7 text,
			MinRating_8 text,MaxRating_8 text,EvaluationRatingLevelDescriptor_8 text,
			MinRating_9 text,MaxRating_9 text,EvaluationRatingLevelDescriptor_9 text,
			MinRating_10 text,MaxRating_10 text,EvaluationRatingLevelDescriptor_10 text
			)
	) t2 ON TRUE	
)

---Evaluation Rating: perfomance evaluation >> Objective >> Element
SELECT 
	DISTINCT Candidate.CandidateIdentifier AS CandidateKey
		,EvaluationElementRatingResult.EvaluationDate
		,to_char(EvaluationElementRatingResult.EvaluationDate, 'YYYYMMDD') as EvaluationDateKey
		,EvaluationElementRatingResult.PerformanceEvaluationTitle
		,EvaluationObjective.EvaluationObjectiveTitle
		,EvaluationElementRatingResult.EvaluationElementTitle
		,EvaluationElementRatingResult.RatingResultTitle
		,EvaluationElementRatingResult.EvaluationTitle
        ,CAST(EvaluationElementRatingResult.TermDescriptorId as TEXT) AS	TermDescriptorId
		,CAST(EvaluationElementRatingResult.TermDescriptorId AS TEXT) AS TermDescriptorKey
        ,CAST(EvaluationElementRatingResult.SchoolYear as TEXT) AS SchoolYear
		,EvaluationElementRatingResult.Rating,
		(	SELECT 
				MAX(MaxLastModifiedDate)
			FROM (VALUES (Candidate.LastModifiedDate)
						,(EvaluationObjective.LastModifiedDate)
				 ) AS VALUE (MaxLastModifiedDate)
		) AS LastModifiedDate,
		MinRating_1,MaxRating_1,EvaluationRatingLevelDescriptor_1,
		MinRating_2,MaxRating_2,EvaluationRatingLevelDescriptor_2,
		MinRating_3,MaxRating_3,EvaluationRatingLevelDescriptor_3,
		MinRating_4,MaxRating_4,EvaluationRatingLevelDescriptor_4,
		MinRating_5,MaxRating_5,EvaluationRatingLevelDescriptor_5,
		MinRating_6,MaxRating_6,EvaluationRatingLevelDescriptor_6,
		MinRating_7,MaxRating_7,EvaluationRatingLevelDescriptor_7,
		MinRating_8,MaxRating_8,EvaluationRatingLevelDescriptor_8,
		MinRating_9,MaxRating_9,EvaluationRatingLevelDescriptor_9,
		MinRating_10,MaxRating_10,EvaluationRatingLevelDescriptor_10
FROM
	tpdm.EvaluationElementRatingResult
	JOIN tpdm.Candidate
		ON 
			EvaluationElementRatingResult.PersonId = Candidate.PersonId AND 
			EvaluationElementRatingResult.SourceSystemDescriptorId = Candidate.SourceSystemDescriptorId
	JOIN tpdm.EvaluationObjective
		ON 
			EvaluationElementRatingResult.EducationOrganizationId = EvaluationObjective.EducationOrganizationId AND
			EvaluationElementRatingResult.EvaluationObjectiveTitle = EvaluationObjective.EvaluationObjectiveTitle AND
			EvaluationElementRatingResult.EvaluationPeriodDescriptorId = EvaluationObjective.EvaluationPeriodDescriptorId AND
			EvaluationElementRatingResult.EvaluationTitle = EvaluationObjective.EvaluationTitle AND
			EvaluationElementRatingResult.PerformanceEvaluationTitle = EvaluationObjective.PerformanceEvaluationTitle AND
			EvaluationElementRatingResult.PerformanceEvaluationTypeDescriptorId = EvaluationObjective.PerformanceEvaluationTypeDescriptorId AND
			EvaluationElementRatingResult.SchoolYear = EvaluationObjective.SchoolYear AND
			EvaluationElementRatingResult.TermDescriptorId = EvaluationObjective.TermDescriptorId
	LEFT JOIN EEL
		ON
			EvaluationElementRatingResult.EducationOrganizationId = EEL.EducationOrganizationId AND
			EvaluationElementRatingResult.EvaluationElementTitle = EEL.EvaluationElementTitle AND 
			EvaluationElementRatingResult.EvaluationObjectiveTitle = EEL.EvaluationObjectiveTitle AND
			EvaluationElementRatingResult.EvaluationPeriodDescriptorId = EEL.EvaluationPeriodDescriptorId AND
			EvaluationElementRatingResult.EvaluationTitle = EEL.EvaluationTitle AND
			EvaluationElementRatingResult.PerformanceEvaluationTitle = EEL.PerformanceEvaluationTitle AND
			EvaluationElementRatingResult.PerformanceEvaluationTypeDescriptorId = EEL.PerformanceEvaluationTypeDescriptorId AND
			EvaluationElementRatingResult.SchoolYear = EEL.SchoolYear AND
			EvaluationElementRatingResult.TermDescriptorId = EEL.TermDescriptorId

