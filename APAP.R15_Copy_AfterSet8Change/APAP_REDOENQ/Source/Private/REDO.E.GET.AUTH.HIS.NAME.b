* @ValidationCode : MjotOTY0ODc0MDE3OkNwMTI1MjoxNjgyMDc4ODcxNTg0OklUU1M6LTE6LTE6Mzg1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:37:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 385
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.GET.AUTH.HIS.NAME
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.GET.AUTH.HIS.NAME
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the value
*                    from O.DATA delimited with stars and formats them according to the selection criteria
*                    and returns the value back to O.DATA
*Linked With       : Enquiry REDO.EXE.ACCT.OPEN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*    02 08 2012       GANESH R                 ODR-2010-03-0141           Initial Creation
*
* 18-APR-2023  	     Conversion tool             R22 Auto conversion       No changes
* 18-APR-2023      Harishvikram C                Manual R22 conversion      No changes
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON

**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    ACCT.ID = O.DATA
    O.DATA = ''
    FN.ACCOUNT$HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT$HIS  = ''
    CALL OPF(FN.ACCOUNT$HIS,F.ACCOUNT$HIS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    CALL F.READ(FN.ACCOUNT$HIS,ACCT.ID,R.ACCOUNT,F.ACCOUNT$HIS,ACCT.ERR)
    O.DATA = R.ACCOUNT<AC.AUTHORISER>
    IF NOT(O.DATA) THEN
        ACCT.LIVE.ID = FIELD(ACCT.ID,';',1)
        CALL F.READ(FN.ACCOUNT,ACCT.LIVE.ID,R.ACCOUNT,F.ACCOUNT,ACCT.LIVE.ERR)
        O.DATA = R.ACCOUNT<AC.AUTHORISER>
    END
RETURN
*-------------------------------------------------------------------------------------------------------
