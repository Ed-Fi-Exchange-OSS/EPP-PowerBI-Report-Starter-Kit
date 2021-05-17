USE [EdFi_Ods_Populated_Template3]
GO

/****** Object:  View [analytics].[tpdm_TeacherCandidateMain]    Script Date: 12/21/2020 12:47:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[analytics].[tpdm_TeacherCandidateMain]') IS NOT NULL 
	DROP VIEW [analytics].[tpdm_TeacherCandidateMain]

GO


CREATE VIEW [analytics].[tpdm_TeacherCandidateMain] AS

	SELECT tc.TeacherCandidateIdentifier
		,tc.FirstName
		,tc.LastSurname
		,tc.SexDescriptorId
		,r.RaceDescriptorId
		,tc.HispanicLatinoEthnicity
		,tc.EconomicDisadvantaged
		,c.SchoolYear as Cohort
		,tc.ProgramComplete
		,tc.StudentUSI
		,tpp.ProgramName
		,tpp.BeginDate
		,tpp.EducationOrganizationId
		,tc.PersonId
		,cred.Credentialed
	FROM [tpdm].[TeacherCandidate] tc
	JOIN tpdm.TeacherCandidateTeacherPreparationProviderProgramAssociation tpp on tpp.TeacherCandidateIdentifier = tc.TeacherCandidateIdentifier
	LEFT OUTER JOIN dbo.[tpdm.tcrace] r on tc.TeacherCandidateIdentifier = r.TeacherCandidateIdentifier
	LEFT OUTER JOIN edfi.Descriptor rd on r.RaceDescriptorId = rd.DescriptorId
	LEFT OUTER JOIN tpdm.TeacherCandidateCohortYear c on tc.TeacherCandidateIdentifier = c.TeacherCandidateIdentifier
	LEFT OUTER JOIN dbo.Credentialed cred on tc.TeacherCandidateIdentifier = cred.TeacherCandidateIdentifier
GO


