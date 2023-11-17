* @ValidationCode : Mjo4MzU3MjQ4NTc6Q3AxMjUyOjE2ODExMDk4NDMyMTc6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 12:27:23
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
SUBROUTINE REDO.TT.DS.TAX.AMT(Y.WV.TAX.AMT)
    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, = TO EQ
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------
    
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :BTORRESALBORNOZ
*Program   Name    :REDO.DS.MET.PAY.METHOD
*Modify            :btorresalbornoz
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the PAY.METHOD value from EB.LOOKUP TABLE
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
    Y.WV.TAX.AMT=0
    LOC.REF.FIELD = 'L.TT.TAX.AMT':@VM:'L.TT.WV.TAX'
    LOC.REF.APP = 'TELLER'
    LOC.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)
    L.TT.TAX.AMT.POS = LOC.POS<1,1>
    L.TT.WV.TAX  = LOC.POS<1,2>


    Y.WV.TAX =  R.NEW(TT.TE.LOCAL.REF)<1,L.TT.WV.TAX>

    IF Y.WV.TAX EQ 'NO' THEN          ;** R22 Auto conversion - = TO EQ
        Y.WV.TAX.AMT  = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.TAX.AMT.POS>
        Y.WV.TAX.AMT =  Y.WV.TAX.AMT[1,9]


    END

    Y.WV.TAX.AMT= FMT(Y.WV.TAX.AMT,"9R,2")
RETURN
END
