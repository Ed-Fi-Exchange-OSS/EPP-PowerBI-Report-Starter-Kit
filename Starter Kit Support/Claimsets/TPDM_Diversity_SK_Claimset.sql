USE EdFi_Security
GO
  
DECLARE @claimSetName nvarchar(255)
DECLARE @resourceClaimNames table (resourceClaimName nvarchar(255))
DECLARE @claimSetId int
 
SET @claimSetName = 'TPDM Diversity SK'

insert @resourceClaimNames(resourceClaimName) values
	('http://ed-fi.org/ods/identity/claims/tpdm/candidate'),
	('http://ed-fi.org/ods/identity/claims/person'),
	('http://ed-fi.org/ods/identity/claims/student'),
	('http://ed-fi.org/ods/identity/claims/studentSchoolAssociation'),
	('http://ed-fi.org/ods/identity/claims/credential'),
	('http://ed-fi.org/ods/identity/claims/domains/tpdm/candidatePreparation'),
	('http://ed-fi.org/ods/identity/claims/domains/educationOrganizations')

--Create Claimset
INSERT INTO ClaimSets (ClaimSetName, Application_ApplicationId) VALUES(@claimSetName,1)
SELECT @claimSetId = ClaimSetId FROM ClaimSets WHERE ClaimSetName = @claimSetName
--Create CRUD action claims for all ClaimNames in @resourceClaimNames
INSERT INTO ClaimSetResourceClaims (Action_ActionId,ClaimSet_ClaimSetId,ResourceClaim_ResourceClaimId)
SELECT act.ActionId, @claimSetId, ResourceClaimId 
	FROM ResourceClaims RC
	JOIN @resourceClaimNames RN ON RC.ClaimName = RN.resourceClaimName
	CROSS JOIN Actions act
--Create R action claim for systemDescriptors
INSERT INTO ClaimSetResourceClaims (Action_ActionId,ClaimSet_ClaimSetId,ResourceClaim_ResourceClaimId)
SELECT (SELECT ActionId FROM Actions WHERE ActionName = 'read'), @claimSetId, ResourceClaimId 
FROM ResourceClaims RC
WHERE RC.ResourceName = 'systemDescriptors'