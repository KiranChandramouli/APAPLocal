* @ValidationCode : MjotOTcwOTkxMTE1OkNwMTI1MjoxNjg0ODQyMTAyMzg5OklUU1M6LTE6LTE6LTg6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FT.DS.TAX.AMT(Y.WV.TAX.AMT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :BTORRESALBORNOZ
*Program   Name    :REDO.DS.MET.PAY.METHOD
*Modify            :btorresalbornoz
** 06-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 06-04-2023 Skanda R22 Manual Conversion line no 39
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the PAY.METHOD value from EB.LOOKUP TABLE
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.USER
    $INSERT I_F.FUNDS.TRANSFER
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********
    Y.WV.TAX.AMT=0
    LOC.REF.FIELD = 'L.TT.TAX.AMT':@VM:'L.TT.WV.TAX'
    LOC.REF.APP = 'FUNDS.TRANSFER'
    LOC.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)
    L.TT.TAX.AMT.POS = LOC.POS<1,1>
    L.TT.WV.TAX  = LOC.POS<1,2>


    Y.WV.TAX =  R.NEW(FT.LOCAL.REF)<1,L.TT.WV.TAX>

    IF Y.WV.TAX EQ 'NO' THEN ;* R22 Auto conversion
        Y.WV.TAX.AMT  = R.NEW(FT.LOCAL.REF)<1,L.TT.TAX.AMT.POS>
        Y.WV.TAX.AMT =  Y.WV.TAX.AMT[1,9]


    END

    Y.WV.TAX.AMT= FMT(Y.WV.TAX.AMT,"9R,2")
RETURN
END
