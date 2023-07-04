* @ValidationCode : MjoxNjkyMzgzMjI3OkNwMTI1MjoxNjgxOTA1NjgwMjcwOklUU1M6LTE6LTE6LTk6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -9
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.MET.PAY.METHOD(PAY.METHOD)
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :BTORRESALBORNOZ
*Program Name :REDO.DS.MET.PAY.METHOD
*Modify :btorresalbornoz
*---------------------------------------------------------------------------------
*DESCRIPTION :This program is used to get the PAY.METHOD value from EB.LOOKUP TABLE
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION               = TO EQ
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES

* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.USER
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********

    LOC.REF.FIELD = 'L.TT.MET.OF.PAY'
    LOC.REF.APP = 'TELLER'
    LOC.POS = ''
    CALL GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)
    VAR.PAY.METHOD = R.NEW(TT.TE.LOCAL.REF)<1,LOC.POS>

    IF VAR.PAY.METHOD EQ 'CASH' THEN ;* AUTO R22 CODE CONVERSION
        PAY.METHOD = 'EFECTIVO'
    END
    IF VAR.PAY.METHOD EQ 'CHECK' THEN ;* AUTO R22 CODE CONVERSION
        PAY.METHOD = 'CHEQUE'
    END
    PAY.METHOD=FMT(PAY.METHOD,'R8')
RETURN
END
