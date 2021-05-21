SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[analytics].[tpdm_TeacherCandidateMain]') IS NOT NULL 
	DROP VIEW [analytics].[tpdm_TeacherCandidateMain]

GO


CREATE VIEW [analytics].[tpdm_TeacherCandidateMain] AS

SELECT c.CandidateIdentifier 
		,c.FirstName 
		,c.LastSurname 
		,c.SexDescriptorId 
		,rd.RaceDescriptorId 
		,c.HispanicLatinoEthnicity 
		,c.EconomicDisadvantaged 
		,ccy.SchoolYear as Cohort 
		,c.ProgramComplete 
		,s.StudentUSI 
		,epp.ProgramName 
		,epp.BeginDate 
		,epp.EducationOrganizationId 
		,c.PersonId 
		,CASE WHEN SUM(CASE WHEN cred.CredentialIdentifier IS NOT NULL THEN 1 ELSE 0 END) > 0 THEN MIN(cred.IssuanceDate) END IssuanceDate
	FROM tpdm.Candidate c 
	JOIN tpdm.CandidateEducatorPreparationProgramAssociation epp on epp.CandidateIdentifier = c.CandidateIdentifier 
	LEFT JOIN tpdm.CandidateRace rd on rd.CandidateIdentifier = c.CandidateIdentifier 
	LEFT JOIN edfi.Descriptor d on d.DescriptorId = rd.RaceDescriptorId 
	LEFT JOIN edfi.Student s on s.PersonId = c.PersonId 
	LEFT JOIN tpdm.CandidateCohortYear ccy on ccy.CandidateIdentifier = c.CandidateIdentifier
	LEFT JOIN tpdm.CredentialExtension ce on ce.PersonId = c.PersonId 
	LEFT JOIN edfi.Credential cred on cred.CredentialIdentifier = ce.CredentialIdentifier
	GROUP BY c.CandidateIdentifier 
		,c.FirstName 
		,c.LastSurname 
		,c.SexDescriptorId 
		,rd.RaceDescriptorId 
		,c.HispanicLatinoEthnicity 
		,c.EconomicDisadvantaged 
		,ccy.SchoolYear
		,c.ProgramComplete 
		,s.StudentUSI 
		,epp.ProgramName 
		,epp.BeginDate 
		,epp.EducationOrganizationId 
		,c.PersonId


