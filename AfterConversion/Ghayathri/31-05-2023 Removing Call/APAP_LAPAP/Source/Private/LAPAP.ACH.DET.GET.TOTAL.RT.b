* @ValidationCode : Mjo4OTY0MDgzNzU6Q3AxMjUyOjE2ODIzMzU5NDU3OTE6SVRTUzotMTotMToxMDA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 100
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*----------------------------------------------------------------------------------------------------------------------
SUBROUTINE LAPAP.ACH.DET.GET.TOTAL.RT

    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.ACH.PROCESS.DET ;* AUTO R22 CODE CONVERSION END

    Y.VALOR = O.DATA

    FN.REDO.ACH.PROCESS.DET = 'F.REDO.ACH.PROCESS.DET'; F.REDO.ACH.PROCESS.DET = ''
    CALL OPF(FN.REDO.ACH.PROCESS.DET,F.REDO.ACH.PROCESS.DET)

    SEL.CMD = "SELECT " : FN.REDO.ACH.PROCESS.DET : " WITH EXEC.ID EQ '": Y.VALOR :"' AND STATUS EQ '01'"
    CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)

    O.DATA = NO.OF.REC

RETURN

END
