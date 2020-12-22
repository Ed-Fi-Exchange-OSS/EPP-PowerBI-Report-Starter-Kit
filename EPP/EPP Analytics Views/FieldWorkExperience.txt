USE [EdFi_Ods_Populated_Template3]
GO

/****** Object:  View [analytics].[FieldWorkExperience]    Script Date: 12/21/2020 1:04:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[analytics].[FieldWorkExperience]') IS NOT NULL
	DROP VIEW [analytics].[FieldWorkExperience]

GO

CREATE VIEW [analytics].[FieldWorkExperience] AS

---Fielwork Experience
SELECT tc.TeacherCandidateIdentifier
		,f.BeginDate
		,f.EndDate
		,d.CodeValue AS 'Fieldwork Type'
		,f.HoursCompleted
		,eo.NameOfInstitution
FROM [EdFi_Ods_Populated_Template3].[tpdm].[FieldworkExperience] f
JOIN tpdm.TeacherCandidate tc on f.StudentUSI = tc.StudentUSI
JOIN edfi.Descriptor d on f.FieldworkTypeDescriptorId = d.DescriptorId
JOIN tpdm.FieldworkExperienceSchool fs on f.FieldworkIdentifier = fs.FieldworkIdentifier
JOIN edfi.EducationOrganization eo on fs.SchoolId = eo.EducationOrganizationId



GO


