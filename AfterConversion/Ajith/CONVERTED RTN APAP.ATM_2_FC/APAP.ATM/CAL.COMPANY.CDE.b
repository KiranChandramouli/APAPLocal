* @ValidationCode : MjoxMDg1MjgwMzk1OkNwMTI1MjoxNjgyMDcwNDIwNjI2OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:17:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   IF STATEMENT MODIFIED
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE CAL.COMPANY.CDE(ATM.ID,COMPANY.CDE)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATM.BRANCH
    $INSERT I_F.INTERCO.PARAMETER
    $INSERT I_F.ACCOUNT
*
*Start of modification for PACS00054730------------------
    ATM.BRANCH.ID = ATM.ID
*End of modification------------------------------------
* COMM ANITHA KCB    ATM.BRANCH.ID=TRIM(ATM.BRANCH.IDM"0","L")
    ATM.BRANCH.ID=TRIM(ATM.BRANCH.ID,"0","L")       ;*ADDED ANITHA KCB
*
    FN.ATM.ISO.BRANCH = 'F.ATM.BRANCH'
    CALL OPF(FN.ATM.ISO.BRANCH,F.ATM.ISO.BRANCH)
*

    CALL F.READ(FN.ATM.ISO.BRANCH,ATM.BRANCH.ID,R.ATM.BRANCH,F.ATM.ISO.BRANCH,ER.ATM.BRANCH)
    COMPANY.CDE = R.ATM.BRANCH<ATM.BR.COMPANY.CODE>

    IF NOT(COMPANY.CDE) THEN

*        CALL F.READ(FN.ATM.ISO.BRANCH,'HBDF01',R.ATM.BRANCH,F.ATM.ISO.BRANCH,ER.ATM.BRANCH)
*       COMPANY.CDE = R.ATM.BRANCH<ATM.BR.COMPANY.CODE>
*** Modified on 22-Nov-2005 for HNB
        ACCT.NO = ATM.ID[9,10]
        CALL GET.ACCT.BRANCH(ACCT.NO,Y.ACCT.BR.MNE,Y.ACCT.COMP.CDE)
        COMPANY.CDE = Y.ACCT.COMP.CDE
    END

*/TEMP
** commented by latha on 26/05/2005
*    IF NOT(COMPANY.CDE) THEN COMPANY.CDE = "NP0010001"

    IF NOT(COMPANY.CDE) THEN
        COMPANY.CDE = ID.COMPANY
    END ;*R22 AUTO CODE CONVERSION
** end

RETURN
