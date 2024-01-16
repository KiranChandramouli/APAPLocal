* @ValidationCode : Mjo2NTM4OTcwMzA6Q3AxMjUyOjE2ODQyMjI4MDI5NTQ6SVRTUzotMTotMTo0ODk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 489
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     No changes
*21-04-2023      Mohanraj R          R22 Manual code conversion   No changes
SUBROUTINE LAPAP.CAMBIO.ESTADO

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT

    GOSUB MAIN.PROCESS
RETURN

MAIN.PROCESS:

    Y.ID = ID.NEW.LAST
    FN.AA.STATUS = 'F.ST.L.APAP.ARR.ESTATUS$NAU'
    FV.AA.STATUS = ''
    CALL OPF(FN.AA.STATUS,FV.AA.STATUS)
    CALL F.READ(FN.AA.STATUS,Y.ID,R.SS,FV.AA.STATUS,AA.SS.ERR)
    Y.STATUS = R.SS<2>
    AA.ID = R.SS<1>
    GOSUB SET.PROCESO
SET.PROCESO:
    FN.AA.ARR='F.AA.ARRANGEMENT'
    F.AA.ARR=''
    CALL OPF(FN.AA.ARR,F.AA.ARR)
*    CALL F.READ(FN.AA.ARR,AA.ID,R.AA,F.AA.ARR,AA.ARR.ERR)
    CALL F.READU(FN.AA.ARR,AA.ID,R.AA,F.AA.ARR,AA.ARR.ERR,'');* R22 UTILITY AUTO CONVERSION
    R.AA<AA.ARR.ARR.STATUS>=Y.STATUS
    CALL F.WRITE(FN.AA.ARR,AA.ID,R.AA)
* CALL JOURNAL.UPDATE("")
    AA.ID = ""
    Y.STATUS = ""
RETURN

END
