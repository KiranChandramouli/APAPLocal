* @ValidationCode : Mjo3OTY1MTc4NjpDcDEyNTI6MTY4MTE1MTYxODQ1MTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
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
SUBROUTINE REDO.VAL.PART.DISBURSE.AMT
*-----------------------------------------------------------------------------
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : TAM
* Program Name : REDO.VAL.PART.DISBURSE.AMT
*---------------------------------------------------------

* Description : This subroutine is attached input routine in REDO.AA.PART.DISBURSE.FC,PART.DISB
*
*----------------------------------------------------------
*    Linked TO : Enquiry REDO.E.DESEMBOLSO
*----------------------------------------------------------
* Modification History:
*
* 13-MAR-2013  PACS00254302  Sivakumar K  CUSTOMER value populated from AA.ARRANGEMENT
* 18-MAR-2013  PACS00255148  Sivakumar K  Values populating either ARRANGEMENT/ACCOUNT given in ID.ARRANGEMENT field
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*----------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AA.PART.DISBURSE.FC
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    GOSUB GET.LINKED.ID
    GOSUB MAPPING.DETAILS

RETURN

GET.LINKED.ID:

*PACS00255148_S
    Y.ID = COMI
    CALL F.READ(FN.ACCOUNT,Y.ID,R.ACCOUNT,F.ACCOUNT,AC.ERR)
    IF R.ACCOUNT THEN
        Y.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
        COMI = Y.ID
    END
*PACS00255148-E

    CALL F.READ(FN.AA.ARRANGEMENT,Y.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
    IF R.AA.ARRANGEMENT THEN
        Y.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    END

RETURN

MAPPING.DETAILS:

    BALANCE.TO.CHECK = 'CURCOMMITMENT'
    REQUEST.TYPE<4> = 'ECB'
    START.DATE = ''
    END.DATE = '' ; SYSTEM.DATE = '' ; ERROR.MESSAGE = ''
    CALL AA.GET.PERIOD.BALANCES(Y.ID, BALANCE.TO.CHECK, REQUEST.TYPE, START.DATE, END.DATE, SYSTEM.DATE, BAL.DETAILS, ERROR.MESSAGE)
    Y.REMAIN.AMT = ABS(BAL.DETAILS<4>)

    R.NEW(REDO.PDIS.PARTIAL.OS.AMT) = Y.REMAIN.AMT
    R.NEW(REDO.PDIS.PRODUCT) = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    R.NEW(REDO.PDIS.CURRENCY) = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
    R.NEW(REDO.PDIS.LOAN.AC) = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>

*PACS00254302_S
    R.NEW(REDO.PDIS.CUSTOMER) = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
RETURN
*PACS00254302_E

END
