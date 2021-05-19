USE [EdFi_Ods_Populated_Template3]
GO

/****** Object:  View [analytics].[tpdm_FinancialAid]    Script Date: 12/21/2020 1:04:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[analytics].[tpdm_FinancialAid]') IS NOT NULL
	DROP VIEW [analytics].[tpdm_FinancialAid]

GO

CREATE VIEW [analytics].[tpdm_FinancialAid] AS

---Financial Aid
SELECT a.TeacherCandidateIdentifier
		,a.BeginDate
		,a.EndDate
		,a.AidConditionDescription
		,d.CodeValue as AidType
		,a.AidAmount
		,a.PellGrantRecipient
FROM tpdm.TeacherCandidateAid a
LEFT OUTER JOIN edfi.Descriptor d on a.AidTypeDescriptorId = d.DescriptorId



GO


