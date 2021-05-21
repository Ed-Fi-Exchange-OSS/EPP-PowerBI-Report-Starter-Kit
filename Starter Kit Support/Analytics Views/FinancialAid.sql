SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[analytics].[tpdm_FinancialAid]') IS NOT NULL
	DROP VIEW [analytics].[tpdm_FinancialAid]

GO

CREATE VIEW [analytics].[tpdm_FinancialAid] AS

---Financial Aid
SELECT a.CandidateIdentifier
		,a.BeginDate
		,a.EndDate
		,a.AidConditionDescription
		,d.CodeValue as AidType
		,a.AidAmount
		,a.PellGrantRecipient
  FROM tpdm.CandidateAid a
  LEFT OUTER JOIN edfi.Descriptor d on a.AidTypeDescriptorId = d.DescriptorId



GO


