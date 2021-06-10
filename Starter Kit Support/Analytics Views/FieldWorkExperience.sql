-- SPDX-License-Identifier: Apache-2.0-- Licensed to the Ed-Fi Alliance under one or more agreements.-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.-- See the LICENSE and NOTICES files in the project root for more information.
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[analytics].[tpdm_FieldWorkExperience]') IS NOT NULL
	DROP VIEW [analytics].[tpdm_FieldWorkExperience]

GO

CREATE VIEW [analytics].[tpdm_FieldWorkExperience] AS

---Fielwork Experience
SELECT tc.CandidateIdentifier
		,f.BeginDate
		,f.EndDate
		,d.CodeValue AS 'Fieldwork Type'
		,f.HoursCompleted
		,eo.NameOfInstitution
FROM [tpdm].[FieldworkExperience] f
JOIN edfi.Student s on s.StudentUSI = f.StudentUSI
JOIN tpdm.Candidate tc on tc.PersonId = s.PersonId
JOIN edfi.Descriptor d on f.FieldworkTypeDescriptorId = d.DescriptorId
JOIN edfi.EducationOrganization eo on f.SchoolId = eo.EducationOrganizationId


GO


