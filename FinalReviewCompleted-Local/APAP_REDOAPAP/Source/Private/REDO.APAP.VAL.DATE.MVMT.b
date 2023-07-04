* @ValidationCode : MjotMTIwOTA2ODM3OTpDcDEyNTI6MTY4MTg4Mzc1Nzg5ODphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 11:25:57
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
SUBROUTINE REDO.APAP.VAL.DATE.MVMT
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.DATE.MVMT
*--------------------------------------------------------------------------------------------------------
*Description       : This routiene ia a validation routine. It is used to check if the Movement type is
*                    been given, if YES then make the field Date of Movement mandatory and also check
*                    for Date of Movement to be same as Reception Date
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



    IF R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.MVMT.TYPE> NE "VAULT" THEN
        RETURN
    END

    IF NOT(COMI) THEN
        ETEXT = 'CO-MANDATORY.DATE.MVMT'
        CALL STORE.END.ERROR
    END
*PACS00054322-S
    CURR.NO = R.NEW(COLL.CURR.NO)
    IF NOT(CURR.NO) THEN
        IF COMI NE R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.SRECP.DATE> THEN
            ETEXT = 'CO-DATE.NE.REC.DATE'
            CALL STORE.END.ERROR
        END

*PACS00054322-E

        RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
        APPL.ARRAY = 'COLLATERAL'
        FLD.ARRAY  = 'L.CO.MVMT.TYPE':@VM:'L.CO.SRECP.DATE':@VM:'L.CO.DATE.MVMT'
        FLD.POS    = ''
        CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
        LOC.L.CO.MVMT.TYPE    = FLD.POS<1,1>
        LOC.L.CO.SRECP.DATE   = FLD.POS<1,2>
        LOC.L.DATE.MVT = FLD.POS<1,3>

        RETURN
*---------------------------------------------------------------------------------------------------------------------------
    END
