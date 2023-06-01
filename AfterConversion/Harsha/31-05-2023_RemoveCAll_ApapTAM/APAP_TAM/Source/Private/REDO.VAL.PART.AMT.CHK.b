* @ValidationCode : MjotMzk5NzY0NzkyOkNwMTI1MjoxNjgxMTUxNjE4MTQ1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 00:03:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.PART.AMT.CHK

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
*    $INCLUDE TAM.BP I_REDO.V.PART.PYMT.RULE1.COMMON
    $INSERT I_System

* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU
* PROGRAM NAME : REDO.VAL.PART.AMT.CHK
*----------------------------------------------------------


* DESCRIPTION : This routine is a validation routine attached
* to AMOUNT.LOCAL.1 of TELLER,AA.PART.PYMNT & CREDIT.ACCOUNT.NO of FUNDS.TRANSFER,AA.PART.PYMT
* model bank version to do overpayment validations
* MODIFIED FOR : PACS00084115
*------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - New condition added
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

MAIN:

    GOSUB PROCESS
    GOSUB PGM.END

PROCESS:

    Y.COMI = COMI
    IF Y.COMI EQ '' THEN
        RETURN
    END ELSE
        IF APPLICATION EQ 'TELLER' THEN
            Y.PART.AMT = System.getVariable("CURRENT.PART.AMT")
            IF E EQ "EB-UNKNOWN.VARIABLE" THEN                  ;** R22 Auto Conversion - Start
                Y.PART.AMT = ""
            END                                               ;** R22 Auto Conversion - End
            R.NEW(TT.TE.VALUE.DATE.2) = TODAY
            IF Y.COMI LT Y.PART.AMT THEN
                AF = TT.TE.AMOUNT.LOCAL.1
                ETEXT = 'EB-REDO.LESS.PARTL.PYMT'
                CALL STORE.END.ERROR
            END
        END
        IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
            Y.PART.AMT = System.getVariable("CURRENT.PART.AMT")
            IF E EQ "EB-UNKNOWN.VARIABLE" THEN                       ;** R22 Auto Conversion - Start
                Y.PART.AMT = ""
            END                                                   ;** R22 Auto Conversion - End
            IF Y.COMI LT Y.PART.AMT THEN
                AF = FT.CREDIT.AMOUNT
                ETEXT = 'EB-REDO.LESS.PARTL.PYMT'
                CALL STORE.END.ERROR
            END
        END
    END

RETURN

PGM.END:

END
