﻿-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

CREATE OR REPLACE VIEW analytics.rls_StudentDataAuthorization
AS
	SELECT
		Student.StudentUniqueId as StudentKey,
		CAST(Section.SchoolId AS VARCHAR) as SchoolKey,
		CAST(Section.Id as VARCHAR(50)) as SectionId,
		StudentSectionAssociation.BeginDate,
		StudentSectionAssociation.EndDate,
		to_char(StudentSectionAssociation.BeginDate, 'yyyymmdd') as BeginDateKey,
		to_char(StudentSectionAssociation.EndDate, 'yyyymmdd') as EndDateKey
	FROM
		edfi.Student
	INNER JOIN
		edfi.StudentSectionAssociation ON
			Student.StudentUSI = StudentSectionAssociation.StudentUSI
	INNER JOIN
		edfi.Section ON
			StudentSectionAssociation.LocalCourseCode = Section.LocalCourseCode
		AND StudentSectionAssociation.SchoolId = Section.SchoolId
		AND StudentSectionAssociation.SchoolYear = Section.SchoolYear
		AND StudentSectionAssociation.SectionIdentifier = Section.SectionIdentifier
		AND StudentSectionAssociation.SessionName = Section.SessionName
