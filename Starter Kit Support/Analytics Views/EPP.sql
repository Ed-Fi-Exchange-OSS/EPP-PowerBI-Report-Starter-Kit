-- SPDX-License-Identifier: Apache-2.0-- Licensed to the Ed-Fi Alliance under one or more agreements.-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.-- See the LICENSE and NOTICES files in the project root for more information.
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[analytics].[tpdm_EPP]') IS NOT NULL
	DROP VIEW [analytics].[tpdm_EPP]

GO

CREATE VIEW [analytics].[tpdm_EPP] AS

---EPP
SELECT eo.EducationOrganizationId
		,NameOfInstitution
FROM edfi.EducationOrganization eo
JOIN edfi.EducationOrganizationCategory eoc
	ON eo.EducationOrganizationId = eoc.EducationOrganizationId
JOIN edfi.Descriptor d
	ON eoc.EducationOrganizationCategoryDescriptorId = d.DescriptorId
WHERE d.CodeValue like '%Preparation Provider%'
GO


