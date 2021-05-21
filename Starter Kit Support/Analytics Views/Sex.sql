SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[analytics].[core_Sex]') IS NOT NULL
	DROP VIEW [analytics].[core_Sex]

GO

CREATE VIEW [analytics].[core_Sex] AS

---Sex
SELECT S.SexDescriptorId
		, D.CodeValue 
	FROM edfi.SexDescriptor S
	LEFT JOIN edfi.Descriptor d on d.DescriptorId = S.SexDescriptorId
	
GO