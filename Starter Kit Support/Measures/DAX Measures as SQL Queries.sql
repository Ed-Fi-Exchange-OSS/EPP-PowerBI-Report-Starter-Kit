
SELECT COUNT(*) as '# of Candidates'
	FROM [analytics].[tpdm_TeacherCandidateMain]


SELECT COUNT(*) as '# of Program Completers (total)' 
	FROM [analytics].[tpdm_TeacherCandidateMain]
	WHERE ProgramComplete = 1


SELECT COUNT(*) as '# of Credentialed' 
	FROM [analytics].[tpdm_TeacherCandidateMain]
	WHERE IssuanceDate is NOT NULL


SELECT COUNT(DISTINCT(c.CandidateIdentifier)) as '# Grant Recipient'
	FROM [analytics].[tpdm_TeacherCandidateMain] c
	LEFT JOIN analytics.tpdm_FinancialAid f on c.CandidateIdentifier = f.CandidateIdentifier
	WHERE f.AidType IN ('Federal Scholarships', 'Institutional Grants', 
							'Institutional Scholarships', 'Other Federal Grants', 'Pell Grants',
							'State and Local Grants')


SELECT COUNT(DISTINCT(c.CandidateIdentifier)) as '# Loan Recipient'
	FROM [analytics].[tpdm_TeacherCandidateMain] c
	LEFT JOIN analytics.tpdm_FinancialAid f on c.CandidateIdentifier = f.CandidateIdentifier
	WHERE f.AidType IN ('Federal Subsidized Loans', 'Parent PLUS Loans')



SELECT A.[# Grant Recipient], B.[# of Candidates], 
	CAST(A.[# Grant Recipient] as float) / CAST(B.[# of Candidates] as float) as '% Grant Recipient' FROM 
	(SELECT COUNT(DISTINCT(c.CandidateIdentifier)) as '# Grant Recipient'
	FROM [analytics].[tpdm_TeacherCandidateMain] c
	LEFT JOIN analytics.tpdm_FinancialAid f on c.CandidateIdentifier = f.CandidateIdentifier 
	WHERE f.AidType IN ('Federal Scholarships', 'Institutional Grants', 
							'Institutional Scholarships', 'Other Federal Grants', 'Pell Grants',
							'State and Local Grants')) as A,
	(SELECT COUNT(*) as '# of Candidates'
	FROM [analytics].[tpdm_TeacherCandidateMain]) as B



SELECT A.[# Loan Recipient], B.[# of Candidates], 
	CAST(A.[# Loan Recipient] as float) / CAST(B.[# of Candidates] as float) as '% Grant Recipient' FROM 
	(SELECT COUNT(DISTINCT(c.CandidateIdentifier)) as '# Loan Recipient'
	FROM [analytics].[tpdm_TeacherCandidateMain] c
	LEFT JOIN analytics.tpdm_FinancialAid f on c.CandidateIdentifier = f.CandidateIdentifier 
	WHERE f.AidType IN ('Federal Subsidized Loans', 'Parent PLUS Loans')) as A,
	(SELECT COUNT(*) as '# of Candidates'
	FROM [analytics].[tpdm_TeacherCandidateMain]) as B



SELECT A.[# of Program Completers (total)], B.[# of Candidates], 
	CAST(A.[# of Program Completers (total)] as float) / CAST(B.[# of Candidates] as float) as '% Program Completers' FROM
	(SELECT COUNT(*) as '# of Program Completers (total)' 
	FROM [analytics].[tpdm_TeacherCandidateMain]
	WHERE ProgramComplete = 1) as A,
	(SELECT COUNT(*) as '# of Candidates'
	FROM [analytics].[tpdm_TeacherCandidateMain]) as B


	
SELECT A.[# Credentialed (total)], B.[# of Candidates], 
	CAST(A.[# Credentialed (total)] as float) / CAST(B.[# of Candidates] as float) as '% Program Completers' FROM
	(SELECT COUNT(*) as '# Credentialed (total)' 
	FROM [analytics].[tpdm_TeacherCandidateMain]
	WHERE IssuanceDate is NOT NULL) as A,
	(SELECT COUNT(*) as '# of Candidates'
	FROM [analytics].[tpdm_TeacherCandidateMain]) as B
