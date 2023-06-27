* @ValidationCode : MjotMTk0NzI4NTc5NjpDcDEyNTI6MTY4NDg1Njg3OTM1NDpJVFNTOi0xOi0xOjM5OToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 399
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*10-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*10-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
SUBROUTINE DR.REGN22.RCL.NOMINAL.VAL
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER

    FN.SEC.TRADE = 'F.SEC.TRADE'
    F.SEC.TRADE = ''
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)
    R.SEC.TRADE = ''
    CALL F.READ(FN.SEC.TRADE,COMI,R.SEC.TRADE,F.SEC.TRADE,SEC.TRADE.ERR)
    SEC.MASTER.ID = R.SEC.TRADE<SC.SBS.SECURITY.CODE>
    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER = ''
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)
    R.SECURITY.MASTER = ''
    CALL F.READ(FN.SECURITY.MASTER,SEC.MASTER.ID,R.SECURITY.MASTER,F.SECURITY.MASTER,SECURITY.MASTER.ERR)
**    NOMINAL.VAL = R.SECURITY.MASTER<SC.SCM.TRADING.UNITS> * R.SECURITY.MASTER<SC.SCM.LAST.PRICE>
    NOMINAL.VAL = R.SECURITY.MASTER<SC.SCM.TRADING.UNITS> * R.SEC.TRADE<SC.SBS.CUST.NO.NOM>
    COMI = NOMINAL.VAL
RETURN

END
