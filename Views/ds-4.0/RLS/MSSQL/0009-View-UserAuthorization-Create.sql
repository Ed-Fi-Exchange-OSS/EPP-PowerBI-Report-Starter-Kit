﻿-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.
IF OBJECT_ID('analytics.rls_UserAuthorization') IS NOT NULL 
	DROP VIEW analytics.rls_UserAuthorization

GO
CREATE VIEW analytics.rls_UserAuthorization
AS
WITH staffToScopeMap
AS (
	SELECT Staff.StaffUniqueId
		,Staff.StaffUSI
		,DescriptorConstant.ConstantName AS UserScope
		,StaffEducationOrganizationAssignmentAssociation.EducationOrganizationId
	FROM edfi.Staff
	INNER JOIN 
		edfi.StaffEducationOrganizationAssignmentAssociation
		ON Staff.StaffUSI = StaffEducationOrganizationAssignmentAssociation.StaffUSI
	INNER JOIN 
		analytics_config.DescriptorMap
		ON StaffEducationOrganizationAssignmentAssociation.StaffClassificationDescriptorId = DescriptorMap.DescriptorId
	INNER JOIN 
		analytics_config.DescriptorConstant
		ON DescriptorConstant.DescriptorConstantId = DescriptorMap.DescriptorConstantId
	WHERE
		-- Only current associations
		StaffEducationOrganizationAssignmentAssociation.EndDate IS NULL
		AND DescriptorConstant.ConstantName IN (
			'AuthorizationScope.District'
			,'AuthorizationScope.School'
			,'AuthorizationScope.Section'
			)
	)
SELECT DISTINCT staffToScopeMap.StaffUniqueId AS UserKey
	,staffToScopeMap.UserScope
	,'ALL' AS StudentPermission
	,CASE staffToScopeMap.UserScope
		WHEN 'AuthorizationScope.District'
			THEN 'ALL'
		WHEN 'AuthorizationScope.School'
			THEN 'ALL'
		ELSE CAST(Section.Id AS VARCHAR(50))
		END AS SectionPermission
	,CASE staffToScopeMap.UserScope
		WHEN 'AuthorizationScope.District'
			THEN 'ALL'
		WHEN 'AuthorizationScope.School'
			THEN 'ALL'
		ELSE COALESCE(CONCAT (
			CAST(Section.SchoolId AS NVARCHAR)
			,'-'
			,Section.LocalCourseCode
			,'-'
			,CAST(Section.SchoolYear AS NVARCHAR)
			,'-'
			,Section.SectionIdentifier
			,'-'
			,Section.SessionName
			), '')
		END AS SectionKeyPermission
	,CASE staffToScopeMap.UserScope
		WHEN 'AuthorizationScope.District'
			THEN 'ALL'
		ELSE CAST(staffToScopeMap.EducationOrganizationId AS VARCHAR)
		END AS SchoolPermission,
    CASE staffToScopeMap.UserScope
        WHEN 'AuthorizationScope.District'
            THEN CAST(staffToScopeMap.EducationOrganizationId AS VARCHAR)
		ELSE ''
        END AS DistrictId
FROM staffToScopeMap
LEFT OUTER JOIN 
	edfi.StaffSectionAssociation
	ON staffToScopeMap.StaffUSI = StaffSectionAssociation.StaffUSI
		AND staffToScopeMap.EducationOrganizationId = StaffSectionAssociation.SchoolId
LEFT OUTER JOIN 
	edfi.Section
	ON StaffSectionAssociation.LocalCourseCode = Section.LocalCourseCode
		AND StaffSectionAssociation.SchoolId = Section.SchoolId
		AND StaffSectionAssociation.SchoolYear = Section.SchoolYear
		AND StaffSectionAssociation.SectionIdentifier = Section.SectionIdentifier
		AND StaffSectionAssociation.SessionName = Section.SessionName
WHERE (
		staffToScopeMap.UserScope IN (
			'AuthorizationScope.District'
			,'AuthorizationScope.School'
			)
		)
	OR (StaffSectionAssociation.Id IS NOT NULL
		AND (
			StaffSectionAssociation.EndDate IS NULL 
				OR StaffSectionAssociation.EndDate >= GETDATE()
			)
	);