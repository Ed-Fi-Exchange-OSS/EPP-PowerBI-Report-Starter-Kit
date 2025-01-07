-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

CREATE OR REPLACE VIEW analytics.epp_EvaluationObjectiveRatingDim AS

WITH EOL AS (
	SELECT
		EducationOrganizationId,
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
					FROM tpdm.EvaluationObjectiveRatingLevel

					UNION ALL

					SELECT DISTINCT	MinRating,	CAST(MaxRating AS TEXT) as Value
					FROM tpdm.EvaluationObjectiveRatingLevel

					UNION ALL

					SELECT DISTINCT	MinRating,	CodeValue as Value
					FROM tpdm.EvaluationElementRatingLevel
					JOIN edfi.Descriptor
					ON EvaluationObjectiveRatingLevel.EvaluationRatingLevelDescriptorId = Descriptor.DescriptorId
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
		,EvaluationObjectiveRatingResult.EvaluationDate
		,to_char(EvaluationObjectiveRatingResult.EvaluationDate, 'YYYYMMDD') as EvaluationDateKey
		,EvaluationObjectiveRatingResult.PerformanceEvaluationTitle
		,EvaluationObjective.EvaluationObjectiveTitle
		,EvaluationObjectiveRatingResult.RatingResultTitle
		,EvaluationObjectiveRatingResult.EvaluationTitle
        ,CAST(EvaluationObjectiveRatingResult.TermDescriptorId as TEXT) AS	TermDescriptorId
		,CAST(EvaluationObjectiveRatingResult.TermDescriptorId AS TEXT) AS TermDescriptorKey
        ,CAST(EvaluationObjectiveRatingResult.SchoolYear as TEXT) AS SchoolYear
		,EvaluationObjectiveRatingResult.Rating,
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
	tpdm.EvaluationObjectiveRatingResult
	JOIN tpdm.Candidate
		ON
			EvaluationObjectiveRatingResult.PersonId = Candidate.PersonId AND
			EvaluationObjectiveRatingResult.SourceSystemDescriptorId = Candidate.SourceSystemDescriptorId
	JOIN tpdm.EvaluationObjective
		ON
			EvaluationObjectiveRatingResult.EducationOrganizationId = EvaluationObjective.EducationOrganizationId AND
			EvaluationObjectiveRatingResult.EvaluationObjectiveTitle = EvaluationObjective.EvaluationObjectiveTitle AND
			EvaluationObjectiveRatingResult.EvaluationPeriodDescriptorId = EvaluationObjective.EvaluationPeriodDescriptorId AND
			EvaluationObjectiveRatingResult.EvaluationTitle = EvaluationObjective.EvaluationTitle AND
			EvaluationObjectiveRatingResult.PerformanceEvaluationTitle = EvaluationObjective.PerformanceEvaluationTitle AND
			EvaluationObjectiveRatingResult.PerformanceEvaluationTypeDescriptorId = EvaluationObjective.PerformanceEvaluationTypeDescriptorId AND
			EvaluationObjectiveRatingResult.SchoolYear = EvaluationObjective.SchoolYear AND
			EvaluationObjectiveRatingResult.TermDescriptorId = EvaluationObjective.TermDescriptorId
	LEFT JOIN EOL
		ON
			EvaluationObjectiveRatingResult.EducationOrganizationId = EOL.EducationOrganizationId AND
			EvaluationObjectiveRatingResult.EvaluationObjectiveTitle = EOL.EvaluationObjectiveTitle AND
			EvaluationObjectiveRatingResult.EvaluationPeriodDescriptorId = EOL.EvaluationPeriodDescriptorId AND
			EvaluationObjectiveRatingResult.EvaluationTitle = EOL.EvaluationTitle AND
			EvaluationObjectiveRatingResult.PerformanceEvaluationTitle = EOL.PerformanceEvaluationTitle AND
			EvaluationObjectiveRatingResult.PerformanceEvaluationTypeDescriptorId = EOL.PerformanceEvaluationTypeDescriptorId AND
			EvaluationObjectiveRatingResult.SchoolYear = EOL.SchoolYear AND
			EvaluationObjectiveRatingResult.TermDescriptorId = EOL.TermDescriptorId

