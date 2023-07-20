* @ValidationCode : MjoyMjM5NzQxNzg6Q3AxMjUyOjE2ODkzMTE3MTMyMzI6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Jul 2023 10:45:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.SOYB.BAL.RT(ACCOUNT.ID)
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
    $INSERT  I_F.ST.L.APAP.SOYB
    $INSERT  I_APAP.SOYB.BAL.COMMON
    $INSERT  I_F.DATES

    GOSUB GET_SET_ACCT_INFO
RETURN
GET_SET_ACCT_INFO:
    CALL F.READ(FN.AC, ACCOUNT.ID, R.ACC, F.AC, '')
    IF R.ACC NE '' THEN
        Y.ID = ACCOUNT.ID
        Y.NUM.CUENTA = ACCOUNT.ID
        Y.START.YEAR.BAL = R.ACC<AC.START.YEAR.BAL>
        Y.FECHA.PROCESO = Y.FECHA
        Y.CATEGORIA = R.ACC<AC.CATEGORY>
        GOSUB WRITE.TABLE
    END
RETURN

WRITE.TABLE:
    R.REGISTRO<ST.SOYB.NUMERO.CUENTA> = Y.NUM.CUENTA
    R.REGISTRO<ST.SOYB.CATEGORIA> = Y.CATEGORIA
    R.REGISTRO<ST.SOYB.BALANCE> = Y.START.YEAR.BAL
    R.REGISTRO<ST.SOYB.FECHA.PROCESO> = Y.FECHA
    CALL F.WRITE(FN.SOYB, Y.ID, R.REGISTRO)
    CALL JOURNAL.UPDATE(Y.ID)

RETURN

END
