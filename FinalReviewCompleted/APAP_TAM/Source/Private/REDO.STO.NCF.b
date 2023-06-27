* @ValidationCode : MjotMTgyNTgzMTA2NDpDcDEyNTI6MTY4NjY3NzI5MDY3MDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:58:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE REDO.STO.NCF(FT.ID,R.FT)
    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 13.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 13.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*------------------------------------------------------------------------------------------------------
    

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $USING APAP.REDOCHNLS
    $USING APAP.REDOVER
    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

*    CALL F.READ(FN.FT,FT.ID,R.FT,F.FT,E.FT)
    MATPARSE R.NEW FROM R.FT

    Y.V$FUNCTION = V$FUNCTION
    V$FUNCTION = 'I'
*CALL REDO.V.CHK.TAX.CHRG
** R22 Manual conversion
    APAP.REDOVER.redoVChkTaxChrg()
*CALL REDO.ARC.FT.CALC.COMM
** R22 Manual conversion
    APAP.REDOCHNLS.redoArcFtCalcComm()
*CALL REDO.V.FT.AUTH.UPD.NCF
    APAP.REDOVER.redoVFtAuthUpdNcf()
*CALL REDO.V.AUTH.FT.WV.COMTAX
** R22 Manual conversion
    APAP.REDOVER.redoVAuthFtWvComtax()
    V$FUNCTION = Y.V$FUNCTION
*    MATBUILD R.FT FROM R.NEW
    CALL F.MATWRITE(FN.FT,FT.ID,MAT R.NEW,STD.ORDER.REC.SIZE)

RETURN
END
