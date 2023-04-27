* @ValidationCode : MjotMTk5MTgxMzI3NTpDcDEyNTI6MTY4MTI3Njg2NTU5OTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:51:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LY.PGEN.BIRTH.LOAD
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine initialises and retrieves data for the local common variable
* This routine is the load routine of the batch job REDO.B.LY.PGEN.BIRTH which updates
*   REDO.LY.POINTS table based on the data defined in the parameter table
*   REDO.LY.MODALITY & REDO.LY.PROGRAM
* ------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 17-JUN-2013   RMONDRAGON        ODR-2011-06-0243      Initial Creation
* Date                   who                   Reference              
* 12-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM 
* 12-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES

    $INSERT I_REDO.B.LY.PGEN.BIRTH.COMMON

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB GET.VAL

RETURN

*----
INIT:
*----

    PRG.MOD.LST = ''         ; PRG.PER.MOD = '';
    PRG.LST = ''             ; PRG.ST.DATE.LST = '';
    PRG.END.DATE.LST = ''    ; PRG.DAYS.EXP.LST = '';
    PRG.EXP.DATE.LST = ''    ; PRG.CUS.GRP.LST = '';
    PRG.POINT.VALUE.LST = '' ; PRG.AVAIL.IF.DELAY.LST = '';
    PRG.POINT.USE.LST = ''   ; PRG.PTS.IN.MOD = '';
    PRG.PROD.LST = ''        ; PRG.COND.TYPE.EXINC = '';
    PRG.APP.EXC.COND = ''    ; PRG.EXC.EST.ACCT = '';
    PRG.APP.INC.COND = ''    ; PRG.INC.EST.ACCT = '';
    PRG.AIR.LST = ''         ; PRG.CCY.IN.MOD = ''

    G.DATE = ''
    I.DATE = DATE()
    CALL DIETER.DATE(G.DATE,I.DATE,'')

    CUR.DAY   = TODAY[7,2]
    CUR.MONTH = TODAY[5,2]
    CUR.YEAR  = TODAY[1,4]

    LOC.REF.POS = ''
    LOC.REF.APP = 'CUSTOMER':@FM:'ACCOUNT'
    LOC.REF.FIELD = 'L.CU.G.LEALTAD':@FM:'L.AC.STATUS1':@VM:'L.AC.STATUS2'
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.REF.POS)
    POS.L.CU.G.LEALTAD = LOC.REF.POS<1,1>
    POS.L.AC.STATUS1 = LOC.REF.POS<2,1>
    POS.L.AC.STATUS2 = LOC.REF.POS<2,2>

RETURN

*----------
OPEN.FILES:
*----------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.LY.POINTS = 'F.REDO.LY.POINTS'
    F.REDO.LY.POINTS = ''
    CALL OPF(FN.REDO.LY.POINTS,F.REDO.LY.POINTS)

    FN.REDO.LY.POINTS.TOT = 'F.REDO.LY.POINTS.TOT'
    F.REDO.LY.POINTS.TOT = ''
    CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

    FN.REDO.LY.MASTERPRGDR = 'F.REDO.LY.MASTERPRGDR'
    F.REDO.LY.MASTERPRGDR = ''
    CALL OPF(FN.REDO.LY.MASTERPRGDR,F.REDO.LY.MASTERPRGDR)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.TEMP.LY.PGEN.BIRTH = 'F.TEMP.LY.PGEN.BIRTH'
    F.TEMP.LY.PGEN.BIRTH = ''
    OPEN FN.TEMP.LY.PGEN.BIRTH TO F.TEMP.LY.PGEN.BIRTH ELSE

        TEXT = 'Error in opening : ':FN.TEMP.LY.PGEN.BIRTH
        CALL FATAL.ERROR('REDO.B.LY.PGEN.BIRTH.LOAD')
    END

RETURN

*-------
GET.VAL:
*-------


