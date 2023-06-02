* @ValidationCode : Mjo5NTA4MjA5Nzg6Q3AxMjUyOjE2ODQ5MjcyNjIwNjk6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 May 2023 16:51:02
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
$PACKAGE APAP.TAM
SUBROUTINE  REDO.LY.INPUT.USMOVREV
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to make the proper reverse of points movements.
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.INPUT.USMOVREV
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*03.06.2013    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
* 19-05-2023  Conversion Tool     R22 Auto Conversion - TNO TO C$T24.SESSION.NO AND ++ TO + =1
* 19-05-2023  ANIL KUMAR B        R22 Manual Conversion - Y.PTS.QTYORVAL to Y.US.QTYORVAL
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.LY.POINTS.US
    $INSERT I_F.REDO.LY.MASTERPRGDR
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_F.REDO.LY.POINTS.TOT
    $INSERT I_GTS.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN

*----
INIT:
*----

    FN.REDO.LY.POINTS.US = 'F.REDO.LY.POINTS.US'
    F.REDO.LY.POINTS.US = ''
    CALL OPF(FN.REDO.LY.POINTS.US,F.REDO.LY.POINTS.US)

    FN.REDO.LY.MASTERPRGDR = 'F.REDO.LY.MASTERPRGDR'
    F.REDO.LY.MASTERPRGDR = ''
    CALL OPF(FN.REDO.LY.MASTERPRGDR,F.REDO.LY.MASTERPRGDR)

    FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM = ''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

    FN.REDO.LY.POINTS.TOT = 'F.REDO.LY.POINTS.TOT'
    F.REDO.LY.POINTS.TOT = ''
    CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

    G.DATE = ''
    I.DATE = DATE()
    CALL DIETER.DATE(G.DATE,I.DATE,'')

RETURN

*-------
PROCESS:
*-------

    CUS.ID = R.NEW(REDO.PT.US.CUSTOMER.NO)
    Y.US.QTYORVAL = R.NEW(REDO.PT.US.QTYORVAL)
    Y.US.QTY.VALUE = R.NEW(REDO.PT.US.QTYORVAL.TO.US)
    Y.US.STATUS = R.NEW(REDO.PT.US.STATUS.US)

    Y.US.QTY.VALUE = FMT(Y.US.QTY.VALUE,0)

    IF Y.US.STATUS EQ 4 THEN
        GOSUB GET.POINTS.EQ
        GOSUB UPD.PTS.ONLINE
    END

RETURN

*-------------
GET.POINTS.EQ:
*-------------

    R.REDO.LY.MASTERPRGDR = '' ; MAS.ERR = ''

*  CALL F.READ(FN.REDO.LY.MASTERPRGDR,'SYSTEM',R.REDO.LY.MASTERPRGDR,F.REDO.LY.MASTERPRGDR,MAS.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.LY.MASTERPRGDR,'SYSTEM',R.REDO.LY.MASTERPRGDR,MAS.ERR) ; * Tus End
    IF R.REDO.LY.MASTERPRGDR THEN
        Y.MASTER.PRG = R.REDO.LY.MASTERPRGDR<REDO.MASPRG.MASTER.PRG>
    END

    R.REDO.LY.PROGRAM = ''; PRG.ERR = ''
    CALL F.READ(FN.REDO.LY.PROGRAM,Y.MASTER.PRG,R.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM,PRG.ERR)
    IF R.REDO.LY.PROGRAM THEN
        Y.PT.VAL.PRG = R.REDO.LY.PROGRAM<REDO.PROG.POINT.VALUE>
    END
    
*IF Y.PTS.QTYORVAL EQ 'Puntos' THEN
    IF Y.US.QTYORVAL EQ 'Puntos' THEN  ;* R22 Manual con Y.PTS.QTYORVAL to Y.US.QTYORVAL
        Y.US.QUANTITY.VAL = Y.US.QTY.VALUE * Y.PT.VAL.PRG
        Y.US.QUANTITY.VAL = FMT(Y.US.QUANTITY.VAL,0)
        Y.US.QUANTITY = FMT(Y.US.QTY.VALUE,0)
    END ELSE
        Y.US.QUANTITY = Y.US.QTY.VALUE / Y.PT.VAL.PRG
        Y.US.QUANTITY = FMT(Y.US.QUANTITY,0)
        Y.US.QUANTITY.VAL = FMT(Y.US.QTY.VALUE,0)
    END

RETURN

*--------------
UPD.PTS.ONLINE:
*--------------

    TOT.POINTS.ID = CUS.ID:'ONLINEDEB'
    R.REDO.LY.POINTS.TOT =''
    CALL F.READ(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR)
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT.TOT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)

RETURN

*-----------
UPD.PROCESS:
*-----------

    VAR.AVAIL = 0 ; VAR.AVAIL.VALUE = 0
    VAR.USED = 0 ; VAR.USED.VALUE = 0

    IF R.REDO.LY.POINTS.TOT EQ '' THEN
        VAR.AVAIL = 0
        VAR.AVAIL.VALUE = 0
        VAR.USED = 0
        VAR.USED.VALUE = 0
    END ELSE
        VAR.AVAIL = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS>
        VAR.AVAIL.VALUE = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.VALUE>
        VAR.USED = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.POINTS>
        VAR.USED.VALUE = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.VALUE>
    END

    VAR.USED -= Y.US.QUANTITY
    VAR.USED.VALUE -= Y.US.QUANTITY.VAL
    VAR.AVAIL += Y.US.QUANTITY
    VAR.AVAIL.VALUE += Y.US.QUANTITY.VAL

    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS> = VAR.AVAIL
    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.VALUE> = VAR.AVAIL.VALUE
    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.POINTS> = VAR.USED
    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.VALUE> = VAR.USED.VALUE

RETURN

*----------------
ASSIGN.AUDIT.TOT:
*----------------

    CURR.NO = ''
    CUR.TIME = OCONV(TIME(), "MT")

    CHANGE ':' TO '' IN CUR.TIME
    CURR.NO = R.REDO.LY.POINTS.TOT<REDO.PT.T.CURR.NO>
    IF CURR.NO EQ '' THEN
        CURR.NO = 1
    END ELSE
        CURR.NO += 1
    END
    R.REDO.LY.POINTS.TOT<REDO.PT.T.RECORD.STATUS> = ''
    R.REDO.LY.POINTS.TOT<REDO.PT.T.CURR.NO> = CURR.NO
    R.REDO.LY.POINTS.TOT<REDO.PT.T.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR  ;*R22 AUTO CONVERSION
    R.REDO.LY.POINTS.TOT<REDO.PT.T.DATE.TIME> = G.DATE[3,6]:CUR.TIME
    R.REDO.LY.POINTS.TOT<REDO.PT.T.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR  ;*R22 AUTO CONVERSION
    R.REDO.LY.POINTS.TOT<REDO.PT.T.CO.CODE> = ID.COMPANY
    R.REDO.LY.POINTS.TOT<REDO.PT.T.DEPT.CODE> = 1

RETURN

*----------------------------------------------------------------------------------
END
