* @ValidationCode : Mjo0MzQzMDgxNzE6Q3AxMjUyOjE2ODQ4MzYwNTQ3MzM6SVRTUzotMTotMTotMjQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -24
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.VAL.LOC.STATUS
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.LOC.STATUS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check if the Movement Type is
*                    "RECEIVED BY VAULT", if YES then assign the value "In Valut" to the field L.CO.LOC.STATUS
*Linked With       : COLLATERAL,DOC.RECEPTION
*In  Parameter     :
*Out Parameter     :
*Files  Used       : COLLATERAL             As          I Mode
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
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    GOSUB FIND.MULTI.LOCAL.REF
    Y.LOC.STATUS=R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.LOC.STATUS,AS>
*PACS00054322-S
    IF R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.MVMT.TYPE,AS> EQ "VAULT" THEN
        COMI = 'VAULT'
    END
*PACS00054322-E

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'COLLATERAL'
    FLD.ARRAY  = 'L.CO.MVMT.TYPE':@VM:'L.CO.LOC.STATUS'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CO.MVMT.TYPE        = FLD.POS<1,1>
    LOC.L.CO.LOC.STATUS       = FLD.POS<1,2>

RETURN
*---------------------------------------------------------------------------------------------------------------------------
END
