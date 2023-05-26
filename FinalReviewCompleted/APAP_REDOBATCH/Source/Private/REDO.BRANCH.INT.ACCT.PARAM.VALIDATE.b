* @ValidationCode : MjotMTUwOTEzNjY6Q3AxMjUyOjE2ODQ4NTQ0MDQ1OTM6SVRTUzotMTotMTo3MjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 72
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BRANCH.INT.ACCT.PARAM.VALIDATE
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*  This routine is .VALIDATE routine attached to below versions
*
*
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*-----------------------------------------------------------------------------
*   Date               who           Reference            Description
* 04-28-2011          Bharath G         N.45              INITIAL CREATION
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - F.READ TO CACHE.READ AND REMOVED F.COMPANY
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.BRANCH.INT.ACCT.PARAM

    IF V$FUNCTION EQ 'I' THEN
        GOSUB INIT
        GOSUB PROCESS
    END

RETURN
*-----------------------------------------------------------------------------
******
INIT:
******
*
    Y.CURRENCY = ''
    Y.ACCT.BRANCH.INT.ACCT = ''
    Y.CURRENT.CURRENCY = ''
    Y.CURRENT.INT.ACCT = ''

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    R.CMPNY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

RETURN
*-----------------------------------------------------------------------------
*******
PROCESS:
*******
    AF = BR.INT.ACCT.COMPANY
    CALL DUP

    AF = BR.INT.ACCT.CURRENCY
    CALL DUP

    Y.CURRENCY = R.NEW(BR.INT.ACCT.CURRENCY)
    Y.ACCT.BRANCH.INT.ACCT = R.NEW(BR.INT.ACCT.BRANCH.INT.ACCT)

    LOOP
        REMOVE Y.CURRENT.CURRENCY FROM Y.CURRENCY SETTING CURRENCY.POS
        REMOVE Y.CURRENT.INT.ACCT FROM Y.ACCT.BRANCH.INT.ACCT SETTING ACCT.POS
    WHILE Y.CURRENT.CURRENCY:CURRENCY.POS
        Y.CODE = RIGHT(Y.CURRENT.INT.ACCT,4)
        CALL CACHE.READ(FN.COMPANY, ID.NEW, R.CMPNY, CMPNY.ERR) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.COMPANY
        IF Y.CURRENT.CURRENCY NE Y.CURRENT.INT.ACCT[1,3] THEN
            AF = BR.INT.ACCT.BRANCH.INT.ACCT
            ETEXT = 'EB-CURRENCY.NE.INT.ACCT'
            CALL STORE.END.ERROR
            RETURN
        END

* IF R.CMPNY THEN
*     Y.SUB.DIV.CODE = R.CMPNY<EB.COM.SUB.DIVISION.CODE>
*     IF Y.SUB.DIV.CODE NE Y.CODE THEN
*         AF = BR.INT.ACCT.BRANCH.INT.ACCT
*         ETEXT = 'EB-ACCT.NOT.EQUAL.CMPNY'
*         CALL STORE.END.ERROR
*         RETURN
*    END
* END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
END
