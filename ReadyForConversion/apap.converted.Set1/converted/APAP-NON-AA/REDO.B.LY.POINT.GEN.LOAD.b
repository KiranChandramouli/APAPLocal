SUBROUTINE REDO.B.LY.POINT.GEN.LOAD
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine initialises and retrieves data for the local common variable
* This routine is the load routine of the batch job REDO.B.LY.POINT.GEN which updates
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
*--------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES

    $INSERT I_REDO.B.LY.POINT.GEN.COMMON

    GOSUB OPEN.FILES
    GOSUB INIT
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
    PRG.POINT.USE.LST = ''   ; PRG.MOD.TYP = '';
    PRG.MOD.EVE = ''         ; PRG.PTS.IN.MOD = '';
    PRG.PROD.LST = ''        ; PRG.COND.TYPE.EXINC = '';
    PRG.APP.EXC.COND = ''    ; PRG.EXC.EST.ACCT = '';
    PRG.APP.INC.COND = ''    ; PRG.INC.EST.ACCT = '';
    PRG.AIR.LST = ''         ; PRG.MINGEN.IN.MOD = '';
    PRG.MAXGEN.IN.MOD = ''   ; PRG.FORM.GEN.IN.MOD = '';
    PRG.GEN.AMT.IN.MOD = ''  ; PRG.CCY.IN.MOD = '';

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

    DATES.ID = 'DO0010001-COB'
    R.DAT = ''; DATES.ERR = ''
    CALL CACHE.READ(FN.DATES, DATES.ID, R.DAT, DATES.ERR)
    IF R.DAT THEN
        Y.NEXT.WRK.DATE = R.DAT<EB.DAT.NEXT.WORKING.DAY>
        NEXT.MONTH = Y.NEXT.WRK.DATE[5,2]
    END

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

    FN.DATES = 'F.DATES'
    F.DATES = ''
    CALL OPF(FN.DATES,F.DATES)

    FN.ACCT.ENT.TODAY = 'F.ACCT.ENT.TODAY'
    F.ACCT.ENT.TODAY = ''
    CALL OPF(FN.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY)

    FN.BALANCE.MOVEMENT = 'F.BALANCE.MOVEMENT'
    F.BALANCE.MOVEMENT = ''
    CALL OPF(FN.BALANCE.MOVEMENT,F.BALANCE.MOVEMENT)

    FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HIS = ''
    CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)

    FN.ACCT.ACTIVITY = 'F.ACCT.ACTIVITY'
    F.ACCT.ACTIVITY = ''
    CALL OPF(FN.ACCT.ACTIVITY,F.ACCT.ACTIVITY)


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

    FN.TEMP.LY.POINT.GEN = 'F.TEMP.LY.POINT.GEN'
    F.TEMP.LY.POINT.GEN = ''
    OPEN FN.TEMP.LY.POINT.GEN TO F.TEMP.LY.POINT.GEN ELSE

        TEXT = 'Error in opening : ':FN.TEMP.LY.POINT.GEN
        CALL FATAL.ERROR('REDO.B.LY.POINT.GEN.LOAD')
    END

RETURN

*-------
GET.VAL:
*-------


