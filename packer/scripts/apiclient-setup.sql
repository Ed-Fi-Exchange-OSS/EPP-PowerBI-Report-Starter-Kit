-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

DECLARE @VendorName nvarchar(150) = 'StarterKit'
DECLARE @NamespacePrefix0 nvarchar (255) = 'uri://ed-fi.org'
DECLARE @NamespacePrefix1 nvarchar (255) = 'uri://gbisd.edu'
DECLARE @NamespacePrefix2 nvarchar (255) = 'uri://lisd.edu'
DECLARE @NamespacePrefix3 nvarchar (255) = 'uri://bcisd.edu'
DECLARE @UserFullName varchar(150) = 'StarterKit User'
DECLARE @UserEmailAddress varchar(150) = 'postman@sk.ed-fi.org'
DECLARE @ApplicationName nvarchar(255) = 'StarterKit Application'
DECLARE @ClaimSetName nvarchar(255) = 'Ed-Fi Sandbox'
DECLARE @ApiClientName nvarchar(50) = 'StarterKit Api Client'
DECLARE @IsPopulatedSandbox bit = 1
DECLARE @UseSandbox bit = 0
DECLARE @Key nvarchar(50) = 'starterKit'
DECLARE @Secret nvarchar(100) = 'starterKitSecret'

-- Ensure Vendor exists
DECLARE @VendorId int
SELECT @VendorId = VendorId FROM [dbo].[Vendors] WHERE VendorName = @VendorName

IF(@VendorId IS NULL)
BEGIN
    INSERT INTO [dbo].[Vendors] (VendorName)
    VALUES (@VendorName)

    SET @VendorId = SCOPE_IDENTITY()
END

-- Ensure correct namespace prefixes are set up
DELETE FROM [dbo].[VendorNamespacePrefixes] WHERE Vendor_VendorId = @VendorId
INSERT INTO [dbo].[VendorNamespacePrefixes] (Vendor_VendorId, NamespacePrefix)
VALUES
    (@VendorId, @NamespacePrefix0),
    (@VendorId, @NamespacePrefix1),
    (@VendorId, @NamespacePrefix2),
    (@VendorId, @NamespacePrefix3)

-- Ensure User exists for test Vendor
DECLARE @UserId int

SELECT @UserId = UserId FROM [dbo].[Users] WHERE FullName = @UserFullName AND Vendor_VendorId = @VendorId

IF(@UserId IS NULL)
BEGIN
    INSERT INTO [dbo].[Users] (Email, FullName, Vendor_VendorId)
    VALUES (@UserEmailAddress, @UserFullName, @VendorId)

    SET @UserId = SCOPE_IDENTITY()
END
ELSE
BEGIN
    UPDATE [dbo].[Users] SET Email = @UserEmailAddress WHERE UserId = @UserId
END

-- Ensure Application exists
DECLARE @ApplicationId int
SELECT @ApplicationId = ApplicationId FROM [dbo].[Applications] WHERE ApplicationName = @ApplicationName AND Vendor_VendorId = @VendorId

IF (@ApplicationId IS NULL)
BEGIN
    INSERT INTO [dbo].[Applications] (ApplicationName, Vendor_VendorId, ClaimSetName)
    VALUES (@ApplicationName, @VendorId, @ClaimSetName)

    SET @ApplicationId = SCOPE_IDENTITY()
END
ELSE
BEGIN
    UPDATE [dbo].[Applications] SET ClaimSetName = @ClaimSetName WHERE ApplicationId = @ApplicationId
END

-- Ensure ApiClient exists
DECLARE @ApiClientId int
SELECT @ApiClientId = ApiClientId FROM [dbo].[ApiClients] WHERE Application_ApplicationId = @ApplicationId AND [Name] = @ApiClientName

IF(@ApiClientId IS NULL)
BEGIN
    INSERT INTO [dbo].[ApiClients] ([Key], [Secret], [Name], IsApproved, UseSandbox, SandboxType, Application_ApplicationId, User_UserId, SecretIsHashed)
    VALUES (@Key, @Secret, @ApiClientName, 1, @UseSandbox, @IsPopulatedSandbox, @ApplicationId, @UserId, 0)

    SET @ApiClientId = SCOPE_IDENTITY()
END
ELSE
BEGIN
    UPDATE [dbo].[ApiClients] SET [Key] = @Key, [Secret] = @Secret, UseSandbox = @UseSandbox, SandboxType = @IsPopulatedSandbox, User_UserId = @UserId, SecretIsHashed = 0 WHERE ApiClientId = @ApiClientId
END

DECLARE @EducationOrganizationId1 int = 255901
DECLARE @ApplicationEducationOrganizationId1 int
DECLARE @EducationOrganizationId2 int = 255902
DECLARE @ApplicationEducationOrganizationId2 int
DECLARE @EducationOrganizationId3 int = 255903
DECLARE @ApplicationEducationOrganizationId3 int

BEGIN
    -- Clear all education organization links for the selected application
    DELETE acaeo
    FROM dbo.ApiClientApplicationEducationOrganizations acaeo
    INNER JOIN dbo.ApplicationEducationOrganizations aeo
    ON acaeo.ApplicationEducationOrganization_ApplicationEducationOrganizationId = aeo.ApplicationEducationOrganizationId
    WHERE aeo.Application_ApplicationId = @ApplicationId
    DELETE FROM [dbo].[ApplicationEducationOrganizations] WHERE Application_ApplicationId = @ApplicationId

    -- Ensure correct education organizations are set up
    INSERT INTO [dbo].[ApplicationEducationOrganizations] (EducationOrganizationId, Application_ApplicationId)
    VALUES (@EducationOrganizationId1, @ApplicationId)
    SELECT @ApplicationEducationOrganizationId1 = SCOPE_IDENTITY()

    INSERT INTO [dbo].[ApplicationEducationOrganizations] (EducationOrganizationId, Application_ApplicationId)
    VALUES (@EducationOrganizationId2, @ApplicationId)
    SELECT @ApplicationEducationOrganizationId2 = SCOPE_IDENTITY()

    INSERT INTO [dbo].[ApplicationEducationOrganizations] (EducationOrganizationId, Application_ApplicationId)
    VALUES (@EducationOrganizationId3, @ApplicationId)
    SELECT @ApplicationEducationOrganizationId3 = SCOPE_IDENTITY()

    INSERT INTO [dbo].[ApiClientApplicationEducationOrganizations] (ApplicationEducationOrganization_ApplicationEducationOrganizationId, ApiClient_ApiClientId)
    VALUES
        (@ApplicationEducationOrganizationId1, @ApiClientId),
        (@ApplicationEducationOrganizationId2, @ApiClientId),
        (@ApplicationEducationOrganizationId3, @ApiClientId)
END
