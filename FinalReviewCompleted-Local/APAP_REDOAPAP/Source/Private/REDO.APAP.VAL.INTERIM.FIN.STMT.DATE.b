* @ValidationCode : MjotMTEyMDM0NjQ3MjpDcDEyNTI6MTY4MDc2Mjk1MjM4MzpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 12:05:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.VAL.INTERIM.FIN.STMT.DATE
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.INTERIM.FIN.STMT.DATE
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check if the Financial
*                    Information Documents provided are "Interim Financial Statements", if YES then make
*                    the field Interim Financial Statement Date mandatory and also check the Interim
*                    Financial Statement Date is not greater than TODAY
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
* Date                  who                   Reference              
* 06-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION VM TO @VM
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
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

    IF R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.FIN.DOCS> EQ "INTER" AND NOT(COMI) THEN
        ETEXT = 'CO-MANDATORY.I.FIN.STMT.DATE'
        CALL STORE.END.ERROR
    END

    IF R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.FIN.DOCS> EQ "AUDIT" OR R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.FIN.DOCS> EQ "" AND COMI THEN
        ETEXT = 'CO-NO.I.FIN.STMT.DATE'
        CALL STORE.END.ERROR
    END

    IF COMI GT TODAY THEN
        ETEXT = 'CO-I.FIN.STMT.DATE.GT.TODAY'
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'COLLATERAL'
    FLD.ARRAY  = 'L.CO.FIN.DOCS':@VM:'L.CO.I.FIN.DATE'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CO.FIN.DOCS      = FLD.POS<1,1>
    LOC.L.CO.I.FIN.DATE    = FLD.POS<1,2>

RETURN
*---------------------------------------------------------------------------------------------------------------------------
END
