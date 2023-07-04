* @ValidationCode : Mjo3MDc1NzczNjc6Q3AxMjUyOjE2ODEyOTUyMTYzOTc6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 15:56:56
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
SUBROUTINE REDO.INT.CHECK.CRT
    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 12.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 12.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------
     

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
*-----------------------------------------------------------------------------

* Marimuthu S
* PACS00251842
*

    FN.AC = 'F.ACCOUNT'
    F.AC = ''
    CALL OPF(FN.AC,F.AC)

    Y.ID = R.NEW(FT.DEBIT.ACCT.NO)

    CALL F.READ(FN.AC,Y.ID,R.AC,F.AC,AC.ERR)
    IF NOT(R.AC) THEN
        CALL INT.ACC.OPEN(Y.ID,DSD)

        R.NEW(FT.DEBIT.ACCT.NO) = Y.ID
    END

RETURN

END
