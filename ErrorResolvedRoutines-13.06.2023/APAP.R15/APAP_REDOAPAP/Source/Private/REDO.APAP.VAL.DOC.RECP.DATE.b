* @ValidationCode : MjotMTQ1NDEyODExMTpDcDEyNTI6MTY4NDgzNjA1NDYwOTpJVFNTOi0xOi0xOi0yMjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -22
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.VAL.DOC.RECP.DATE
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.DOC.RECP.DATE
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check if the field Documents of
*                    endorsed policy has a value, if YES then make the field Reception Date mandatory and
*                    also check the reception date is not greater than TODAY
*Linked With       : COLLATERAL,DOC.RECEPTION
*In  Parameter     :
*Out Parameter     :
*Files  Used       : COLLATERAL             As          I Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 21/05/2010    Shiva Prasad Y     ODR-2009-10-0310 B.180C      Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*
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

    IF NOT(R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.DOCS.POL>) THEN
        RETURN
    END

    IF NOT(COMI) THEN
        ETEXT = 'CO-MANDATORY.DOC.RECP.DATE'
        CALL STORE.END.ERROR
    END

    IF COMI GT TODAY THEN
        ETEXT = 'CO-DOC.RECP.DATE.GT.TODAY'
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'COLLATERAL'
    FLD.ARRAY  = 'L.CO.DOCS.POL':@VM:'L.CO.RECP.DATE'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CO.DOCS.POL      = FLD.POS<1,1>
    LOC.L.CO.RECP.DATE     = FLD.POS<1,2>
RETURN
*---------------------------------------------------------------------------------------------------------------------------
END
