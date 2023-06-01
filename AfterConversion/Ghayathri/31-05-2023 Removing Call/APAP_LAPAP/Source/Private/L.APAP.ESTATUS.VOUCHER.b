* @ValidationCode : MjoxMjgwMzI4OTM5OkNwMTI1MjoxNjgyMzMxMzIyMjcwOklUU1M6LTE6LTE6MjAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ESTATUS.VOUCHER
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.ENQUIRY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.VISA.STLMT.05TO37 ;*R22 Auto conversion - END

    FN.REDO.VISA.STLMT.05TO37 = "F.REDO.VISA.STLMT.05TO37"
    F.REDO.VISA.STLMT.05TO37 = ""
    CALL OPF(FN.REDO.VISA.STLMT.05TO37,F.REDO.VISA.STLMT.05TO37)

    Y.CARD.VALUE = O.DATA

    Y.CARD.ID = FIELD(Y.CARD.VALUE,".",1,1)

    Y.CARD.AUTH = FIELD(Y.CARD.VALUE,".",2,1)

    SELECT.STATEMENT = "SELECT F.REDO.VISA.STLMT.05TO37 WITH ACCOUNT.NUMBER EQ ":Y.CARD.ID:" AND AUTH.CODE EQ ":Y.CARD.AUTH

    Y.REDO.LOAN.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.TYPE.PRODUCT = ''
    CALL EB.READLIST(SELECT.STATEMENT,Y.REDO.LOAN.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    LOOP
        REMOVE Y.ENTY.ID FROM Y.REDO.LOAN.LIST SETTING POS
    WHILE Y.ENTY.ID:POS

        CALL F.READ(FN.REDO.VISA.STLMT.05TO37, Y.ENTY.ID, R.REDO.VISA.STLMT.05TO37,F.REDO.VISA.STLMT.05TO37, Y.ERR)

        IF R.REDO.VISA.STLMT.05TO37 THEN

            O.DATA = 'APLICADO'

            RETURN

        END
        ELSE

            O.DATA = 'PENDIENTE'

            RETURN

        END

    REPEAT

    O.DATA = 'PENDIENTE'


RETURN

END
