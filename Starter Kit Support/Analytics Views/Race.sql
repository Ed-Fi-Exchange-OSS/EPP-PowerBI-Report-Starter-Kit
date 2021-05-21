SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[analytics].[core_Race]') IS NOT NULL
	DROP VIEW [analytics].[core_Race]

GO

CREATE VIEW [analytics].[core_Race] AS

---Race Dimension
SELECT rd.RaceDescriptorId
		,d.CodeValue 
	FROM [edfi].[RaceDescriptor] rd
	LEFT OUTER JOIN edfi.Descriptor d on d.DescriptorId = rd.RaceDescriptorId
	
GO