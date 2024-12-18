-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

CREATE OR REPLACE VIEW analytics.epp_SexDescriptorDim AS

SELECT CAST(SexDescriptor.SexDescriptorId AS VARCHAR) SexDescriptorKey
    ,Descriptor.CodeValue
    ,Descriptor.LastModifiedDate
FROM edfi.SexDescriptor
INNER JOIN edfi.Descriptor
    ON Descriptor.DescriptorId = SexDescriptor.SexDescriptorId;
