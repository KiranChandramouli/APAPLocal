* @ValidationCode : MjoxODU3MDUzNzMwOkNwMTI1MjoxNjg0NTAyMzc4MDg5OmFqaXRoOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 18:49:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE ATM.DUP.CHECK(UNIQUE.ID,OUTGOING)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATM.REVERSAL

*

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN


OPEN.FILES:

    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)


RETURN

PROCESS:
    UNIQUEID = UNIQUE.ID
    CALL F.READ(FN.ATM.REVERSAL,UNIQUEID,R.ATM.REVERSAL,F.ATM.REVERSAL,ERR.REV)
    IF R.ATM.REVERSAL THEN

        GOSUB FORM.OUTGOING
    END ELSE
        GOSUB FORM.OUTGOING1
    END
RETURN

FORM.OUTGOING:
*-------------*
    OUTGOING = ''
    OUTGOING = 'gOFSUtilName:1:1=FUNDS.TRANSFER,ATM.DUP'
    OUTGOING:= '$':'gOFSFunction:1:1=I'
    FT.ID = ""
    OUTGOING := '$':'gOFSId:1:1=':FT.ID:'$'


RETURN          ;*From FORM.OUTGOING

FORM.OUTGOING1:
*-------------*
    OUTGOING = ''
    OUTGOING = 'gOFSUtilName:1:1=FUNDS.TRANSFER,ATM.FP'
    OUTGOING:= '$':'gOFSFunction:1:1=I'
    FT.ID = ""
    OUTGOING := '$':'gOFSId:1:1=':FT.ID:'$'


RETURN          ;*From FORM.OUTGOING
