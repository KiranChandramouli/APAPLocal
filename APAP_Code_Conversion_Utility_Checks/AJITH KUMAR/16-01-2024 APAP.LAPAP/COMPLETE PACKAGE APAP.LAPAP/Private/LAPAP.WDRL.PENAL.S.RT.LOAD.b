* @ValidationCode : MjoxMzc2Nzc2NzAwOkNwMTI1MjoxNjkwMTY3OTE4MjkxOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:35:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.WDRL.PENAL.S.RT.LOAD
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       BP Removed
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.DATES
    $INSERT  I_F.ST.LAPAP.DECREASE.CHG.PAR
    $INSERT  I_LAPAP.WDRL.PENAL.S.RT.COMMON

    GOSUB INITIAL
    GOSUB GET.PARAMS
RETURN
INITIAL:
    FN.ACCT.AC = 'FBNK.ACCT.ACTIVITY'
    FV.ACCT.AC = ''
    CALL OPF(FN.ACCT.AC,FV.ACCT.AC)

    FN.AC = "FBNK.ACCOUNT"
    FV.AC = ""
    CALL OPF(FN.AC,FV.AC)

    FN.DCHG.PAR = "FBNK.ST.LAPAP.DECREASE.CHG.PAR"
    FV.DCHG.PAR = ""
    CALL OPF(FN.DCHG.PAR,FV.DCHG.PAR)

    Y.FECHA = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.YEAR = Y.FECHA[1,4]
    Y.MONTH = Y.FECHA[5,2]
    Y.MONTH = Y.MONTH *1;


RETURN

GET.PARAMS:
*    CALL F.READ(FN.DCHG.PAR, "SYSTEM", R.DCHG.PAR, FV.DCHG.PAR, DCHG.PAR.ERR)
IDVAR.1 = "SYSTEM" ;* R22 UTILITY AUTO CONVERSION
    CALL F.READ(FN.DCHG.PAR, IDVAR.1, R.DCHG.PAR, FV.DCHG.PAR, DCHG.PAR.ERR);* R22 UTILITY AUTO CONVERSION
    Y.PA.CATEGORY = R.DCHG.PAR<ST.LAP62.ACC.CATEGORY>
    Y.PA.CHG.CODE = R.DCHG.PAR<ST.LAP62.CHARGE.CODE>

RETURN

END
