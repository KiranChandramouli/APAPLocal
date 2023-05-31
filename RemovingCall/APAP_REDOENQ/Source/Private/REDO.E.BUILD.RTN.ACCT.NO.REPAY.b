* @ValidationCode : MjotMjA2NDE0ODQzODpDcDEyNTI6MTY4NDg1MTk2OTcyMjpJVFNTOi0xOi0xOjE5OToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 19:56:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 199
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BUILD.RTN.ACCT.NO.REPAY(ENQ.DATA)
*---------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Bharath G
*Program Name      : REDO.E.BUILD.RTN.ACCT.NO
*Date              : 09/02/2011
*---------------------------------------------------------------------------
*Description       : This routine is a build routine to display the account numbers of the particular CUSTOMER.
*Linked With       :
*Linked File       :
*---------------------------------------------------------------------------
* MODIFICATION HISTORY:
* ---------------------
* DATE            RESOURCE             REFERENCE             DESCRIPTION
* 11.05.2011      Bharath G            PACS00080544          Initial Creation
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 10-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*---------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : N/A
* Called By : N/A
*---------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.ARRANGEMENT
    $USING APAP.TAM

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    R.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    Y.AA.ID = R.NEW(FT.DEBIT.ACCT.NO)

    IF Y.AA.ID[1,2] NE 'AA' THEN
        IN.ACC.ID = Y.AA.ID
        IN.ARR.ID = ''
        OUT.ID = ''
        ERR.TEXT = ''
        CALL APAP.TAM.redoConvertAccount(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT);*R22 Manual Conversion
        Y.AA.ID = OUT.ID
    END

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
    IF R.AA.ARRANGEMENT THEN
        Y.CUST.ID = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    END
    ENQ.DATA<2,1> = 'CUSTOMER'
    ENQ.DATA<3,1> = "EQ"
    ENQ.DATA<4,1> = Y.CUST.ID

RETURN
END
