* @ValidationCode : Mjo2NDM3Nzc2MzE6Q3AxMjUyOjE2ODE4ODQyNzMxMTU6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Apr 2023 11:34:33
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.VAL.MVMT.TYPE
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.MVMT.TYPE
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check if the value selected is
*                    RECEIVED BY VAULT then throw an error
*Linked With       : COLLATERAL,DOC.RECEPTION
*In  Parameter     :
*Out Parameter     :
*Files  Used       : COLLATERAL                           As        I  Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 20/05/2010    Shiva Prasad Y     ODR-2009-10-0310 B.180C      Initial Creation
* 04/05/2011    Kavitha            PACS00054322 B.180C          Bug Fix
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB FIND.MULTI.LOCAL.REF
*    IF COMI NE "Received by Vault" THEN
*PACS00054322-S
    IF COMI NE "VAULT" THEN
*PACS00054322 -E
        ETEXT = 'CO-RECV.BY.VALUT'
        CALL STORE.END.ERROR
        R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.LOC.STATUS.POS> = ''
        RETURN
    END
    R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.LOC.STATUS.POS> = 'VAULT'

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'COLLATERAL'
    FLD.ARRAY  = 'L.CO.LOC.STATUS':@VM:'L.CO.SEC.DOC':@VM:'L.CO.MVMT.TYPE'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CO.LOC.STATUS.POS  = FLD.POS<1,1>
    LOC.L.CO.SEC.DOC.POS     = FLD.POS<1,2>
    LOC.L.CO.MVMT.TYPE.POS   = FLD.POS<1,3>

RETURN
*---------------------------------------------------------------------------------------------------------------------------
END