*  READ PRG.MOD.LST FROM F.TEMP.LY.POINT.GEN,'MOD' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'MOD',PRG.MOD.LST,F.TEMP.LY.POINT.GEN,PRG.MOD.LST.ERR)
    IF PRG.MOD.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.PER.MOD FROM F.TEMP.LY.POINT.GEN,'NOPRG' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'NOPRG',PRG.PER.MOD,F.TEMP.LY.POINT.GEN,PRG.PER.MOD.ERR)
    IF PRG.PER.MOD.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.LST FROM F.TEMP.LY.POINT.GEN,'PRG' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'PRG',PRG.LST,F.TEMP.LY.POINT.GEN,PRG.LST.ERR)
    IF PRG.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.ST.DATE.LST FROM F.TEMP.LY.POINT.GEN,'ST.DATE' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'ST.DATE',PRG.ST.DATE.LST,F.TEMP.LY.POINT.GEN,PRG.ST.DATE.LST.ERR)
    IF PRG.ST.DATE.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.END.DATE.LST FROM F.TEMP.LY.POINT.GEN,'END.DATE' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'END.DATE',PRG.END.DATE.LST,F.TEMP.LY.POINT.GEN,PRG.END.DATE.LST.ERR)
    IF PRG.END.DATE.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.DAYS.EXP.LST FROM F.TEMP.LY.POINT.GEN,'DAYS.EXP' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'DAYS.EXP',PRG.DAYS.EXP.LST,F.TEMP.LY.POINT.GEN,PRG.DAYS.EXP.LST.ERR)
    IF PRG.DAYS.EXP.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.EXP.DATE.LST FROM F.TEMP.LY.POINT.GEN,'EXP.DATE' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'EXP.DATE',PRG.EXP.DATE.LST,F.TEMP.LY.POINT.GEN,PRG.EXP.DATE.LST.ERR)
    IF PRG.EXP.DATE.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.CUS.GRP.LST FROM F.TEMP.LY.POINT.GEN,'CUS.GROUP' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'CUS.GROUP',PRG.CUS.GRP.LST,F.TEMP.LY.POINT.GEN,PRG.CUS.GRP.LST.ERR)
    IF PRG.CUS.GRP.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.POINT.VALUE.LST FROM F.TEMP.LY.POINT.GEN,'POINT.VALUE' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'POINT.VALUE',PRG.POINT.VALUE.LST,F.TEMP.LY.POINT.GEN,PRG.POINT.VALUE.LST.ERR)
    IF PRG.POINT.VALUE.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.AVAIL.IF.DELAY.LST FROM F.TEMP.LY.POINT.GEN,'AVAIL.IF.DELAY' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'AVAIL.IF.DELAY',PRG.AVAIL.IF.DELAY.LST,F.TEMP.LY.POINT.GEN,PRG.AVAIL.IF.DELAY.LST.ERR)
    IF PRG.AVAIL.IF.DELAY.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.POINT.USE.LST FROM F.TEMP.LY.POINT.GEN,'POINT.USE' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'POINT.USE',PRG.POINT.USE.LST,F.TEMP.LY.POINT.GEN,PRG.POINT.USE.LST.ERR)
    IF PRG.POINT.USE.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.COND.TYPE.EXINC FROM F.TEMP.LY.POINT.GEN,'COND.TYPE.EXINC' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'COND.TYPE.EXINC',PRG.COND.TYPE.EXINC,F.TEMP.LY.POINT.GEN,PRG.COND.TYPE.EXINC.ERR)
    IF PRG.COND.TYPE.EXINC.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.APP.EXC.COND FROM F.TEMP.LY.POINT.GEN,'APP.EXC.COND' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'APP.EXC.COND',PRG.APP.EXC.COND,F.TEMP.LY.POINT.GEN,PRG.APP.EXC.COND.ERR)
    IF PRG.APP.EXC.COND.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.EXC.EST.ACCT FROM F.TEMP.LY.POINT.GEN,'EXC.EST.ACCT' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'EXC.EST.ACCT',PRG.EXC.EST.ACCT,F.TEMP.LY.POINT.GEN,PRG.EXC.EST.ACCT.ERR)
    IF PRG.EXC.EST.ACCT.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.APP.INC.COND FROM F.TEMP.LY.POINT.GEN,'APP.INC.COND' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'APP.INC.COND',PRG.APP.INC.COND,F.TEMP.LY.POINT.GEN,PRG.APP.INC.COND.ERR)
    IF PRG.APP.INC.COND.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.INC.EST.ACCT FROM F.TEMP.LY.POINT.GEN,'INC.EST.ACCT' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'INC.EST.ACCT',PRG.INC.EST.ACCT,F.TEMP.LY.POINT.GEN,PRG.INC.EST.ACCT.ERR)
    IF PRG.INC.EST.ACCT.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.MOD.TYP FROM F.TEMP.LY.POINT.GEN,'MOD.TYPE' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'MOD.TYPE',PRG.MOD.TYP,F.TEMP.LY.POINT.GEN,PRG.MOD.TYP.ERR)
    IF PRG.MOD.TYP.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.MOD.EVE FROM F.TEMP.LY.POINT.GEN,'MOD.EVENT' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'MOD.EVENT',PRG.MOD.EVE,F.TEMP.LY.POINT.GEN,PRG.MOD.EVE.ERR)
    IF PRG.MOD.EVE.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.PTS.IN.MOD FROM F.TEMP.LY.POINT.GEN,'PTS.IN.MOD' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'PTS.IN.MOD',PRG.PTS.IN.MOD,F.TEMP.LY.POINT.GEN,PRG.PTS.IN.MOD.ERR)
    IF PRG.PTS.IN.MOD.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.PROD.LST FROM F.TEMP.LY.POINT.GEN,'PROD' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'PROD',PRG.PROD.LST,F.TEMP.LY.POINT.GEN,PRG.PROD.LST.ERR)
    IF PRG.PROD.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.MINGEN.IN.MOD FROM F.TEMP.LY.POINT.GEN,'MIN.GEN.IN.MOD' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'MIN.GEN.IN.MOD',PRG.MINGEN.IN.MOD,F.TEMP.LY.POINT.GEN,PRG.MINGEN.IN.MOD.ERR)
    IF PRG.MINGEN.IN.MOD.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.MAXGEN.IN.MOD FROM F.TEMP.LY.POINT.GEN,'MAX.GEN.IN.MOD' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'MAX.GEN.IN.MOD',PRG.MAXGEN.IN.MOD,F.TEMP.LY.POINT.GEN,PRG.MAXGEN.IN.MOD.ERR)
    IF PRG.MAXGEN.IN.MOD.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.FORM.GEN.IN.MOD FROM F.TEMP.LY.POINT.GEN,'FORM.GEN.IN.MOD' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'FORM.GEN.IN.MOD',PRG.FORM.GEN.IN.MOD,F.TEMP.LY.POINT.GEN,PRG.FORM.GEN.IN.MOD.ERR)
    IF PRG.FORM.GEN.IN.MOD.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.GEN.AMT.IN.MOD FROM F.TEMP.LY.POINT.GEN,'GEN.AMT.IN.MOD' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'GEN.AMT.IN.MOD',PRG.GEN.AMT.IN.MOD,F.TEMP.LY.POINT.GEN,PRG.GEN.AMT.IN.MOD.ERR)
    IF PRG.GEN.AMT.IN.MOD.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.CCY.IN.MOD FROM F.TEMP.LY.POINT.GEN,'CCY.IN.MOD' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'CCY.IN.MOD',PRG.CCY.IN.MOD,F.TEMP.LY.POINT.GEN,PRG.CCY.IN.MOD.ERR)
    IF PRG.CCY.IN.MOD.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END


*  READ PRG.AIR.LST FROM F.TEMP.LY.POINT.GEN,'AIR' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.POINT.GEN,'AIR',PRG.AIR.LST,F.TEMP.LY.POINT.GEN,PRG.AIR.LST.ERR)
    IF PRG.AIR.LST.ERR THEN  ;* Tus End
        GOSUB READ.NUSED
    END

RETURN

*----------
READ.NUSED:
*----------

    CRT 'Reading in the Record non-used for this generation'

RETURN

END