*  READ PRG.MOD.LST FROM F.TEMP.LY.PGEN.BIRTH,'MOD' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'MOD',PRG.MOD.LST,F.TEMP.LY.PGEN.BIRTH,PRG.MOD.LST.ERR)
    IF PRG.MOD.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.MOD.LST FROM F.TEMP.LY.PGEN.BIRTH,'MOD' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'MOD',PRG.MOD.LST,F.TEMP.LY.PGEN.BIRTH,PRG.MOD.LST.ERR)
    IF PRG.MOD.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.PER.MOD FROM F.TEMP.LY.PGEN.BIRTH,'NOPRG' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'NOPRG',PRG.PER.MOD,F.TEMP.LY.PGEN.BIRTH,PRG.PER.MOD.ERR)
    IF PRG.PER.MOD.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.LST FROM F.TEMP.LY.PGEN.BIRTH,'PRG' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'PRG',PRG.LST,F.TEMP.LY.PGEN.BIRTH,PRG.LST.ERR)
    IF PRG.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.ST.DATE.LST FROM F.TEMP.LY.PGEN.BIRTH,'ST.DATE' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'ST.DATE',PRG.ST.DATE.LST,F.TEMP.LY.PGEN.BIRTH,PRG.ST.DATE.LST.ERR)
    IF PRG.ST.DATE.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.END.DATE.LST FROM F.TEMP.LY.PGEN.BIRTH,'END.DATE' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'END.DATE',PRG.END.DATE.LST,F.TEMP.LY.PGEN.BIRTH,PRG.END.DATE.LST.ERR)
    IF PRG.END.DATE.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.DAYS.EXP.LST FROM F.TEMP.LY.PGEN.BIRTH,'DAYS.EXP' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'DAYS.EXP',PRG.DAYS.EXP.LST,F.TEMP.LY.PGEN.BIRTH,PRG.DAYS.EXP.LST.ERR)
    IF PRG.DAYS.EXP.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.EXP.DATE.LST FROM F.TEMP.LY.PGEN.BIRTH,'EXP.DATE' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'EXP.DATE',PRG.EXP.DATE.LST,F.TEMP.LY.PGEN.BIRTH,PRG.EXP.DATE.LST.ERR)
    IF PRG.EXP.DATE.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.CUS.GRP.LST FROM F.TEMP.LY.PGEN.BIRTH,'CUS.GROUP' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'CUS.GROUP',PRG.CUS.GRP.LST,F.TEMP.LY.PGEN.BIRTH,PRG.CUS.GRP.LST.ERR)
    IF PRG.CUS.GRP.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.POINT.VALUE.LST FROM F.TEMP.LY.PGEN.BIRTH,'POINT.VALUE' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'POINT.VALUE',PRG.POINT.VALUE.LST,F.TEMP.LY.PGEN.BIRTH,PRG.POINT.VALUE.LST.ERR)
    IF PRG.POINT.VALUE.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.AVAIL.IF.DELAY.LST FROM F.TEMP.LY.PGEN.BIRTH,'AVAIL.IF.DELAY' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'AVAIL.IF.DELAY',PRG.AVAIL.IF.DELAY.LST,F.TEMP.LY.PGEN.BIRTH,PRG.AVAIL.IF.DELAY.LST.ERR)
    IF PRG.AVAIL.IF.DELAY.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.POINT.USE.LST FROM F.TEMP.LY.PGEN.BIRTH,'POINT.USE' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'POINT.USE',PRG.POINT.USE.LST,F.TEMP.LY.PGEN.BIRTH,PRG.POINT.USE.LST.ERR)
    IF PRG.POINT.USE.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.COND.TYPE.EXINC FROM F.TEMP.LY.PGEN.BIRTH,'COND.TYPE.EXINC' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'COND.TYPE.EXINC',PRG.COND.TYPE.EXINC,F.TEMP.LY.PGEN.BIRTH,PRG.COND.TYPE.EXINC.ERR)
    IF PRG.COND.TYPE.EXINC.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.APP.EXC.COND FROM F.TEMP.LY.PGEN.BIRTH,'APP.EXC.COND' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'APP.EXC.COND',PRG.APP.EXC.COND,F.TEMP.LY.PGEN.BIRTH,PRG.APP.EXC.COND.ERR)
    IF PRG.APP.EXC.COND.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.EXC.EST.ACCT FROM F.TEMP.LY.PGEN.BIRTH,'EXC.EST.ACCT' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'EXC.EST.ACCT',PRG.EXC.EST.ACCT,F.TEMP.LY.PGEN.BIRTH,PRG.EXC.EST.ACCT.ERR)
    IF PRG.EXC.EST.ACCT.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.APP.INC.COND FROM F.TEMP.LY.PGEN.BIRTH,'APP.INC.COND' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'APP.INC.COND',PRG.APP.INC.COND,F.TEMP.LY.PGEN.BIRTH,PRG.APP.INC.COND.ERR)
    IF PRG.APP.INC.COND.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.INC.EST.ACCT FROM F.TEMP.LY.PGEN.BIRTH,'INC.EST.ACCT' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'INC.EST.ACCT',PRG.INC.EST.ACCT,F.TEMP.LY.PGEN.BIRTH,PRG.INC.EST.ACCT.ERR)
    IF PRG.INC.EST.ACCT.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.PTS.IN.MOD FROM F.TEMP.LY.PGEN.BIRTH,'PTS.IN.MOD' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'PTS.IN.MOD',PRG.PTS.IN.MOD,F.TEMP.LY.PGEN.BIRTH,PRG.PTS.IN.MOD.ERR)
    IF PRG.PTS.IN.MOD.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.PROD.LST FROM F.TEMP.LY.PGEN.BIRTH,'PROD' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'PROD',PRG.PROD.LST,F.TEMP.LY.PGEN.BIRTH,PRG.PROD.LST.ERR)
    IF PRG.PROD.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.CCY.IN.MOD FROM F.TEMP.LY.PGEN.BIRTH,'CCY.IN.MOD' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'CCY.IN.MOD',PRG.CCY.IN.MOD,F.TEMP.LY.PGEN.BIRTH,PRG.CCY.IN.MOD.ERR)
    IF PRG.CCY.IN.MOD.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.AIR.LST FROM F.TEMP.LY.PGEN.BIRTH,'AIR' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.PGEN.BIRTH,'AIR',PRG.AIR.LST,F.TEMP.LY.PGEN.BIRTH,PRG.AIR.LST.ERR)
    IF PRG.AIR.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END

RETURN

*----------
READ.NUSED:
*----------

    CRT 'Reading in the record non-used for this generation'

RETURN

END
